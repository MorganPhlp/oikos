


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";








ALTER SCHEMA "public" OWNER TO "postgres";


CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."difficulteenum" AS ENUM (
    'facile',
    'moyenne',
    'difficile'
);


ALTER TYPE "public"."difficulteenum" OWNER TO "postgres";


CREATE TYPE "public"."etat_compte" AS ENUM (
    'ACTIF',
    'ANONYMISE',
    'SUPPRIME'
);


ALTER TYPE "public"."etat_compte" OWNER TO "postgres";


CREATE TYPE "public"."frequenceenum" AS ENUM (
    'quotidienne',
    'hebdomadaire',
    'mensuelle',
    'bonus'
);


ALTER TYPE "public"."frequenceenum" OWNER TO "postgres";


CREATE TYPE "public"."notification_type" AS ENUM (
    'vote_defi_collectif',
    'nouveau_defi_collectif',
    'streak_loss',
    'bilan',
    'nouvelle_action_communautaire'
);


ALTER TYPE "public"."notification_type" OWNER TO "postgres";


CREATE TYPE "public"."role_utilisateur" AS ENUM (
    'UTILISATEUR',
    'ADMINISTRATEUR'
);


ALTER TYPE "public"."role_utilisateur" OWNER TO "postgres";


CREATE TYPE "public"."type_widget" AS ENUM (
    'SLIDER',
    'NOMBRE',
    'CHOIX_UNIQUE',
    'CHOIX_MULTIPLE',
    'BOOLEEN',
    'COMPTEUR'
);


