CREATE TABLE IF NOT EXISTS public.utilisateur_streak (
    utilisateur_id uuid PRIMARY KEY,
    current_streak int NOT NULL DEFAULT 0 CHECK (current_streak <= 4 AND current_streak >= 0),
    last_updated timestamptz NOT NULL DEFAULT now(),
    last_streak_seen int NOT NULL DEFAULT 0 CHECK (last_streak_seen <= 4 AND last_streak_seen >= 0),
    last_action_date timestamptz
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
    d_debut_saison timestamptz;
    
    old_streak INT;
    old_updated timestamptz;
    old_seen INT;
    
    next_streak INT;
    next_seen INT;
    next_updated timestamptz;
    
    n_actions INT := 0;
    n_requis INT := 0;
BEGIN
    SELECT entreprise_id INTO u_entreprise_id FROM public.utilisateur WHERE id = NEW.utilisateur_id;
    
    SELECT s.start_date, us.last_updated, us.current_streak, us.last_streak_seen
    INTO d_debut_saison, old_updated, old_streak, old_seen
    FROM public.utilisateur_streak us
    LEFT JOIN public.saison s ON s.entreprise_id = u_entreprise_id 
        AND CURRENT_TIMESTAMP BETWEEN s.start_date AND s.end_date
    WHERE us.utilisateur_id = NEW.utilisateur_id;

    -- On garde la date d'origine par défaut
    next_streak := old_streak;
    next_seen := old_seen;
    next_updated := old_updated;

    -- (Si inactivité > 14j)
    IF old_updated <= (CURRENT_TIMESTAMP - INTERVAL '2 weeks') OR old_updated <= d_debut_saison THEN
        next_streak := 0;
        next_updated := NEW.date_realisation- INTERVAL '1 microsecond';  -- pour que les actions réalisées après le reset soient prises en compte
    END IF;

    -- on compte les actions
    IF d_debut_saison IS NOT NULL AND next_streak < 4 THEN
        SELECT COUNT(*) INTO n_actions
        FROM public.realisation_actions ra
        JOIN public.actions a ON ra.action_id = a.id
        WHERE ra.utilisateur_id = NEW.utilisateur_id 
          AND (ra.date_realisation > next_updated) 
          AND ra.date_realisation >= d_debut_saison
          AND a.frequence = 'journalier';

        SELECT required_actions_quotidiennes INTO n_requis
        FROM public.streak_steps WHERE from_streak_phase = next_streak;

        -- seuil atteint => on update
        IF n_actions >= n_requis THEN
            next_seen := next_streak;
            next_streak := next_streak + 1;
            next_updated := NEW.date_realisation; 
        END IF;
    END IF;

    -- update
        UPDATE public.utilisateur_streak
        SET 
            current_streak = next_streak,
            last_streak_seen = next_seen,
            last_updated = next_updated,
            last_action_date = NEW.date_realisation -- afin de trigger le realtime
        WHERE utilisateur_id = NEW.utilisateur_id;

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
        WHEN s.id IS NULL THEN 0
        WHEN us.last_updated IS NULL THEN 0
        WHEN us.last_updated < s.start_date THEN 0
        WHEN CURRENT_TIMESTAMP >= us.last_updated + INTERVAL '2 weeks' THEN 0 
        ELSE us.current_streak 
    END AS effective_streak,
    us.current_streak AS stored_streak,
    CASE 
        WHEN us.last_updated IS NOT NULL AND (
            CURRENT_TIMESTAMP >= us.last_updated + INTERVAL '2 weeks' OR 
            us.last_updated < s.start_date
        ) THEN NULL
        ELSE us.last_updated
    END AS last_updated,
    s.name AS saison_nom,
    s.start_date AS saison_debut,
    s.end_date AS saison_fin,
    s.streak_theme_path,
    e.nom AS entreprise_name,
    us.last_streak_seen
FROM 
    public.utilisateur_streak us
JOIN public.utilisateur u ON us.utilisateur_id = u.id
JOIN public.entreprise e ON u.entreprise_id = e.id
LEFT JOIN LATERAL (
    SELECT * FROM public.saison 
    WHERE entreprise_id = e.id 
    AND CURRENT_TIMESTAMP >= start_date
    ORDER BY start_date DESC 
    LIMIT 1
) s ON true;

-- Cron pour reset inactivité
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
    INSERT INTO public.utilisateur_streak (utilisateur_id, current_streak, last_updated, last_streak_seen)
    VALUES (NEW.id, 0, NOW(), 0);
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
        SET current_streak = 0, last_updated = NULL, last_streak_seen = 0
        WHERE us.utilisateur_id IN (
            SELECT u.id FROM public.utilisateur u WHERE u.entreprise_id = NEW.entreprise_id
        ); 
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_reset_streaks_on_saison_start AFTER INSERT ON public.saison
FOR EACH ROW EXECUTE FUNCTION public.reset_streaks_on_saison_start();


