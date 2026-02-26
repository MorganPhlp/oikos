CREATE TYPE  frequenceEnum AS ENUM ('quotidienne', 'hebdomadaire', 'mensuelle', 'bonus');
CREATE TYPE  difficulteEnum AS ENUM ('facile', 'moyenne', 'difficile');



CREATE TABLE IF NOT EXISTS public.actions (
    id uuid PRIMARY KEY,
    categorie_nom VARCHAR(255) references public.categorie_empreinte(nom) ON DELETE SET NULL,
    titre VARCHAR(255) NOT NULL,
    description varchar(255) NOT NULL,
    difficulte difficulteEnum NOT NULL,
    impact_score int NOT NULL DEFAULT 0,
    icon_name VARCHAR(255) NOT NULL,
    tips text[],
    frequence frequenceEnum NOT NULL,
    tags text[]
);

CREATE TABLE IF NOT EXISTS  public.realisation_actions (
    id SERIAL PRIMARY KEY,
    utilisateur_id uuid NOT NULL REFERENCES public.utilisateur(id) ON DELETE CASCADE,
    action_id uuid NOT NULL REFERENCES public.actions(id) ON DELETE CASCADE,
    date_realisation timestamptz NOT NULL DEFAULT now(),
    xp_gagne int NOT NULL
);

CREATE TABLE IF NOT EXISTS public.actions_en_cours (
    id SERIAL PRIMARY KEY,
    utilisateur_id uuid NOT NULL REFERENCES public.utilisateur(id) ON DELETE CASCADE,
    action_id uuid NOT NULL REFERENCES public.actions(id) ON DELETE CASCADE,
    est_actif boolean NOT NULL DEFAULT true,
    date_creation timestamptz NOT NULL DEFAULT date_trunc('day', now()),
    date_dernier_reset timestamptz NOT NULL DEFAULT date_trunc('day', now()),
    UNIQUE(utilisateur_id, action_id)
);

CREATE TABLE IF NOT EXISTS public.utilisateur_habitudes (
    utilisateur_id uuid REFERENCES public.utilisateur(id) ON DELETE CASCADE,
    action_id uuid NOT NULL REFERENCES public.actions(id) ON DELETE CASCADE,
    date_ajout timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (utilisateur_id, action_id)
);

CREATE TABLE IF NOT EXISTS public.limite_actions_freq(
    frequence frequenceEnum PRIMARY KEY,
    nombre INTEGER CONSTRAINT nombre_positif CHECK (nombre > 0)
);

CREATE TABLE IF NOT EXISTS public.actions_ecartees(
    utilisateur_id uuid NOT NULL REFERENCES public.utilisateur(id) ON DELETE CASCADE,
    action_id uuid NOT NULL REFERENCES public.actions(id) ON DELETE CASCADE,
    PRIMARY KEY(utilisateur_id, action_id)
);

CREATE TABLE IF NOT EXISTS public.tags_ecartes(
    utilisateur_id uuid NOT NULL REFERENCES public.utilisateur(id) ON DELETE CASCADE,
    tag_nom VARCHAR(255) NOT NULL,
    PRIMARY KEY(utilisateur_id, tag_nom)
);

CREATE TABLE IF NOT EXISTS public.categories_ecartees(
    utilisateur_id uuid NOT NULL REFERENCES public.utilisateur(id) ON DELETE CASCADE,
    categorie_nom VARCHAR(255) NOT NULL REFERENCES public.categorie_empreinte(nom) ON DELETE CASCADE,
    PRIMARY KEY(utilisateur_id, categorie_nom)
);


CREATE OR REPLACE VIEW public.vue_actions_en_cours AS
WITH recap_actions AS (
    SELECT 
        ac.utilisateur_id, 
        ac.action_id,
        a.frequence,
        ac.date_dernier_reset,
        MAX(ra.date_realisation) as derniere_realisation,
        COUNT(DISTINCT 
            CASE 
                WHEN a.frequence = 'quotidienne' THEN date_trunc('day', ra.date_realisation)
                WHEN a.frequence = 'hebdomadaire' THEN date_trunc('week', ra.date_realisation)
                WHEN a.frequence = 'mensuelle' THEN date_trunc('month', ra.date_realisation)
                ELSE ra.date_realisation
            END
        ) FILTER (WHERE ra.date_realisation >= ac.date_dernier_reset) as count_since_reset
    FROM public.actions_en_cours ac
    JOIN public.actions a ON ac.action_id = a.id
    LEFT JOIN public.realisation_actions ra ON ra.action_id = ac.action_id 
        AND ra.utilisateur_id = ac.utilisateur_id
    GROUP BY ac.utilisateur_id, ac.action_id, a.frequence, ac.date_dernier_reset
)
SELECT 
    *,
    CASE 
        WHEN derniere_realisation IS NULL THEN 0
        WHEN frequence = 'quotidienne' 
             AND derniere_realisation < CURRENT_DATE - INTERVAL '1 day' THEN 0
        WHEN frequence = 'hebdomadaire' 
             AND date_trunc('week', derniere_realisation) < date_trunc('week', now() - INTERVAL '1 week') THEN 0
        WHEN frequence = 'mensuelle' 
             AND date_trunc('month', derniere_realisation) < date_trunc('month', now() - INTERVAL '1 month') THEN 0  
        WHEN frequence = 'bonus' AND count_since_reset >= 1 THEN 1 
        ELSE count_since_reset
    END AS effective_count