ALTER TYPE "public"."type_widget" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."add_community_xp"("community_code_arg" "text", "xp_amount" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  -- On ajoute l'XP à la communauté ciblée
  update communaute
  set plant_xp = plant_xp + xp_amount
  where code = community_code_arg;
end;
$$;


ALTER FUNCTION "public"."add_community_xp"("community_code_arg" "text", "xp_amount" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."add_xp_to_user"("user_id_param" "uuid", "xp_amount" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- On met à jour l'utilisateur en ajoutant les points à son total existant
  UPDATE utilisateur
  SET impact_score_xp = COALESCE(impact_score_xp, 0) + xp_amount
  WHERE id = user_id_param;
END;
$$;


ALTER FUNCTION "public"."add_xp_to_user"("user_id_param" "uuid", "xp_amount" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."calculer_et_ajouter_xp"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
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
$$;


ALTER FUNCTION "public"."calculer_et_ajouter_xp"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_and_reward_community_action"("instance_id_param" "uuid", "community_code_param" "text", "xp_reward" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  active_members_count INT;
  participants_count INT;
BEGIN
  -- 1. Compter les membres actifs (non anonymes, non en pause)
  SELECT count(*) INTO active_members_count 
  FROM utilisateur 
  WHERE code_communaute = community_code_param 
    AND etat_compte = 'ACTIF' 
    AND (est_actif = true);

  -- 2. Compter les participants uniques pour cette instance d'action
  SELECT count(*) INTO participants_count 
  FROM action_communautaire_participation 
  WHERE action_id = instance_id_param;

  -- 3. Si le seuil de 60% est atteint, on arrose la plante
  IF active_members_count > 0 AND (participants_count::float / active_members_count::float) >= 0.6 THEN
    PERFORM water_plant(community_code_param, xp_reward);
  END IF;
END;
$$;


ALTER FUNCTION "public"."check_and_reward_community_action"("instance_id_param" "uuid", "community_code_param" "text", "xp_reward" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_bonus_before_habitude"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
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
$$;


ALTER FUNCTION "public"."check_bonus_before_habitude"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_defi_launch_threshold"("defi_id_param" "uuid", "community_code_param" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  active_members_count INT;
  votes_count INT;
BEGIN
  -- 1. Compter les membres 'ACTIF'
  SELECT count(*) INTO active_members_count 
  FROM utilisateur 
  WHERE code_communaute = community_code_param AND etat_compte = 'ACTIF';

  -- 2. Compter les votes pour ce défi
  SELECT count(*) INTO votes_count 
  FROM votes_lancement_defi 
  WHERE defi_communaute_id = defi_id_param AND code_communaute = community_code_param;

  -- 3. Si 60% atteint, passer le statut à 'EN_ATTENTE_CIBLE'
  IF active_members_count > 0 AND (votes_count::float / active_members_count::float) >= 0.6 THEN
    UPDATE defis_communautes 
    SET statut = 'EN_ATTENTE_CIBLE' 
    WHERE id = defi_id_param;
  END IF;
END;
$$;


ALTER FUNCTION "public"."check_defi_launch_threshold"("defi_id_param" "uuid", "community_code_param" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_saison_consistency"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
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
$$;


ALTER FUNCTION "public"."check_saison_consistency"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_saison"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.saison WHERE entreprise_id = NEW.id) THEN
        INSERT INTO public.saison (entreprise_id, name, start_date, end_date, streak_theme_path)
        VALUES (NEW.id, 'Saison 1', NOW(), NOW() + INTERVAL '3 months' , 'default'); 
    END IF; 
    RETURN NEW; 
END; 
$$;


ALTER FUNCTION "public"."create_saison"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."execute_calcul_streak"("p_user_id" "uuid", "p_date_ref" timestamp with time zone) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
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
$$;


ALTER FUNCTION "public"."execute_calcul_streak"("p_user_id" "uuid", "p_date_ref" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_entreprise_id UUID;
  v_domaine TEXT;
BEGIN
  -- Extraire le domaine de l'email (après le @)
  v_domaine := split_part(NEW.email, '@', 2);

  -- Récupérer l'entreprise_id correspondant au domaine
  SELECT id INTO v_entreprise_id
  FROM public.entreprise
  WHERE domaine_email = v_domaine
  LIMIT 1;

  -- Insérer le nouvel utilisateur avec l'entreprise_id
  INSERT INTO public.utilisateur (
    id, 
    email, 
    pseudo, 
    code_communaute, 
    entreprise_id,
    est_compte_valide,
    a_accepte_cgu
  )
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'pseudo',
    NEW.raw_user_meta_data->>'code_communaute',
    v_entreprise_id,
    TRUE,
    TRUE 
  );
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user_streak"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    INSERT INTO public.utilisateur_streak (utilisateur_id, current_streak, last_updated, last_streak_seen)
    VALUES (NEW.id, 0, CURRENT_TIMESTAMP, 0);
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."handle_new_user_streak"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."init_impact_score_actions"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
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
$$;


ALTER FUNCTION "public"."init_impact_score_actions"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."remove_action_on_promote"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    DELETE FROM public.actions_en_cours 
    WHERE utilisateur_id = NEW.utilisateur_id AND action_id = NEW.action_id;

    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."remove_action_on_promote"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."reset_actions_en_cours"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
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
$$;


ALTER FUNCTION "public"."reset_actions_en_cours"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."reset_streaks_on_saison_start"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    derniere_date_debut timestamptz;
BEGIN
    SELECT MAX(start_date) INTO derniere_date_debut
    FROM public.saison WHERE entreprise_id = NEW.entreprise_id AND id != NEW.id;

    IF NEW.start_date >= COALESCE(derniere_date_debut, '-infinity'::timestamptz) THEN
        UPDATE public.utilisateur_streak us
        SET current_streak = 0, last_updated = CURRENT_TIMESTAMP, last_streak_seen = 0
        WHERE us.utilisateur_id IN (
            SELECT u.id FROM public.utilisateur u WHERE u.entreprise_id = NEW.entreprise_id
        ); 
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."reset_streaks_on_saison_start"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."supprimer_bonus_apres_realisation"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
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
$$;


ALTER FUNCTION "public"."supprimer_bonus_apres_realisation"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_user_bilan_status"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- Si le bilan passe à complet = true
  IF (NEW.complet = true) THEN
    UPDATE public.utilisateur
    SET a_complete_bilan = true
    WHERE id = NEW.utilisateur_id;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."sync_user_bilan_status"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."tg_calculer_streak_actions"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    PERFORM public.execute_calcul_streak(NEW.utilisateur_id, NEW.date_realisation);
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."tg_calculer_streak_actions"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."tg_calculer_streak_actions_communautaires"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    PERFORM public.execute_calcul_streak(NEW.user_id,NEW.created_at);
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."tg_calculer_streak_actions_communautaires"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."water_plant"("community_code_arg" "text", "xp_amount" integer) RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    -- On ajoute l'XP uniquement dans la "réserve" de la communauté (plant_xp)
    UPDATE public.communaute
    SET plant_xp = COALESCE(plant_xp, 0) + xp_amount
    WHERE code = community_code_arg; 
END;
$$;


ALTER FUNCTION "public"."water_plant"("community_code_arg" "text", "xp_amount" integer) OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."action_communautaire" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "entreprise_id" "text" NOT NULL,
    "action_id" "uuid" NOT NULL,
    "titre_personnalise" "text",
    "date_debut" timestamp with time zone DEFAULT "now"(),
    "date_fin" timestamp with time zone NOT NULL,
    "createur_id" "uuid"
);


ALTER TABLE "public"."action_communautaire" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."action_communautaire_participation" (
    "action_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "code_communaute" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."action_communautaire_participation" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."actions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "categorie_nom" character varying,
    "titre" "text" NOT NULL,
    "description" "text",
    "difficulte" "text",
    "impact_score" integer DEFAULT 0,
    "icon_name" "text",
    "tips" "text"[],
    "frequence" "text",
    "tags" "text"[]
);


ALTER TABLE "public"."actions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."actions_ecartees" (
    "utilisateur_id" "uuid" NOT NULL,
    "action_id" "uuid" NOT NULL
);


ALTER TABLE "public"."actions_ecartees" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."actions_en_cours" (
    "id" integer NOT NULL,
    "utilisateur_id" "uuid" NOT NULL,
    "action_id" "uuid" NOT NULL,
    "est_actif" boolean DEFAULT true NOT NULL,
    "date_creation" timestamp with time zone DEFAULT "date_trunc"('day'::"text", "now"()) NOT NULL,
    "date_dernier_reset" timestamp with time zone DEFAULT "date_trunc"('day'::"text", "now"()) NOT NULL,
    "progression" integer DEFAULT 0,
    "mode_de_vie" boolean DEFAULT false
);


ALTER TABLE "public"."actions_en_cours" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."actions_en_cours_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."actions_en_cours_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."actions_en_cours_id_seq" OWNED BY "public"."actions_en_cours"."id";



CREATE TABLE IF NOT EXISTS "public"."bilan_carbone" (
    "id" integer NOT NULL,
    "utilisateur_id" "uuid" NOT NULL,
    "date_bilan" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "scoretotalco2ean" double precision NOT NULL,
    "complet" boolean DEFAULT false
);


ALTER TABLE "public"."bilan_carbone" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."bilan_carbone_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."bilan_carbone_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."bilan_carbone_id_seq" OWNED BY "public"."bilan_carbone"."id";



CREATE TABLE IF NOT EXISTS "public"."carbone_equivalent" (
    "id" integer NOT NULL,
    "equivalent_label" character varying NOT NULL,
    "valeur_1_tonne" double precision NOT NULL,
    "icone" character varying(255)
);


ALTER TABLE "public"."carbone_equivalent" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."carbone_equivalent_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."carbone_equivalent_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."carbone_equivalent_id_seq" OWNED BY "public"."carbone_equivalent"."id";



CREATE TABLE IF NOT EXISTS "public"."categorie_empreinte" (
    "nom" character varying(255) NOT NULL,
    "icone" character varying(255) NOT NULL,
    "couleurhex" character varying(7) NOT NULL,
    "description" character varying(500)
);


ALTER TABLE "public"."categorie_empreinte" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."categories_ecartees" (
    "utilisateur_id" "uuid" NOT NULL,
    "categorie_nom" character varying(255) NOT NULL
);


ALTER TABLE "public"."categories_ecartees" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."communaute" (
    "code" "text" NOT NULL,
    "nom" "text" NOT NULL,
    "entreprise_id" "uuid",
    "description" "text",
    "couleurhex" character varying(7) NOT NULL,
    "plant_xp" integer DEFAULT 0,
    "total_carbon_saved" double precision DEFAULT 0,
    "logo_url" "text"
);


ALTER TABLE "public"."communaute" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."defis" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "entreprise_id" "uuid",
    "categorie_nom" "text",
    "titre" "text" NOT NULL,
    "description" "text",
    "difficulte" "text",
    "gain_co2" double precision,
    "xp_gain" integer,
    "icon_name" "text",
    "frequence" "text",
    "tips" "text"[],
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."defis" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."defis_communautes" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "defi_id" "uuid",
    "entreprise_id" "uuid",
    "communaute_demandeur_code" "text",
    "communaute_cible_code" "text",
    "is_global" boolean DEFAULT false,
    "date_expiration" timestamp with time zone NOT NULL,
    "statut" "text" DEFAULT 'EN_ATTENTE'::"text",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."defis_communautes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."detail_bilan" (
    "id" integer NOT NULL,
    "transport" double precision DEFAULT 0,
    "alimentation" double precision DEFAULT 0,
    "logement" double precision DEFAULT 0,
    "divers" double precision DEFAULT 0,
    "services_societaux" double precision DEFAULT 0
);


ALTER TABLE "public"."detail_bilan" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."detail_bilan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."detail_bilan_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."detail_bilan_id_seq" OWNED BY "public"."detail_bilan"."id";



CREATE TABLE IF NOT EXISTS "public"."entreprise" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nom" "text" NOT NULL,
    "logo_url" "text",
    "description" "text",
    "domaine_email" "text" NOT NULL
);


ALTER TABLE "public"."entreprise" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."limite_actions_freq" (
    "frequence" "public"."frequenceenum" NOT NULL,
    "nombre" integer,
    CONSTRAINT "nombre_positif" CHECK (("nombre" > 0))
);


ALTER TABLE "public"."limite_actions_freq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid",
    "type" "public"."notification_type" NOT NULL,
    "is_read" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "data" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL
);


ALTER TABLE "public"."notifications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."question_bilan" (
    "id" integer NOT NULL,
    "slug" "text" NOT NULL,
    "categorie_empreinte" character varying(255) NOT NULL,
    "question" "text" NOT NULL,
    "icone" character varying(50),
    "type_widget" "public"."type_widget" NOT NULL,
    "config_json" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "ordre_affichage" integer DEFAULT 0,
    "est_obligatoire" boolean DEFAULT true
);


