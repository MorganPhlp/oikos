


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




ALTER SCHEMA "public" OWNER TO "postgres";


CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."etat_compte" AS ENUM (
    'ACTIF',
    'ANONYMISE',
    'SUPPRIME'
);


ALTER TYPE "public"."etat_compte" OWNER TO "postgres";


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

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."actions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "categorie_nom" character varying,
    "titre" "text" NOT NULL,
    "description" "text",
    "difficulte" "text",
    "cout" "text",
    "temps_mise_en_place" "text",
    "gain_co2" double precision DEFAULT 0.0,
    "xp_gain" integer DEFAULT 0,
    "icon_name" "text",
    "tips" "text"[]
);


ALTER TABLE "public"."actions" OWNER TO "postgres";


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


CREATE TABLE IF NOT EXISTS "public"."communaute" (
    "code" "text" NOT NULL,
    "nom" "text" NOT NULL,
    "entreprise_id" "uuid",
    "description" "text",
    "couleurhex" character varying(7) NOT NULL,
    "plant_xp" integer DEFAULT 0,
    "total_carbon_saved" double precision DEFAULT 0
);


ALTER TABLE "public"."communaute" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."defis_personnels" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "utilisateur_id" "uuid" NOT NULL,
    "action_id" "uuid" NOT NULL,
    "frequence" "text" NOT NULL,
    "statut" "text" DEFAULT 'actif'::"text",
    "date_creation" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."defis_personnels" OWNER TO "postgres";


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
    "streak_days" integer DEFAULT 0
);


ALTER TABLE "public"."utilisateur" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."utilisateur_categorie_preference" (
    "utilisateur_id" "uuid" NOT NULL,
    "categorie_nom" "text" NOT NULL
);


ALTER TABLE "public"."utilisateur_categorie_preference" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vue_community_ranking" AS
 SELECT "code" AS "community_code",
    "nom" AS "community_name",
    "plant_xp" AS "total_xp",
    "entreprise_id",
    "rank"() OVER (PARTITION BY "entreprise_id" ORDER BY "plant_xp" DESC) AS "rank"
   FROM "public"."communaute" "c";


ALTER VIEW "public"."vue_community_ranking" OWNER TO "postgres";


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
 SELECT "id" AS "user_id",
    "pseudo" AS "username",
    "impact_score_xp" AS "total_xp",
    "code_communaute",
    "impact_stats",
    "actions_count",
    "streak_days",
    "rank"() OVER (PARTITION BY "code_communaute" ORDER BY "impact_score_xp" DESC) AS "rank"
   FROM "public"."utilisateur" "u";


ALTER VIEW "public"."vue_user_ranking" OWNER TO "postgres";


ALTER TABLE ONLY "public"."bilan_carbone" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."bilan_carbone_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."carbone_equivalent" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."carbone_equivalent_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."detail_bilan" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."detail_bilan_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."question_bilan" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."question_bilan_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."reponse_utilisateur" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."reponse_utilisateur_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."actions"
    ADD CONSTRAINT "actions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."bilan_carbone"
    ADD CONSTRAINT "bilan_carbone_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carbone_equivalent"
    ADD CONSTRAINT "carbone_equivalent_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."categorie_empreinte"
    ADD CONSTRAINT "categorie_empreinte_pkey" PRIMARY KEY ("nom");



ALTER TABLE ONLY "public"."communaute"
    ADD CONSTRAINT "communaute_pkey" PRIMARY KEY ("code");



ALTER TABLE ONLY "public"."defis_personnels"
    ADD CONSTRAINT "defis_personnels_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."detail_bilan"
    ADD CONSTRAINT "detail_bilan_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."entreprise"
    ADD CONSTRAINT "entreprise_pkey" PRIMARY KEY ("id");



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



ALTER TABLE ONLY "public"."utilisateur_categorie_preference"
    ADD CONSTRAINT "utilisateur_categorie_preference_pkey" PRIMARY KEY ("utilisateur_id", "categorie_nom");



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "utilisateur_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "utilisateur_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "utilisateur_pseudo_key" UNIQUE ("pseudo");



CREATE OR REPLACE TRIGGER "on_bilan_completed" AFTER UPDATE ON "public"."bilan_carbone" FOR EACH ROW EXECUTE FUNCTION "public"."sync_user_bilan_status"();



ALTER TABLE ONLY "public"."actions"
    ADD CONSTRAINT "actions_categorie_nom_fkey" FOREIGN KEY ("categorie_nom") REFERENCES "public"."categorie_empreinte"("nom") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."defis_personnels"
    ADD CONSTRAINT "defis_personnels_action_id_fkey" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id");