FROM recap_actions;


CREATE OR REPLACE FUNCTION public.reset_actions_en_cours()
RETURNS TRIGGER AS $$
DECLARE
    v_frequence text;
    v_last_completion timestamptz;
    v_dernier_reset_actuel timestamptz;
    v_nouveau_reset timestamptz;
BEGIN
    SELECT frequence INTO v_frequence 
    FROM public.actions WHERE id = NEW.action_id;

    SELECT date_dernier_reset INTO v_dernier_reset_actuel
    FROM public.actions_en_cours 
    WHERE utilisateur_id = NEW.utilisateur_id AND action_id = NEW.action_id;

    SELECT MAX(date_realisation) INTO v_last_completion
    FROM public.realisation_actions
    WHERE utilisateur_id = NEW.utilisateur_id AND action_id = NEW.action_id;

    IF v_last_completion IS NULL THEN
        v_last_completion := v_dernier_reset_actuel;
    END IF;

    v_nouveau_reset := v_dernier_reset_actuel;

    IF v_frequence = 'quotidienne' AND v_last_completion < date_trunc('day', now()) - INTERVAL '1 day' THEN
        v_nouveau_reset := date_trunc('day', now());
        
    ELSIF v_frequence = 'hebdomadaire' AND date_trunc('week', v_last_completion) < date_trunc('week', now()) - INTERVAL '1 week' THEN
        v_nouveau_reset := date_trunc('week', now());
        
    ELSIF v_frequence = 'mensuelle' AND date_trunc('month', v_last_completion) < date_trunc('month', now()) - INTERVAL '1 month' THEN
        v_nouveau_reset := date_trunc('month', now());
    END IF;

    IF v_nouveau_reset != v_dernier_reset_actuel THEN
        UPDATE public.actions_en_cours
        SET date_dernier_reset = v_nouveau_reset
        WHERE utilisateur_id = NEW.utilisateur_id AND action_id = NEW.action_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_reset_actions_en_cours ON public.realisation_actions;
CREATE TRIGGER trigger_reset_actions_en_cours
BEFORE INSERT ON public.realisation_actions
FOR EACH ROW EXECUTE FUNCTION public.reset_actions_en_cours();



CREATE OR REPLACE FUNCTION public.init_impact_score_actions()
RETURNS TRIGGER AS $$
DECLARE 
    base_score INTEGER;
    multiplicateur INTEGER;
BEGIN
    IF NEW.impact_score = 0 OR NEW.impact_score IS NULL THEN
        
        CASE NEW.difficulte
            WHEN 'facile' THEN base_score := 10;
            WHEN 'moyenne'  THEN base_score := 20;
            WHEN 'difficile' THEN base_score := 50;
            ELSE base_score := 0;
        END CASE;

        CASE NEW.frequence
            WHEN 'quotidienne'    THEN multiplicateur := 1;
            WHEN 'hebdomadaire'  THEN multiplicateur := 2;
            WHEN 'mensuelle'       THEN multiplicateur := 3;
            WHEN 'bonus'        THEN multiplicateur := 4; 
            ELSE multiplicateur := 1;
        END CASE;

        NEW.impact_score := base_score * multiplicateur;
        
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS init_impact_score_trigger ON public.actions;
CREATE OR REPLACE TRIGGER init_impact_score_trigger
    BEFORE INSERT ON public.actions
    FOR EACH ROW
    EXECUTE FUNCTION public.init_impact_score_actions();


CREATE OR REPLACE FUNCTION public.calculer_et_ajouter_xp()
RETURNS TRIGGER AS $$
DECLARE
    v_impact_base int;
    v_streak_actuel int;
    v_xp_total int;