ALTER TABLE "public"."question_bilan" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."question_bilan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."question_bilan_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."question_bilan_id_seq" OWNED BY "public"."question_bilan"."id";



CREATE TABLE IF NOT EXISTS "public"."realisation_actions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "utilisateur_id" "uuid" NOT NULL,
    "action_id" "uuid" NOT NULL,
    "date_realisation" timestamp with time zone DEFAULT "now"(),
    "xp_gagne" integer,
    "co2_economise" double precision
);


ALTER TABLE "public"."realisation_actions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."reponse_utilisateur" (
    "id" integer NOT NULL,
    "bilan_id" integer NOT NULL,
    "question_id" integer NOT NULL,
    "valeur" character varying(255)
);


ALTER TABLE "public"."reponse_utilisateur" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."reponse_utilisateur_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."reponse_utilisateur_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."reponse_utilisateur_id_seq" OWNED BY "public"."reponse_utilisateur"."id";



CREATE TABLE IF NOT EXISTS "public"."saison" (
    "id" integer NOT NULL,
    "entreprise_id" "uuid" NOT NULL,
    "name" character varying(255) NOT NULL,
    "start_date" timestamp with time zone NOT NULL,
    "end_date" timestamp with time zone NOT NULL,
    "duree_mois" integer,
    "streak_theme_path" character varying(255) DEFAULT 'default'::character varying NOT NULL,
    CONSTRAINT "saison_duree_mois_check" CHECK (("duree_mois" > 0))
);


ALTER TABLE "public"."saison" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."saison_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."saison_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."saison_id_seq" OWNED BY "public"."saison"."id";



CREATE TABLE IF NOT EXISTS "public"."streak_steps" (
    "from_streak_phase" integer NOT NULL,
    "to_streak_phase" integer NOT NULL,
    "required_actions_quotidiennes" integer NOT NULL,
    "required_actions_communautaires" integer NOT NULL
);


ALTER TABLE "public"."streak_steps" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tags_ecartes" (
    "utilisateur_id" "uuid" NOT NULL,
    "tag_nom" character varying(255) NOT NULL
);


ALTER TABLE "public"."tags_ecartes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."utilisateur" (
    "id" "uuid" NOT NULL,
    "email" character varying(255) NOT NULL,
    "pseudo" character varying(255) NOT NULL,
    "avatar_url" character varying(255),
    "role" "public"."role_utilisateur" DEFAULT 'UTILISATEUR'::"public"."role_utilisateur",
    "etat_compte" "public"."etat_compte" DEFAULT 'ACTIF'::"public"."etat_compte",
    "est_compte_valide" boolean DEFAULT true,
    "a_accepte_cgu" boolean DEFAULT true,
    "impact_score_xp" integer DEFAULT 0,
    "co2_economise_total" double precision DEFAULT 0,
    "entreprise_id" "uuid",
    "code_communaute" "text",
    "objectif" double precision DEFAULT 0.1,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "a_complete_bilan" boolean DEFAULT false,
    "impact_stats" "text" DEFAULT '-0kg'::"text",
    "actions_count" integer DEFAULT 0,
    "streak_days" integer DEFAULT 0,
    "est_actif" boolean DEFAULT true
);


ALTER TABLE "public"."utilisateur" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."utilisateur_categorie_preference" (
    "utilisateur_id" "uuid" NOT NULL,
    "categorie_nom" "text" NOT NULL
);


ALTER TABLE "public"."utilisateur_categorie_preference" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."utilisateur_habitudes" (
    "utilisateur_id" "uuid" NOT NULL,
    "action_id" "uuid" NOT NULL,
    "date_ajout" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."utilisateur_habitudes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."utilisateur_streak" (
    "utilisateur_id" "uuid" NOT NULL,
    "current_streak" integer DEFAULT 0 NOT NULL,
    "last_updated" timestamp with time zone DEFAULT "now"() NOT NULL,
    "last_streak_seen" integer DEFAULT 0,
    "last_action_date" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "utilisateur_streak_current_streak_check" CHECK ((("current_streak" <= 4) AND ("current_streak" >= 0)))
);


ALTER TABLE "public"."utilisateur_streak" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."validations_defis" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "defi_id" "uuid",
    "user_id" "uuid",
    "code_communaute" "text" NOT NULL,
    "xp_gain" integer NOT NULL
);


ALTER TABLE "public"."validations_defis" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."votes_lancement_defi" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "defi_communaute_id" "uuid",
    "user_id" "uuid",
    "code_communaute" "text"
);


ALTER TABLE "public"."votes_lancement_defi" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vue_actions_communautaires_actives" AS
 SELECT "dc"."id" AS "action_id",
    "a"."id" AS "base_action_id",
    "dc"."entreprise_id",
    COALESCE("dc"."titre_personnalise", "a"."titre") AS "titre",
    "a"."description",
    "a"."icon_name",
    "a"."impact_score" AS "xp_gain",
    "dc"."date_fin",
    ( SELECT "count"(*) AS "count"
           FROM "public"."action_communautaire_participation" "dp"
          WHERE ("dp"."action_id" = "dc"."id")) AS "participants_count"
   FROM ("public"."action_communautaire" "dc"
     JOIN "public"."actions" "a" ON ((("dc"."action_id")::"text" = ("a"."id")::"text")))
  WHERE ("dc"."date_fin" > "now"());


ALTER VIEW "public"."vue_actions_communautaires_actives" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vue_actions_en_cours" AS
 WITH "recap_actions" AS (
         SELECT "ac"."utilisateur_id",
            "ac"."action_id",
            "a"."frequence",
            "ac"."date_dernier_reset",
            "max"("ra"."date_realisation") AS "derniere_realisation",
            "count"(DISTINCT
                CASE
                    WHEN ("a"."frequence" = 'quotidienne'::"text") THEN "date_trunc"('day'::"text", "ra"."date_realisation")
                    WHEN ("a"."frequence" = 'hebdomadaire'::"text") THEN "date_trunc"('week'::"text", "ra"."date_realisation")
                    WHEN ("a"."frequence" = 'mensuelle'::"text") THEN "date_trunc"('month'::"text", "ra"."date_realisation")
                    ELSE "ra"."date_realisation"
                END) FILTER (WHERE ("ra"."date_realisation" >= "ac"."date_dernier_reset")) AS "count_since_reset"
           FROM (("public"."actions_en_cours" "ac"
             JOIN "public"."actions" "a" ON (("ac"."action_id" = "a"."id")))
             LEFT JOIN "public"."realisation_actions" "ra" ON ((("ra"."action_id" = "ac"."action_id") AND ("ra"."utilisateur_id" = "ac"."utilisateur_id"))))
          GROUP BY "ac"."utilisateur_id", "ac"."action_id", "a"."frequence", "ac"."date_dernier_reset"
        )
 SELECT "utilisateur_id",
    "action_id",
    "frequence",
    "date_dernier_reset",
    "derniere_realisation",
    "count_since_reset",
        CASE
            WHEN ("derniere_realisation" IS NULL) THEN (0)::bigint
            WHEN (("frequence" = 'quotidienne'::"text") AND ("derniere_realisation" < (CURRENT_DATE - '1 day'::interval))) THEN (0)::bigint
            WHEN (("frequence" = 'hebdomadaire'::"text") AND ("date_trunc"('week'::"text", "derniere_realisation") < "date_trunc"('week'::"text", ("now"() - '7 days'::interval)))) THEN (0)::bigint
            WHEN (("frequence" = 'mensuelle'::"text") AND ("date_trunc"('month'::"text", "derniere_realisation") < "date_trunc"('month'::"text", ("now"() - '1 mon'::interval)))) THEN (0)::bigint
            WHEN (("frequence" = 'bonus'::"text") AND ("count_since_reset" >= 1)) THEN (1)::bigint
            ELSE "count_since_reset"
        END AS "effective_count"
   FROM "recap_actions";


