CREATE TABLE IF NOT EXISTS public.utilisateur_streak (
    utilisateur_id uuid PRIMARY KEY,
    current_streak int NOT NULL DEFAULT 0 CHECK (current_streak <=4 AND current_streak >= 0),
    last_updated timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.saison (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE OR REPLACE FUNCTION public.calculer_streak()
RETURNS trigger AS $$
DECLARE
    seuil_initial_actions_quotidienne INT := 3;
    n_actions_quotidienne INT;
    n_actions_hebdomadaire INT;
    date_debut_saison DATE;
    date_fin_saison DATE;
    last_streak_update timestamptz;
    phase_strak INT;
BEGIN
    --Récupération de la fin de saison
    SELECT start_date, end_date 
    INTO date_debut_saison, date_fin_saison
    FROM public.saison
    WHERE NOW() BETWEEN start_date AND (end_date + INTERVAL '1 day') 
    LIMIT 1;

    -- Récupération des infos de streak 
    SELECT last_updated, current_streak 
    INTO last_streak_update, phase_strak
    FROM public.utilisateur_streak
    WHERE utilisateur_id = NEW.utilisateur_id;

    -- Si l'utilisateur n'a jamais eu de streak, on initialise les valeurs
    IF NOT FOUND THEN
        last_streak_update := date_debut_saison; -- on considère que le streak commence au début de la saison pour les nouveaux utilisateurs
        phase_strak := 0;
    END IF;

    -- Comptage des actions réalisées depuis le dernier update de streak
    SELECT 
        COUNT(*) FILTER (WHERE actions.frequence = 'journalier')
    INTO n_actions_quotidienne
    FROM public.realisation_actions
    JOIN public.actions ON realisation_actions.action_id = actions.id
    WHERE realisation_actions.utilisateur_id = NEW.utilisateur_id
    AND realisation_actions.date_realisation <= date_fin_saison
    AND realisation_actions.date_realisation >= last_streak_update;

    --  Logique de décision
    -- Si la saison est finie ou si l'utilisateur n'a pas été actif depuis 2 semaines, on reset le streak
    IF date_debut_saison > last_streak_update OR NOW() >= last_streak_update + INTERVAL '2 weeks' THEN
        phase_strak := 0;
        last_streak_update := NOW();
    -- Sinon, on vérifie si les seuils pour augmenter le streak sont atteints
    ELSE
        IF n_actions_quotidienne >= seuil_initial_actions_quotidienne * (phase_strak + 1) -- TODO Ajouter defis communautaires
        THEN
            -- on augmente le streak, mais on le limite à 4
            phase_strak := LEAST(phase_strak + 1, 4);
            last_streak_update := NOW();
        ELSE
            RETURN NEW; 
        END IF;
    END IF;

    -- Mise à jour ou insertion du streak de l'utilisateur
    INSERT INTO public.utilisateur_streak (utilisateur_id, current_streak, last_updated)
    VALUES (NEW.utilisateur_id, phase_strak, last_streak_update)
    ON CONFLICT (utilisateur_id) 
    DO UPDATE SET 
        current_streak = EXCLUDED.current_streak,
        last_updated = EXCLUDED.last_updated;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculer_streak
AFTER INSERT ON public.realisation_actions
FOR EACH ROW
EXECUTE FUNCTION public.calculer_streak();


CREATE OR REPLACE VIEW public.view_utilisateur_streak_live AS
SELECT 
    us.utilisateur_id,
    CASE 
        WHEN NOW() > s.end_date THEN 0
        WHEN NOW() >= us.last_updated + INTERVAL '2 weeks' THEN 0 -- Inactivité
        ELSE us.current_streak -- Streak valide
    END AS effective_streak,
    us.current_streak AS stored_streak,
    us.last_updated,
    s.name AS saison_nom
FROM 
    public.utilisateur_streak us
CROSS JOIN (
    SELECT name, end_date 
    FROM public.saison 
    ORDER BY end_date DESC 
    LIMIT 1
) s;

SELECT cron.schedule(
    'reset-complet-streaks',
    '0 3 * * *', -- Tous les jours à 3h du matin
    $$
    UPDATE public.user_streak us
    SET current_streak = 0, last_updated = NOW()
    FROM (SELECT end_date FROM public.saison ORDER BY end_date DESC LIMIT 1) s
    WHERE us.current_streak > 0 
    AND (NOW() > s.end_date OR NOW() >= us.last_updated + INTERVAL '2 weeks');
    $$
);