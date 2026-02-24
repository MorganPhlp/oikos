

CREATE TABLE IF NOT EXISTS public.utilisateur_streak (
    utilisateur_id uuid PRIMARY KEY,
    current_streak int NOT NULL DEFAULT 0 CHECK (current_streak <= 4 AND current_streak >= 0),
    last_updated timestamptz  not NULL DEFAULT now(),
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
DROP TRIGGER IF EXISTS trigger_calculer_streak_on_action ON public.realisation_actions;
DROP TRIGGER IF EXISTS trigger_init_streak ON public.utilisateur;
DROP TRIGGER IF EXISTS trigger_create_saison ON public.entreprise;
DROP TRIGGER IF EXISTS trigger_saison_consistency ON public.saison;

CREATE OR REPLACE FUNCTION public.execute_calcul_streak(p_user_id uuid, p_date_ref timestamptz)
RETURNS void AS $$
DECLARE
    u_entreprise_id uuid;
    d_debut_saison timestamptz;
    
    old_streak INT;
    old_updated timestamptz;
    old_seen INT;
    
    next_streak INT;
    next_seen INT;
    next_updated timestamptz;
    
    n_actions_quotidiennes INT := 0;
    n_requis_quotidiennes INT := 0;

    n_actions_communautaires INT := 0;
    n_requis_communautaires INT := 0;
BEGIN
    -- Récupération de l'entreprise
    SELECT entreprise_id INTO u_entreprise_id FROM public.utilisateur WHERE id = p_user_id;
    
    -- Récupération de l'état actuel de la streak et de la saison
    SELECT s.start_date, us.last_updated, us.current_streak, us.last_streak_seen
    INTO d_debut_saison, old_updated, old_streak, old_seen
    FROM public.utilisateur_streak us
    LEFT JOIN public.saison s ON s.entreprise_id = u_entreprise_id 
        AND CURRENT_TIMESTAMP BETWEEN s.start_date AND s.end_date
    WHERE us.utilisateur_id = p_user_id;

    next_streak := old_streak;
    next_seen := old_seen;
    next_updated := old_updated;

    -- Reset de la streak si inactivité > 2 semaines ou nouvelle saison
    IF old_updated <= (CURRENT_TIMESTAMP - INTERVAL '2 weeks') OR old_updated <= d_debut_saison THEN
        next_streak := 0;
        next_updated := p_date_ref - INTERVAL '1 microsecond';
    END IF;

    -- Calcul de progression (limité à la phase 4 dans ton exemple)
    IF d_debut_saison IS NOT NULL AND next_streak < 4 THEN
        -- Actions quotidiennes
        SELECT COUNT(*) INTO n_actions_quotidiennes
        FROM public.realisation_actions ra
        JOIN public.actions a ON ra.action_id = a.id
        WHERE ra.utilisateur_id = p_user_id 
          AND (ra.date_realisation > next_updated) 
          AND ra.date_realisation >= d_debut_saison
          AND a.frequence = 'quotidienne';

        -- Paliers requis
        SELECT required_actions_quotidiennes, required_actions_communautaires 
        INTO n_requis_quotidiennes, n_requis_communautaires
        FROM public.streak_steps WHERE from_streak_phase = next_streak;

        -- Actions communautaires
        SELECT COUNT(*) INTO n_actions_communautaires
        FROM public.action_communautaire_participation
        WHERE user_id = p_user_id 
          AND created_at > next_updated
          AND created_at >= d_debut_saison;

        -- Vérification du passage au palier suivant
        IF n_actions_quotidiennes >= n_requis_quotidiennes AND n_actions_communautaires >= n_requis_communautaires THEN
            next_seen := next_streak;
            next_streak := next_streak + 1;
            next_updated := p_date_ref; 
        END IF;
    END IF;

    -- Mise à jour finale
    UPDATE public.utilisateur_streak
    SET 
        current_streak = next_streak,
        last_streak_seen = next_seen,
        last_updated = next_updated,
        last_action_date = p_date_ref
    WHERE utilisateur_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.tg_calculer_streak_actions()
RETURNS trigger AS $$
BEGIN
    PERFORM public.execute_calcul_streak(NEW.utilisateur_id, NEW.date_realisation);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.tg_calculer_streak_actions_communautaires()
RETURNS trigger AS $$
BEGIN
    PERFORM public.execute_calcul_streak(NEW.user_id,NEW.created_at);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_calculer_streak_on_action ON public.realisation_actions;
DROP TRIGGER IF EXISTS trigger_calculer_streak_on_action_communautaire ON public.action_communautaire_participation;
CREATE TRIGGER trigger_calculer_streak_on_action
AFTER INSERT ON public.realisation_actions
FOR EACH ROW EXECUTE FUNCTION public.tg_calculer_streak_actions();

CREATE TRIGGER trigger_calculer_streak_on_action_communautaire
AFTER INSERT ON public.action_communautaire_participation
FOR EACH ROW EXECUTE FUNCTION public.tg_calculer_streak_actions_communautaires();

CREATE OR REPLACE VIEW public.vue_utilisateur_streak_live AS
SELECT 
    us.utilisateur_id,
    -- calcul de l'expiration/validite de la streak
    CASE 
        WHEN s.id IS NULL THEN 0
        WHEN us.last_updated IS NULL THEN 0
        WHEN us.last_updated < s.start_date THEN 0
        WHEN CURRENT_TIMESTAMP >= us.last_updated + INTERVAL '2 weeks' THEN 0 
        ELSE us.current_streak 
    END AS effective_streak,
    -- streak potentiellement depassee
    us.current_streak AS stored_streak,
    -- Si streak perimee, last updated devient null
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

CREATE OR REPLACE FUNCTION public.handle_new_user_streak()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.utilisateur_streak (utilisateur_id, current_streak, last_updated, last_streak_seen)
    VALUES (NEW.id, 0, '-infinity'::timestamp, 0);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_init_streak AFTER INSERT ON public.utilisateur
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user_streak();

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

CREATE OR REPLACE FUNCTION public.check_saison_consistency()
RETURNS trigger AS $$
BEGIN
    IF NEW.end_date <= NEW.start_date THEN
        RAISE EXCEPTION 'La date de fin (%) doit être strictement après la date de début (%)', NEW.end_date, NEW.start_date;
    END IF;

    IF EXISTS (
        SELECT 1 FROM public.saison
        WHERE entreprise_id = NEW.entreprise_id
          AND id <> NEW.id 
          AND (NEW.start_date, NEW.end_date) OVERLAPS (start_date, end_date)
    ) THEN
        RAISE EXCEPTION 'Cette saison chevauche une saison existante pour cette entreprise.';
    END IF;

    NEW.duree_mois := (EXTRACT(year FROM age(NEW.end_date, NEW.start_date)) * 12) +
                       EXTRACT(month FROM age(NEW.end_date, NEW.start_date));

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_saison_consistency BEFORE INSERT OR UPDATE ON public.saison
FOR EACH ROW EXECUTE FUNCTION public.check_saison_consistency();