BEGIN
    SELECT impact_score INTO v_impact_base FROM public.actions WHERE id = NEW.action_id;

    SELECT COALESCE(effective_streak, 0) INTO v_streak_actuel 
    FROM public.vue_utilisateur_streak_live WHERE utilisateur_id = NEW.utilisateur_id;

    v_xp_total := v_impact_base + (10 * v_streak_actuel);

    NEW.xp_gagne := v_xp_total;

    UPDATE public.utilisateur 
    SET impact_score_xp = impact_score_xp + v_xp_total
    WHERE id = NEW.utilisateur_id;

    RETURN NEW;   
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_on_action_validated ON public.realisation_actions;
CREATE TRIGGER trg_on_action_validated
BEFORE INSERT ON public.realisation_actions
FOR EACH ROW EXECUTE FUNCTION public.calculer_et_ajouter_xp();

CREATE OR REPLACE FUNCTION public.remove_action_on_promote()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM public.actions_en_cours 
    WHERE utilisateur_id = NEW.utilisateur_id AND action_id = NEW.action_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_remove_action_on_promote ON public.utilisateur_habitudes;
CREATE TRIGGER trg_remove_action_on_promote
AFTER INSERT ON public.utilisateur_habitudes
FOR EACH ROW EXECUTE FUNCTION public.remove_action_on_promote();

--pour empecher d'ajouter une habitude si l'action est bonus
CREATE OR REPLACE FUNCTION public.check_bonus_before_habitude()
RETURNS TRIGGER AS $$
DECLARE
    v_frequence text;
BEGIN
    SELECT frequence INTO v_frequence
    FROM public.actions WHERE id = NEW.action_id;
    
    IF v_frequence = 'bonus' THEN
        RAISE EXCEPTION 'Impossible d''ajouter une action bonus en tant qu''habitude';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_bonus_before_habitude ON public.utilisateur_habitudes;
CREATE TRIGGER trg_check_bonus_before_habitude
BEFORE INSERT ON public.utilisateur_habitudes
FOR EACH ROW EXECUTE FUNCTION public.check_bonus_before_habitude();

-- supprimer automatiquement action bonus quand completee
CREATE OR REPLACE FUNCTION public.supprimer_bonus_apres_realisation()
RETURNS TRIGGER AS $$
DECLARE
    v_frequence public.frequenceEnum;
BEGIN
    SELECT frequence INTO v_frequence 
    FROM public.actions 
    WHERE id = NEW.action_id;

    IF v_frequence = 'bonus' THEN
        DELETE FROM public.actions_en_cours 
        WHERE utilisateur_id = NEW.utilisateur_id 
          AND action_id = NEW.action_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS trg_supprimer_bonus_apres_realisation ON public.realisation_actions;

CREATE TRIGGER trg_supprimer_bonus_apres_realisation
AFTER INSERT ON public.realisation_actions
FOR EACH ROW 
EXECUTE FUNCTION public.supprimer_bonus_apres_realisation();


-- -- Pour empecher qu'une action soit ajoutée en tant qu'habitude si elle n'est pas encore applicable selon sa fréquence et le nombre de réalisations
-- CREATE OR REPLACE FUNCTION public.check_habitude_applicability()
-- RETURNS TRIGGER AS $$
-- DECLARE
--     v_frequence text;
--     count int;
--     is_valid boolean := false;
-- BEGIN
--     SELECT frequence, effective_count INTO v_frequence, count
--     FROM public.vue_actions_en_cours
--     WHERE utilisateur_id = NEW.utilisateur_id AND action_id = NEW.action_id;

--     IF v_frequence IS NULL THEN
--         RAISE EXCEPTION 'Action ID % introuvable pour l''utilisateur %', NEW.action_id, NEW.utilisateur_id;
--     END IF;

--     CASE 
--         WHEN v_frequence = 'quotidienne' AND count >= 7 THEN
--             is_valid := true;
--         WHEN v_frequence = 'hebdomadaire' AND count >=4 THEN
--             is_valid := true;
--         WHEN v_frequence = 'mensuelle' AND count >= 3 THEN
--             is_valid := true;
--         WHEN v_frequence = 'bonus' AND count >= 1 THEN
--             is_valid := true;
--         ELSE
--             is_valid := false;
--     END CASE;
--     if is_valid THEN
--         RETURN NEW;
--     ELSE
--         RAISE EXCEPTION 'Action non applicable en tant qu''habitude. Fréquence: %, Count: %', v_frequence, count;
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;

-- DROP TRIGGER IF EXISTS trigger_check_habitude_applicability ON public.utilisateur_habitudes;
-- CREATE TRIGGER trigger_check_habitude_applicability
-- BEFORE INSERT ON public.utilisateur_habitudes
-- FOR EACH ROW EXECUTE FUNCTION public.check_habitude_applicability();