ALTER VIEW "public"."vue_actions_en_cours" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vue_bilan_questions_restantes" AS
 WITH "dernier_bilan" AS (
         SELECT DISTINCT ON ("bilan_carbone"."utilisateur_id") "bilan_carbone"."id" AS "bilan_id",
            "bilan_carbone"."utilisateur_id"
           FROM "public"."bilan_carbone"
          ORDER BY "bilan_carbone"."utilisateur_id", "bilan_carbone"."date_bilan" DESC
        ), "stats_questions" AS (
         SELECT "db"."utilisateur_id",
            ( SELECT "count"(*) AS "count"
                   FROM "public"."question_bilan") AS "total_questions",
            "count"("ru"."id") AS "questions_repondues"
           FROM ("dernier_bilan" "db"
             LEFT JOIN "public"."reponse_utilisateur" "ru" ON (("ru"."bilan_id" = "db"."bilan_id")))
          GROUP BY "db"."utilisateur_id"
        )
 SELECT "utilisateur_id",
    ("total_questions" - "questions_repondues") AS "questions_restantes"
   FROM "stats_questions";


ALTER VIEW "public"."vue_bilan_questions_restantes" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vue_community_ranking" AS
 SELECT "entreprise_id",
    "code" AS "community_code",
    "nom" AS "community_name",
    (COALESCE(( SELECT "sum"("u"."impact_score_xp") AS "sum"
           FROM "public"."utilisateur" "u"
          WHERE ("u"."code_communaute" = "c"."code")), (0)::bigint) + COALESCE("plant_xp", 0)) AS "total_xp",
    "logo_url",
    ( SELECT "count"(*) AS "count"
           FROM "public"."utilisateur" "u"
          WHERE ("u"."code_communaute" = "c"."code")) AS "members_count",
    ( SELECT COALESCE("sum"("u"."actions_count"), (0)::bigint) AS "coalesce"
           FROM "public"."utilisateur" "u"
          WHERE ("u"."code_communaute" = "c"."code")) AS "total_actions"
   FROM "public"."communaute" "c";


ALTER VIEW "public"."vue_community_ranking" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vue_home_stats" WITH ("security_invoker"='on') AS
 SELECT "u"."id" AS "utilisateur_id",
    COALESCE("ra"."nb_actions_realisees", (0)::bigint) AS "nb_actions_realisees",
    COALESCE("ra"."total_xp_gagne", (0)::bigint) AS "total_xp_gagne",
    COALESCE("u"."impact_score_xp", 0) AS "impact_score_xp",
    COALESCE("aec"."nb_actions_en_cours", (0)::bigint) AS "nb_actions_en_cours",
    COALESCE("hab"."nb_habitudes", (0)::bigint) AS "nb_habitudes",
    "bc"."scoretotalco2ean" AS "score_total_co2",
    COALESCE("db"."transport", (0)::double precision) AS "transport",
    COALESCE("db"."alimentation", (0)::double precision) AS "alimentation",
    COALESCE("db"."logement", (0)::double precision) AS "logement",
    COALESCE("db"."divers", (0)::double precision) AS "divers",
    COALESCE("db"."services_societaux", (0)::double precision) AS "services_societaux",
        CASE
            WHEN (GREATEST(COALESCE("db"."transport", (0)::double precision), COALESCE("db"."alimentation", (0)::double precision), COALESCE("db"."logement", (0)::double precision), COALESCE("db"."divers", (0)::double precision), COALESCE("db"."services_societaux", (0)::double precision)) = (0)::double precision) THEN NULL::"text"
            WHEN (GREATEST(COALESCE("db"."transport", (0)::double precision), COALESCE("db"."alimentation", (0)::double precision), COALESCE("db"."logement", (0)::double precision), COALESCE("db"."divers", (0)::double precision), COALESCE("db"."services_societaux", (0)::double precision)) = COALESCE("db"."transport", (0)::double precision)) THEN 'Transport'::"text"
            WHEN (GREATEST(COALESCE("db"."transport", (0)::double precision), COALESCE("db"."alimentation", (0)::double precision), COALESCE("db"."logement", (0)::double precision), COALESCE("db"."divers", (0)::double precision), COALESCE("db"."services_societaux", (0)::double precision)) = COALESCE("db"."alimentation", (0)::double precision)) THEN 'Alimentation'::"text"
            WHEN (GREATEST(COALESCE("db"."transport", (0)::double precision), COALESCE("db"."alimentation", (0)::double precision), COALESCE("db"."logement", (0)::double precision), COALESCE("db"."divers", (0)::double precision), COALESCE("db"."services_societaux", (0)::double precision)) = COALESCE("db"."logement", (0)::double precision)) THEN 'Logement'::"text"
            WHEN (GREATEST(COALESCE("db"."transport", (0)::double precision), COALESCE("db"."alimentation", (0)::double precision), COALESCE("db"."logement", (0)::double precision), COALESCE("db"."divers", (0)::double precision), COALESCE("db"."services_societaux", (0)::double precision)) = COALESCE("db"."divers", (0)::double precision)) THEN 'Divers'::"text"
            ELSE 'Services sociétaux'::"text"
        END AS "categorie_plus_emettrice",
    GREATEST(COALESCE("db"."transport", (0)::double precision), COALESCE("db"."alimentation", (0)::double precision), COALESCE("db"."logement", (0)::double precision), COALESCE("db"."divers", (0)::double precision), COALESCE("db"."services_societaux", (0)::double precision)) AS "valeur_categorie_max"
   FROM ((((("public"."utilisateur" "u"
     LEFT JOIN ( SELECT "realisation_actions"."utilisateur_id",
            "count"(*) AS "nb_actions_realisees",
            COALESCE("sum"("realisation_actions"."xp_gagne"), (0)::bigint) AS "total_xp_gagne"
           FROM "public"."realisation_actions"
          GROUP BY "realisation_actions"."utilisateur_id") "ra" ON (("ra"."utilisateur_id" = "u"."id")))
     LEFT JOIN ( SELECT "actions_en_cours"."utilisateur_id",
            "count"(*) AS "nb_actions_en_cours"
           FROM "public"."actions_en_cours"
          WHERE ("actions_en_cours"."est_actif" = true)
          GROUP BY "actions_en_cours"."utilisateur_id") "aec" ON (("aec"."utilisateur_id" = "u"."id")))
     LEFT JOIN ( SELECT "utilisateur_habitudes"."utilisateur_id",
            "count"(*) AS "nb_habitudes"
           FROM "public"."utilisateur_habitudes"
          GROUP BY "utilisateur_habitudes"."utilisateur_id") "hab" ON (("hab"."utilisateur_id" = "u"."id")))
     LEFT JOIN LATERAL ( SELECT "bilan_carbone"."id",
            "bilan_carbone"."scoretotalco2ean"
           FROM "public"."bilan_carbone"
          WHERE ("bilan_carbone"."utilisateur_id" = "u"."id")
          ORDER BY "bilan_carbone"."date_bilan" DESC
         LIMIT 1) "bc" ON (true))
     LEFT JOIN "public"."detail_bilan" "db" ON (("db"."id" = "bc"."id")));