ALTER TABLE ONLY "public"."defis_personnels"
    ADD CONSTRAINT "defis_personnels_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."detail_bilan"
    ADD CONSTRAINT "detail_bilan_id_fkey" FOREIGN KEY ("id") REFERENCES "public"."bilan_carbone"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "fk_communaute" FOREIGN KEY ("code_communaute") REFERENCES "public"."communaute"("code") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."communaute"
    ADD CONSTRAINT "fk_entreprise" FOREIGN KEY ("entreprise_id") REFERENCES "public"."entreprise"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "fk_entreprise" FOREIGN KEY ("entreprise_id") REFERENCES "public"."entreprise"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."bilan_carbone"
    ADD CONSTRAINT "fk_utilisateur" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateur"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."realisation_actions"
    ADD CONSTRAINT "realisation_actions_action_id_fkey" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id");



ALTER TABLE ONLY "public"."realisation_actions"
    ADD CONSTRAINT "realisation_actions_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."reponse_utilisateur"
    ADD CONSTRAINT "reponse_utilisateur_bilan_id_fkey" FOREIGN KEY ("bilan_id") REFERENCES "public"."bilan_carbone"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reponse_utilisateur"
    ADD CONSTRAINT "reponse_utilisateur_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."question_bilan"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."utilisateur_categorie_preference"
    ADD CONSTRAINT "utilisateur_categorie_preference_categorie_nom_fkey" FOREIGN KEY ("categorie_nom") REFERENCES "public"."categorie_empreinte"("nom") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."utilisateur_categorie_preference"
    ADD CONSTRAINT "utilisateur_categorie_preference_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateur"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."utilisateur"
    ADD CONSTRAINT "utilisateur_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



CREATE POLICY "Lecture Actions" ON "public"."actions" FOR SELECT USING (true);



CREATE POLICY "Mes Défis" ON "public"."defis_personnels" USING (("auth"."uid"() = "utilisateur_id"));



CREATE POLICY "Mes Réalisations" ON "public"."realisation_actions" USING (("auth"."uid"() = "utilisateur_id"));



ALTER TABLE "public"."actions" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


REVOKE USAGE ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT ALL ON SCHEMA "public" TO "service_role";

























































































































































GRANT ALL ON FUNCTION "public"."add_community_xp"("community_code_arg" "text", "xp_amount" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."add_community_xp"("community_code_arg" "text", "xp_amount" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_community_xp"("community_code_arg" "text", "xp_amount" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_user_bilan_status"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_user_bilan_status"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_user_bilan_status"() TO "service_role";


















GRANT ALL ON TABLE "public"."actions" TO "anon";
GRANT ALL ON TABLE "public"."actions" TO "authenticated";
GRANT ALL ON TABLE "public"."actions" TO "service_role";



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



GRANT ALL ON TABLE "public"."communaute" TO "anon";
GRANT ALL ON TABLE "public"."communaute" TO "authenticated";
GRANT ALL ON TABLE "public"."communaute" TO "service_role";



GRANT ALL ON TABLE "public"."defis_personnels" TO "anon";
GRANT ALL ON TABLE "public"."defis_personnels" TO "authenticated";
GRANT ALL ON TABLE "public"."defis_personnels" TO "service_role";



GRANT ALL ON TABLE "public"."detail_bilan" TO "anon";
GRANT ALL ON TABLE "public"."detail_bilan" TO "authenticated";
GRANT ALL ON TABLE "public"."detail_bilan" TO "service_role";



GRANT ALL ON SEQUENCE "public"."detail_bilan_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."detail_bilan_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."detail_bilan_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."entreprise" TO "anon";
GRANT ALL ON TABLE "public"."entreprise" TO "authenticated";
GRANT ALL ON TABLE "public"."entreprise" TO "service_role";



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



GRANT ALL ON TABLE "public"."utilisateur" TO "anon";
GRANT ALL ON TABLE "public"."utilisateur" TO "authenticated";
GRANT ALL ON TABLE "public"."utilisateur" TO "service_role";



GRANT ALL ON TABLE "public"."utilisateur_categorie_preference" TO "anon";
GRANT ALL ON TABLE "public"."utilisateur_categorie_preference" TO "authenticated";
GRANT ALL ON TABLE "public"."utilisateur_categorie_preference" TO "service_role";



GRANT ALL ON TABLE "public"."vue_community_ranking" TO "anon";
GRANT ALL ON TABLE "public"."vue_community_ranking" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_community_ranking" TO "service_role";



GRANT ALL ON TABLE "public"."vue_situation_publicodes" TO "anon";
GRANT ALL ON TABLE "public"."vue_situation_publicodes" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_situation_publicodes" TO "service_role";



GRANT ALL ON TABLE "public"."vue_user_ranking" TO "anon";
GRANT ALL ON TABLE "public"."vue_user_ranking" TO "authenticated";
GRANT ALL ON TABLE "public"."vue_user_ranking" TO "service_role";









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




























