CREATE TABLE IF NOT EXISTS public.utilisateur_streak (
    utilisateur_id uuid PRIMARY KEY,
    current_streak int NOT NULL DEFAULT 0 CHECK (current_streak <= 4 AND current_streak >= 0),
    last_updated timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.saison (
    id SERIAL PRIMARY KEY,
    entreprise_id uuid NOT NULL REFERENCES public.entreprise(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    start_date timestamptz NOT NULL,
    end_date timestamptz NOT NULL,
    duree_mois int CHECK (duree_mois > 0),
    streak_theme_path VARCHAR(255) NOT NULL DEFAULT 'default'
);

CREATE TABLE IF NOT EXISTS public.streak_steps(
    from_streak_phase int not null primary key,
    to_streak_phase int not null,
    required_actions_quotidiennes int not null,
    required_actions_communautaires int not null
);

-- logique de calcul pour la streak
CREATE OR REPLACE FUNCTION public.calculer_streak()
RETURNS trigger AS $$
DECLARE
    u_entreprise_id uuid;
    d_debut timestamptz;
    n_actions_q INT := 0;
    n_actions_c INT := 1;
    nouvelle_phase INT := 0;
    seuil_cumule_q INT := 0;
    seuil_cumule_c INT := 0;
    record_step RECORD;
BEGIN
    -- 1. Récupération entreprise et saison
    SELECT entreprise_id INTO u_entreprise_id FROM public.utilisateur WHERE id = NEW.utilisateur_id;
    -- On recupere la derniere saison active pour l'entreprise de l'utilisateur
    SELECT start_date INTO d_debut FROM public.saison 
    WHERE entreprise_id = u_entreprise_id AND CURRENT_TIMESTAMP BETWEEN start_date AND end_date LIMIT 1;

    IF d_debut IS NULL THEN RETURN NEW; END IF;

    -- 2. Compter les actions quotidiennes de la saison
    SELECT 
        COUNT(*) FILTER (WHERE a.frequence = 'journalier')
    INTO n_actions_q
    FROM public.realisation_actions ra
    JOIN public.actions a ON ra.action_id = a.id
    WHERE ra.utilisateur_id = NEW.utilisateur_id AND ra.date_realisation >= d_debut;

    -- 3. Transformer les paliers relatifs en seuils cumulés
    FOR record_step IN 
        SELECT required_actions_quotidienne, required_actions_communautaires, to_streak_phase
        FROM public.streak_steps
        ORDER BY to_streak_phase ASC
    LOOP
        -- On additionne le requis de cette étape au total nécessaire
        seuil_cumule_q := seuil_cumule_q + record_step.required_actions_quotidiennes;
        seuil_cumule_c := seuil_cumule_c + record_step.required_actions_communautaires;

        -- Si l'utilisateur a atteint ce nouveau seuil cumulé, on valide cette phase
        --TODO: réintégrer la condition communautaire quand on l'implémentera
        IF n_actions_q >= seuil_cumule_q --AND n_actions_c >= seuil_cumule_c 
        THEN
            nouvelle_phase := record_step.to_streak_phase;
        ELSE
            EXIT; -- On arrête dès qu'un seuil n'est pas atteint
        END IF;
    END LOOP;

    -- 4. Mise à jour
    INSERT INTO public.utilisateur_streak (utilisateur_id, current_streak, last_updated)
    VALUES (NEW.utilisateur_id, nouvelle_phase, CURRENT_TIMESTAMP)
    ON CONFLICT (utilisateur_id) 
    DO UPDATE SET 
        current_streak = EXCLUDED.current_streak,
        last_updated = CASE 
            WHEN public.utilisateur_streak.current_streak != EXCLUDED.current_streak THEN CURRENT_TIMESTAMP 
            ELSE public.utilisateur_streak.last_updated 
        END;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculer_streak_on_action
AFTER INSERT ON public.realisation_actions
FOR EACH ROW EXECUTE FUNCTION public.calculer_streak();


-- Vue pour afficher le streak actuel d'un utilisateur en tenant compte de la saison et de l'inactivité
-- Vue pour Flutter
CREATE OR REPLACE VIEW public.vue_utilisateur_streak_live AS
SELECT 
    us.utilisateur_id,
    CASE 
        WHEN CURRENT_TIMESTAMP < s.start_date THEN 0 
        WHEN CURRENT_TIMESTAMP >= us.last_updated + INTERVAL '2 weeks' THEN 0 
        ELSE us.current_streak 
    END AS effective_streak,
    us.current_streak AS stored_streak,
    us.last_updated,
    s.name AS saison_nom,
    s.start_date AS saison_debut,
    s.end_date AS saison_fin,
    s.streak_theme_path,
    e.nom AS entreprise_name
FROM 
    public.utilisateur_streak us
JOIN public.utilisateur u ON us.utilisateur_id = u.id
JOIN public.entreprise e ON u.entreprise_id = e.id
LEFT JOIN LATERAL (
    SELECT * FROM public.saison 
    WHERE entreprise_id = e.id 
    ORDER BY start_date DESC 
    LIMIT 1
) s ON true;

-- Cron pour reset inactivité (via pg_cron)
SELECT cron.schedule(
    'reset-inactivite-streaks',
    '0 3 * * *', 
    $$
    UPDATE public.utilisateur_streak us
    SET current_streak = 0, last_updated = NOW()
    WHERE us.current_streak > 0 
    AND NOW() >= us.last_updated + INTERVAL '2 weeks';
    $$
);

-- Init streak à la création de l'utilisateur
CREATE OR REPLACE FUNCTION public.handle_new_user_streak()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.utilisateur_streak (utilisateur_id, current_streak, last_updated)
    VALUES (NEW.id, 0, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_init_streak AFTER INSERT ON public.utilisateur
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user_streak();

-- Création saison initiale à la création de l'entreprise
CREATE OR REPLACE FUNCTION public.create_saison()
RETURNS trigger AS $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.saison WHERE entreprise_id = NEW.id) THEN
        INSERT INTO public.saison (entreprise_id, name, start_date, end_date, streak_theme_path)
        VALUES (NEW.id, 'Saison 1', NOW(), NOW() + INTERVAL '3 months' , 'default'); 
    END IF; 
    RETURN NEW; 
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_saison AFTER INSERT ON public.entreprise
FOR EACH ROW EXECUTE FUNCTION public.create_saison();

-- Vérification dates saison
CREATE OR REPLACE FUNCTION public.check_saison_consistency()
RETURNS trigger AS $$
BEGIN
    IF NEW.end_date <= NEW.start_date THEN
        RAISE EXCEPTION 'Fin (%) doit être après début (%)', NEW.end_date, NEW.start_date;
    END IF;
    NEW.duree_mois := (EXTRACT(year FROM age(NEW.end_date, NEW.start_date)) * 12) +
                       EXTRACT(month FROM age(NEW.end_date, NEW.start_date));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_saison_consistency BEFORE INSERT OR UPDATE ON public.saison
FOR EACH ROW EXECUTE FUNCTION public.check_saison_consistency();

-- Reset des streaks au démarrage d'une nouvelle saison
CREATE OR REPLACE FUNCTION public.reset_streaks_on_saison_start()
RETURNS trigger AS $$
DECLARE
    derniere_date_debut timestamptz;
BEGIN
    SELECT MAX(start_date) INTO derniere_date_debut
    FROM public.saison WHERE entreprise_id = NEW.entreprise_id AND id != NEW.id;

    IF NEW.start_date >= COALESCE(derniere_date_debut, '-infinity'::timestamptz) THEN
        UPDATE public.utilisateur_streak us
        SET current_streak = 0, last_updated = CURRENT_TIMESTAMP
        WHERE us.utilisateur_id IN (
            SELECT u.id FROM public.utilisateur u WHERE u.entreprise_id = NEW.entreprise_id
        ); 
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_reset_streaks_on_saison_start AFTER INSERT ON public.saison
FOR EACH ROW EXECUTE FUNCTION public.reset_streaks_on_saison_start();