ALTER VIEW "public"."vue_home_stats" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vue_situation_publicodes" AS
 SELECT "b"."utilisateur_id",
    "b"."id" AS "bilan_id",
    "q"."slug" AS "question_slug",
    "q"."type_widget",
    "r"."valeur" AS "reponse_valeur"
   FROM (("public"."reponse_utilisateur" "r"
     JOIN "public"."question_bilan" "q" ON (("r"."question_id" = "q"."id")))
     JOIN "public"."bilan_carbone" "b" ON (("r"."bilan_id" = "b"."id")));


ALTER VIEW "public"."vue_situation_publicodes" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vue_user_ranking" AS
 SELECT "id",
    "pseudo" AS "username",
    "impact_score_xp" AS "total_xp",
    "code_communaute",
    "impact_stats",
    "actions_count",
    "streak_days",
    "avatar_url",
    "rank"() OVER (PARTITION BY "code_communaute" ORDER BY "impact_score_xp" DESC) AS "rank"
   FROM "public"."utilisateur" "u";


ALTER VIEW "public"."vue_user_ranking" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vue_utilisateur_streak_live" AS
 SELECT "us"."utilisateur_id",
        CASE
            WHEN ("s"."id" IS NULL) THEN 0
            WHEN ("us"."last_updated" IS NULL) THEN 0
            WHEN ("us"."last_updated" < "s"."start_date") THEN 0
            WHEN (CURRENT_TIMESTAMP >= ("us"."last_updated" + '14 days'::interval)) THEN 0
            ELSE "us"."current_streak"
        END AS "effective_streak",
    "us"."current_streak" AS "stored_streak",
        CASE
            WHEN (("us"."last_updated" IS NOT NULL) AND ((CURRENT_TIMESTAMP >= ("us"."last_updated" + '14 days'::interval)) OR ("us"."last_updated" < "s"."start_date"))) THEN NULL::timestamp with time zone
            ELSE "us"."last_updated"
        END AS "last_updated",
    "s"."name" AS "saison_nom",
    "s"."start_date" AS "saison_debut",
    "s"."end_date" AS "saison_fin",
    "s"."streak_theme_path",
    "e"."nom" AS "entreprise_name",
    "us"."last_streak_seen"
   FROM ((("public"."utilisateur_streak" "us"
     JOIN "public"."utilisateur" "u" ON (("us"."utilisateur_id" = "u"."id")))
     JOIN "public"."entreprise" "e" ON (("u"."entreprise_id" = "e"."id")))
     LEFT JOIN LATERAL ( SELECT "saison"."id",
            "saison"."entreprise_id",
            "saison"."name",
            "saison"."start_date",
            "saison"."end_date",
            "saison"."duree_mois",
            "saison"."streak_theme_path"
           FROM "public"."saison"
          WHERE (("saison"."entreprise_id" = "e"."id") AND (CURRENT_TIMESTAMP >= "saison"."start_date"))
          ORDER BY "saison"."start_date" DESC
         LIMIT 1) "s" ON (true));


ALTER VIEW "public"."vue_utilisateur_streak_live" OWNER TO "postgres";


ALTER TABLE ONLY "public"."actions_en_cours" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."actions_en_cours_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."bilan_carbone" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."bilan_carbone_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."carbone_equivalent" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."carbone_equivalent_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."detail_bilan" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."detail_bilan_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."question_bilan" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."question_bilan_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."reponse_utilisateur" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."reponse_utilisateur_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."saison" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."saison_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."actions_ecartees"
    ADD CONSTRAINT "actions_ecartees_pkey" PRIMARY KEY ("utilisateur_id", "action_id");



ALTER TABLE ONLY "public"."actions_en_cours"
    ADD CONSTRAINT "actions_en_cours_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."actions_en_cours"
    ADD CONSTRAINT "actions_en_cours_utilisateur_id_action_id_key" UNIQUE ("utilisateur_id", "action_id");



ALTER TABLE ONLY "public"."actions"
    ADD CONSTRAINT "actions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."bilan_carbone"
    ADD CONSTRAINT "bilan_carbone_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carbone_equivalent"
    ADD CONSTRAINT "carbone_equivalent_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."categorie_empreinte"
    ADD CONSTRAINT "categorie_empreinte_pkey" PRIMARY KEY ("nom");



ALTER TABLE ONLY "public"."categories_ecartees"
    ADD CONSTRAINT "categories_ecartees_pkey" PRIMARY KEY ("utilisateur_id", "categorie_nom");



ALTER TABLE ONLY "public"."communaute"
    ADD CONSTRAINT "communaute_pkey" PRIMARY KEY ("code");



ALTER TABLE ONLY "public"."action_communautaire"
    ADD CONSTRAINT "defi_communautaire_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."action_communautaire_participation"
    ADD CONSTRAINT "defi_participation_pkey" PRIMARY KEY ("action_id", "user_id");



ALTER TABLE ONLY "public"."defis_communautes"
    ADD CONSTRAINT "defis_communautes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."defis"
    ADD CONSTRAINT "defis_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."detail_bilan"
    ADD CONSTRAINT "detail_bilan_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."entreprise"
    ADD CONSTRAINT "entreprise_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."limite_actions_freq"
    ADD CONSTRAINT "limite_actions_freq_pkey" PRIMARY KEY ("frequence");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."question_bilan"
    ADD CONSTRAINT "question_bilan_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."question_bilan"
    ADD CONSTRAINT "question_bilan_slug_key" UNIQUE ("slug");



ALTER TABLE ONLY "public"."realisation_actions"
    ADD CONSTRAINT "realisation_actions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reponse_utilisateur"
    ADD CONSTRAINT "reponse_utilisateur_bilan_id_question_id_key" UNIQUE ("bilan_id", "question_id");



ALTER TABLE ONLY "public"."reponse_utilisateur"
    ADD CONSTRAINT "reponse_utilisateur_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."saison"
    ADD CONSTRAINT "saison_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."streak_steps"
    ADD CONSTRAINT "streak_steps_pkey" PRIMARY KEY ("from_streak_phase");



ALTER TABLE ONLY "public"."tags_ecartes"
    ADD CONSTRAINT "tags_ecartes_pkey" PRIMARY KEY ("utilisateur_id", "tag_nom");



ALTER TABLE ONLY "public"."utilisateur_categorie_preference"
    ADD CONSTRAINT "utilisateur_categorie_preference_pkey" PRIMARY KEY ("utilisateur_id", "categorie_nom");



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "utilisateur_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."utilisateur_habitudes"
    ADD CONSTRAINT "utilisateur_habitudes_pkey" PRIMARY KEY ("utilisateur_id");



ALTER TABLE ONLY "public"."utilisateur_habitudes"
    ADD CONSTRAINT "utilisateur_habitudes_utilisateur_id_action_id_key" UNIQUE ("utilisateur_id", "action_id");



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "utilisateur_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "utilisateur_pseudo_key" UNIQUE ("pseudo");



ALTER TABLE ONLY "public"."utilisateur_streak"
    ADD CONSTRAINT "utilisateur_streak_pkey" PRIMARY KEY ("utilisateur_id");



ALTER TABLE ONLY "public"."validations_defis"
    ADD CONSTRAINT "validations_defis_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."votes_lancement_defi"
    ADD CONSTRAINT "votes_lancement_defi_defi_communaute_id_user_id_key" UNIQUE ("defi_communaute_id", "user_id");



ALTER TABLE ONLY "public"."votes_lancement_defi"
    ADD CONSTRAINT "votes_lancement_defi_pkey" PRIMARY KEY ("id");



CREATE OR REPLACE TRIGGER "init_impact_score_trigger" BEFORE INSERT ON "public"."actions" FOR EACH ROW EXECUTE FUNCTION "public"."init_impact_score_actions"();



CREATE OR REPLACE TRIGGER "on_bilan_completed" AFTER UPDATE ON "public"."bilan_carbone" FOR EACH ROW EXECUTE FUNCTION "public"."sync_user_bilan_status"();



CREATE OR REPLACE TRIGGER "trg_check_bonus_before_habitude" BEFORE INSERT ON "public"."utilisateur_habitudes" FOR EACH ROW EXECUTE FUNCTION "public"."check_bonus_before_habitude"();



CREATE OR REPLACE TRIGGER "trg_on_action_validated" BEFORE INSERT ON "public"."realisation_actions" FOR EACH ROW EXECUTE FUNCTION "public"."calculer_et_ajouter_xp"();



CREATE OR REPLACE TRIGGER "trg_remove_action_on_promote" AFTER INSERT ON "public"."utilisateur_habitudes" FOR EACH ROW EXECUTE FUNCTION "public"."remove_action_on_promote"();



CREATE OR REPLACE TRIGGER "trg_supprimer_bonus_apres_realisation" AFTER INSERT ON "public"."realisation_actions" FOR EACH ROW EXECUTE FUNCTION "public"."supprimer_bonus_apres_realisation"();



CREATE OR REPLACE TRIGGER "trigger_calculer_streak_on_action" AFTER INSERT ON "public"."realisation_actions" FOR EACH ROW EXECUTE FUNCTION "public"."tg_calculer_streak_actions"();



CREATE OR REPLACE TRIGGER "trigger_calculer_streak_on_action_communautaire" AFTER INSERT ON "public"."action_communautaire_participation" FOR EACH ROW EXECUTE FUNCTION "public"."tg_calculer_streak_actions_communautaires"();



CREATE OR REPLACE TRIGGER "trigger_create_saison" AFTER INSERT ON "public"."entreprise" FOR EACH ROW EXECUTE FUNCTION "public"."create_saison"();



CREATE OR REPLACE TRIGGER "trigger_init_streak" AFTER INSERT ON "public"."utilisateur" FOR EACH ROW EXECUTE FUNCTION "public"."handle_new_user_streak"();



CREATE OR REPLACE TRIGGER "trigger_reset_actions_en_cours" BEFORE INSERT ON "public"."realisation_actions" FOR EACH ROW EXECUTE FUNCTION "public"."reset_actions_en_cours"();



CREATE OR REPLACE TRIGGER "trigger_reset_streaks_on_saison_start" AFTER INSERT ON "public"."saison" FOR EACH ROW EXECUTE FUNCTION "public"."reset_streaks_on_saison_start"();



CREATE OR REPLACE TRIGGER "trigger_saison_consistency" BEFORE INSERT OR UPDATE ON "public"."saison" FOR EACH ROW EXECUTE FUNCTION "public"."check_saison_consistency"();



ALTER TABLE ONLY "public"."actions"
    ADD CONSTRAINT "actions_categorie_nom_fkey" FOREIGN KEY ("categorie_nom") REFERENCES "public"."categorie_empreinte"("nom") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."actions_ecartees"
    ADD CONSTRAINT "actions_ecartees_action_id_fkey" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."actions_ecartees"
    ADD CONSTRAINT "actions_ecartees_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateur"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."actions_en_cours"
    ADD CONSTRAINT "actions_en_cours_action_id_fkey" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."actions_en_cours"
    ADD CONSTRAINT "actions_en_cours_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateur"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."categories_ecartees"
    ADD CONSTRAINT "categories_ecartees_categorie_nom_fkey" FOREIGN KEY ("categorie_nom") REFERENCES "public"."categorie_empreinte"("nom") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."categories_ecartees"
    ADD CONSTRAINT "categories_ecartees_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateur"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."action_communautaire"
    ADD CONSTRAINT "defi_communautaire_createur_id_fkey" FOREIGN KEY ("createur_id") REFERENCES "public"."utilisateur"("id");



ALTER TABLE ONLY "public"."action_communautaire_participation"
    ADD CONSTRAINT "defi_participation_action_id_fkey" FOREIGN KEY ("action_id") REFERENCES "public"."action_communautaire"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."action_communautaire_participation"
    ADD CONSTRAINT "defi_participation_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."utilisateur"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."defis_communautes"
    ADD CONSTRAINT "defis_communautes_defi_id_fkey" FOREIGN KEY ("defi_id") REFERENCES "public"."defis"("id");



ALTER TABLE ONLY "public"."defis_communautes"
    ADD CONSTRAINT "defis_communautes_entreprise_id_fkey" FOREIGN KEY ("entreprise_id") REFERENCES "public"."entreprise"("id");



ALTER TABLE ONLY "public"."defis"
    ADD CONSTRAINT "defis_entreprise_id_fkey" FOREIGN KEY ("entreprise_id") REFERENCES "public"."entreprise"("id");



ALTER TABLE ONLY "public"."detail_bilan"
    ADD CONSTRAINT "detail_bilan_id_fkey" FOREIGN KEY ("id") REFERENCES "public"."bilan_carbone"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."communaute"
    ADD CONSTRAINT "fk_entreprise" FOREIGN KEY ("entreprise_id") REFERENCES "public"."entreprise"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "fk_entreprise" FOREIGN KEY ("entreprise_id") REFERENCES "public"."entreprise"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."bilan_carbone"
    ADD CONSTRAINT "fk_utilisateur" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateur"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."realisation_actions"
    ADD CONSTRAINT "realisation_actions_action_id_fkey" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id");



ALTER TABLE ONLY "public"."realisation_actions"
    ADD CONSTRAINT "realisation_actions_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."reponse_utilisateur"
    ADD CONSTRAINT "reponse_utilisateur_bilan_id_fkey" FOREIGN KEY ("bilan_id") REFERENCES "public"."bilan_carbone"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reponse_utilisateur"
    ADD CONSTRAINT "reponse_utilisateur_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."question_bilan"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."saison"
    ADD CONSTRAINT "saison_entreprise_id_fkey" FOREIGN KEY ("entreprise_id") REFERENCES "public"."entreprise"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tags_ecartes"
    ADD CONSTRAINT "tags_ecartes_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateur"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."utilisateur_categorie_preference"
    ADD CONSTRAINT "utilisateur_categorie_preference_categorie_nom_fkey" FOREIGN KEY ("categorie_nom") REFERENCES "public"."categorie_empreinte"("nom") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."utilisateur_categorie_preference"
    ADD CONSTRAINT "utilisateur_categorie_preference_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateur"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "utilisateur_code_communaute_fkey" FOREIGN KEY ("code_communaute") REFERENCES "public"."communaute"("code") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."utilisateur_habitudes"
    ADD CONSTRAINT "utilisateur_habitudes_action_id_fkey" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."utilisateur_habitudes"
    ADD CONSTRAINT "utilisateur_habitudes_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateur"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "utilisateur_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."validations_defis"
    ADD CONSTRAINT "validations_defis_defi_id_fkey" FOREIGN KEY ("defi_id") REFERENCES "public"."defis"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."validations_defis"
    ADD CONSTRAINT "validations_defis_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."votes_lancement_defi"
    ADD CONSTRAINT "votes_lancement_defi_defi_communaute_id_fkey" FOREIGN KEY ("defi_communaute_id") REFERENCES "public"."defis_communautes"("id");



ALTER TABLE ONLY "public"."votes_lancement_defi"
    ADD CONSTRAINT "votes_lancement_defi_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."utilisateur"("id");



CREATE POLICY "Lecture Actions" ON "public"."actions" FOR SELECT USING (true);



CREATE POLICY "Mes Réalisations" ON "public"."realisation_actions" USING (("auth"."uid"() = "utilisateur_id"));



ALTER TABLE "public"."actions" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."notifications";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."saison";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."utilisateur";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."utilisateur_streak";






REVOKE USAGE ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT ALL ON SCHEMA "public" TO "service_role";














































































































































































GRANT ALL ON FUNCTION "public"."add_community_xp"("community_code_arg" "text", "xp_amount" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."add_community_xp"("community_code_arg" "text", "xp_amount" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_community_xp"("community_code_arg" "text", "xp_amount" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."add_xp_to_user"("user_id_param" "uuid", "xp_amount" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."add_xp_to_user"("user_id_param" "uuid", "xp_amount" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_xp_to_user"("user_id_param" "uuid", "xp_amount" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."calculer_et_ajouter_xp"() TO "anon";
GRANT ALL ON FUNCTION "public"."calculer_et_ajouter_xp"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."calculer_et_ajouter_xp"() TO "service_role";



GRANT ALL ON FUNCTION "public"."check_and_reward_community_action"("instance_id_param" "uuid", "community_code_param" "text", "xp_reward" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."check_and_reward_community_action"("instance_id_param" "uuid", "community_code_param" "text", "xp_reward" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_and_reward_community_action"("instance_id_param" "uuid", "community_code_param" "text", "xp_reward" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."check_bonus_before_habitude"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_bonus_before_habitude"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_bonus_before_habitude"() TO "service_role";



GRANT ALL ON FUNCTION "public"."check_defi_launch_threshold"("defi_id_param" "uuid", "community_code_param" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."check_defi_launch_threshold"("defi_id_param" "uuid", "community_code_param" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_defi_launch_threshold"("defi_id_param" "uuid", "community_code_param" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."check_saison_consistency"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_saison_consistency"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_saison_consistency"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_saison"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_saison"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_saison"() TO "service_role";



GRANT ALL ON FUNCTION "public"."execute_calcul_streak"("p_user_id" "uuid", "p_date_ref" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."execute_calcul_streak"("p_user_id" "uuid", "p_date_ref" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."execute_calcul_streak"("p_user_id" "uuid", "p_date_ref" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user_streak"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user_streak"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user_streak"() TO "service_role";



GRANT ALL ON FUNCTION "public"."init_impact_score_actions"() TO "anon";
GRANT ALL ON FUNCTION "public"."init_impact_score_actions"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."init_impact_score_actions"() TO "service_role";



GRANT ALL ON FUNCTION "public"."remove_action_on_promote"() TO "anon";
GRANT ALL ON FUNCTION "public"."remove_action_on_promote"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."remove_action_on_promote"() TO "service_role";



GRANT ALL ON FUNCTION "public"."reset_actions_en_cours"() TO "anon";
GRANT ALL ON FUNCTION "public"."reset_actions_en_cours"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."reset_actions_en_cours"() TO "service_role";



GRANT ALL ON FUNCTION "public"."reset_streaks_on_saison_start"() TO "anon";
GRANT ALL ON FUNCTION "public"."reset_streaks_on_saison_start"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."reset_streaks_on_saison_start"() TO "service_role";



GRANT ALL ON FUNCTION "public"."supprimer_bonus_apres_realisation"() TO "anon";
GRANT ALL ON FUNCTION "public"."supprimer_bonus_apres_realisation"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."supprimer_bonus_apres_realisation"() TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_user_bilan_status"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_user_bilan_status"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_user_bilan_status"() TO "service_role";



GRANT ALL ON FUNCTION "public"."tg_calculer_streak_actions"() TO "anon";
GRANT ALL ON FUNCTION "public"."tg_calculer_streak_actions"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."tg_calculer_streak_actions"() TO "service_role";



GRANT ALL ON FUNCTION "public"."tg_calculer_streak_actions_communautaires"() TO "anon";
GRANT ALL ON FUNCTION "public"."tg_calculer_streak_actions_communautaires"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."tg_calculer_streak_actions_communautaires"() TO "service_role";



GRANT ALL ON FUNCTION "public"."water_plant"("community_code_arg" "text", "xp_amount" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."water_plant"("community_code_arg" "text", "xp_amount" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."water_plant"("community_code_arg" "text", "xp_amount" integer) TO "service_role";
























GRANT ALL ON TABLE "public"."action_communautaire" TO "anon";
GRANT ALL ON TABLE "public"."action_communautaire" TO "authenticated";
GRANT ALL ON TABLE "public"."action_communautaire" TO "service_role";



GRANT ALL ON TABLE "public"."action_communautaire_participation" TO "anon";
GRANT ALL ON TABLE "public"."action_communautaire_participation" TO "authenticated";
GRANT ALL ON TABLE "public"."action_communautaire_participation" TO "service_role";



GRANT ALL ON TABLE "public"."actions" TO "anon";
GRANT ALL ON TABLE "public"."actions" TO "authenticated";
GRANT ALL ON TABLE "public"."actions" TO "service_role";



GRANT ALL ON TABLE "public"."actions_ecartees" TO "anon";
GRANT ALL ON TABLE "public"."actions_ecartees" TO "authenticated";
GRANT ALL ON TABLE "public"."actions_ecartees" TO "service_role";



GRANT ALL ON TABLE "public"."actions_en_cours" TO "anon";
GRANT ALL ON TABLE "public"."actions_en_cours" TO "authenticated";
GRANT ALL ON TABLE "public"."actions_en_cours" TO "service_role";



GRANT ALL ON SEQUENCE "public"."actions_en_cours_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."actions_en_cours_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."actions_en_cours_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."bilan_carbone" TO "anon";
GRANT ALL ON TABLE "public"."bilan_carbone" TO "authenticated";
GRANT ALL ON TABLE "public"."bilan_carbone" TO "service_role";



GRANT ALL ON SEQUENCE "public"."bilan_carbone_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."bilan_carbone_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."bilan_carbone_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."carbone_equivalent" TO "anon";
GRANT ALL ON TABLE "public"."carbone_equivalent" TO "authenticated";
GRANT ALL ON TABLE "public"."carbone_equivalent" TO "service_role";



GRANT ALL ON SEQUENCE "public"."carbone_equivalent_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."carbone_equivalent_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."carbone_equivalent_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."categorie_empreinte" TO "anon";
GRANT ALL ON TABLE "public"."categorie_empreinte" TO "authenticated";
GRANT ALL ON TABLE "public"."categorie_empreinte" TO "service_role";



GRANT ALL ON TABLE "public"."categories_ecartees" TO "anon";
GRANT ALL ON TABLE "public"."categories_ecartees" TO "authenticated";
GRANT ALL ON TABLE "public"."categories_ecartees" TO "service_role";



GRANT ALL ON TABLE "public"."communaute" TO "anon";
GRANT ALL ON TABLE "public"."communaute" TO "authenticated";
GRANT ALL ON TABLE "public"."communaute" TO "service_role";



GRANT ALL ON TABLE "public"."defis" TO "anon";
GRANT ALL ON TABLE "public"."defis" TO "authenticated";
GRANT ALL ON TABLE "public"."defis" TO "service_role";



GRANT ALL ON TABLE "public"."defis_communautes" TO "anon";
GRANT ALL ON TABLE "public"."defis_communautes" TO "authenticated";
GRANT ALL ON TABLE "public"."defis_communautes" TO "service_role";



GRANT ALL ON TABLE "public"."detail_bilan" TO "anon";
GRANT ALL ON TABLE "public"."detail_bilan" TO "authenticated";
GRANT ALL ON TABLE "public"."detail_bilan" TO "service_role";



GRANT ALL ON SEQUENCE "public"."detail_bilan_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."detail_bilan_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."detail_bilan_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."entreprise" TO "anon";
GRANT ALL ON TABLE "public"."entreprise" TO "authenticated";
GRANT ALL ON TABLE "public"."entreprise" TO "service_role";



GRANT ALL ON TABLE "public"."limite_actions_freq" TO "anon";
GRANT ALL ON TABLE "public"."limite_actions_freq" TO "authenticated";
GRANT ALL ON TABLE "public"."limite_actions_freq" TO "service_role";



GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications" TO "service_role";



GRANT ALL ON TABLE "public"."question_bilan" TO "anon";
GRANT ALL ON TABLE "public"."question_bilan" TO "authenticated";
GRANT ALL ON TABLE "public"."question_bilan" TO "service_role";



GRANT ALL ON SEQUENCE "public"."question_bilan_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."question_bilan_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."question_bilan_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."realisation_actions" TO "anon";
GRANT ALL ON TABLE "public"."realisation_actions" TO "authenticated";
GRANT ALL ON TABLE "public"."realisation_actions" TO "service_role";



GRANT ALL ON TABLE "public"."reponse_utilisateur" TO "anon";
GRANT ALL ON TABLE "public"."reponse_utilisateur" TO "authenticated";
GRANT ALL ON TABLE "public"."reponse_utilisateur" TO "service_role";



GRANT ALL ON SEQUENCE "public"."reponse_utilisateur_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."reponse_utilisateur_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."reponse_utilisateur_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."saison" TO "anon";
GRANT ALL ON TABLE "public"."saison" TO "authenticated";
GRANT ALL ON TABLE "public"."saison" TO "service_role";



GRANT ALL ON SEQUENCE "public"."saison_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."saison_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."saison_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."streak_steps" TO "anon";
GRANT ALL ON TABLE "public"."streak_steps" TO "authenticated";
GRANT ALL ON TABLE "public"."streak_steps" TO "service_role";



GRANT ALL ON TABLE "public"."tags_ecartes" TO "anon";
GRANT ALL ON TABLE "public"."tags_ecartes" TO "authenticated";
GRANT ALL ON TABLE "public"."tags_ecartes" TO "service_role";



GRANT ALL ON TABLE "public"."utilisateur" TO "anon";
GRANT ALL ON TABLE "public"."utilisateur" TO "authenticated";
GRANT ALL ON TABLE "public"."utilisateur" TO "service_role";



GRANT ALL ON TABLE "public"."utilisateur_categorie_preference" TO "anon";
GRANT ALL ON TABLE "public"."utilisateur_categorie_preference" TO "authenticated";
GRANT ALL ON TABLE "public"."utilisateur_categorie_preference" TO "service_role";



GRANT ALL ON TABLE "public"."utilisateur_habitudes" TO "anon";
GRANT ALL ON TABLE "public"."utilisateur_habitudes" TO "authenticated";
GRANT ALL ON TABLE "public"."utilisateur_habitudes" TO "service_role";



GRANT ALL ON TABLE "public"."utilisateur_streak" TO "anon";
GRANT ALL ON TABLE "public"."utilisateur_streak" TO "authenticated";
GRANT ALL ON TABLE "public"."utilisateur_streak" TO "service_role";



GRANT ALL ON TABLE "public"."validations_defis" TO "anon";
GRANT ALL ON TABLE "public"."validations_defis" TO "authenticated";
GRANT ALL ON TABLE "public"."validations_defis" TO "service_role";



GRANT ALL ON TABLE "public"."votes_lancement_defi" TO "anon";
GRANT ALL ON TABLE "public"."votes_lancement_defi" TO "authenticated";
GRANT ALL ON TABLE "public"."votes_lancement_defi" TO "service_role";



GRANT ALL ON TABLE "public"."vue_actions_communautaires_actives" TO "anon";
GRANT ALL ON TABLE "public"."vue_actions_communautaires_actives" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_actions_communautaires_actives" TO "service_role";



GRANT ALL ON TABLE "public"."vue_actions_en_cours" TO "anon";
GRANT ALL ON TABLE "public"."vue_actions_en_cours" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_actions_en_cours" TO "service_role";



GRANT ALL ON TABLE "public"."vue_bilan_questions_restantes" TO "anon";
GRANT ALL ON TABLE "public"."vue_bilan_questions_restantes" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_bilan_questions_restantes" TO "service_role";



GRANT ALL ON TABLE "public"."vue_community_ranking" TO "anon";
GRANT ALL ON TABLE "public"."vue_community_ranking" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_community_ranking" TO "service_role";



GRANT ALL ON TABLE "public"."vue_home_stats" TO "anon";
GRANT ALL ON TABLE "public"."vue_home_stats" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_home_stats" TO "service_role";



GRANT ALL ON TABLE "public"."vue_situation_publicodes" TO "anon";
GRANT ALL ON TABLE "public"."vue_situation_publicodes" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_situation_publicodes" TO "service_role";



GRANT ALL ON TABLE "public"."vue_user_ranking" TO "anon";
GRANT ALL ON TABLE "public"."vue_user_ranking" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_user_ranking" TO "service_role";



GRANT ALL ON TABLE "public"."vue_utilisateur_streak_live" TO "anon";
GRANT ALL ON TABLE "public"."vue_utilisateur_streak_live" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_utilisateur_streak_live" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";




























