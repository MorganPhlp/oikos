


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


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";








ALTER SCHEMA "public" OWNER TO "supabase_admin";


CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."get_carbon_stats"("time_bucket" "text") RETURNS TABLE("period" "date", "average_co2" numeric)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        -- On convertit le résultat du tronquage en type DATE
        date_trunc(time_bucket, h.date)::DATE AS period,
        ROUND(AVG(h.score)::numeric, 2) AS average_co2
    FROM 
        public.carbon_score_history h
    GROUP BY 
        period
    ORDER BY 
        period ASC;
END;
$$;


ALTER FUNCTION "public"."get_carbon_stats"("time_bucket" "text") OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."get_community_carbon_stats"("time_bucket" "text") RETURNS TABLE("community_name" "text", "period" timestamp without time zone, "average_co2" numeric)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.name::text AS community_name,
        date_trunc(time_bucket, h.date) AS period,
        AVG(h.score)::numeric AS average_co2
    FROM carbon_score_history h
    JOIN users u ON h.user_id = u.id
    JOIN communities c ON u.community_id = c.id
    GROUP BY c.name, period
    ORDER BY period DESC, community_name;
END;
$$;


ALTER FUNCTION "public"."get_community_carbon_stats"("time_bucket" "text") OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."get_latest_user_score"("p_user_id" "uuid") RETURNS numeric
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN (
    SELECT score 
    FROM public.carbon_score_history 
    WHERE user_id = p_user_id 
    ORDER BY date DESC 
    LIMIT 1
  );
END;
$$;


ALTER FUNCTION "public"."get_latest_user_score"("p_user_id" "uuid") OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."seed_test_carbon_data"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    user_record RECORD;
    -- Liste des catégories basée sur votre JSON
    categories TEXT[] := ARRAY[
        'Alimentation', 
        'Consommation & Dechets', 
        'Energie & Eau', 
        'Logement', 
        'Numérique', 
        'Transport', 
        'Vacances & Loisirs'
    ];
    cat_name TEXT;
BEGIN
    -- On boucle sur chaque utilisateur de la table users
    FOR user_record IN SELECT id FROM public.users LOOP
        
        -- Pour chaque utilisateur, on boucle sur les catégories
        FOREACH cat_name IN ARRAY categories LOOP
            
            -- On insère ou on met à jour (UPSERT) pour éviter les erreurs de clé primaire
            INSERT INTO public.user_carbon_category (user_id, category_name, co2_value, created_at)
            VALUES (
                user_record.id, 
                cat_name, 
                -- Génère un score CO2 aléatoire entre 50.0 et 500.0
                (random() * 450 + 50)::numeric,
                NOW()
            )
            ON CONFLICT (user_id, category_name) 
            DO UPDATE SET co2_value = EXCLUDED.co2_value;
            
        END LOOP;
    END LOOP;
END;
$$;


ALTER FUNCTION "public"."seed_test_carbon_data"() OWNER TO "supabase_admin";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."action_categories" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL
);


ALTER TABLE "public"."action_categories" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."actions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "category_id" "uuid",
    "title" "text" NOT NULL,
    "description" "text",
    "gain_co2" numeric NOT NULL,
    "difficulty" integer,
    "source" "text",
    CONSTRAINT "actions_difficulty_check" CHECK ((("difficulty" >= 1) AND ("difficulty" <= 5)))
);


ALTER TABLE "public"."actions" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."answer_options" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "question_id" "uuid",
    "label" "text" NOT NULL,
    "value" numeric NOT NULL
);


ALTER TABLE "public"."answer_options" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."carbon_category" (
    "name" character varying(255) NOT NULL,
    "icon" character varying(255) NOT NULL,
    "color" character varying(7) NOT NULL,
    "description" character varying(500)
);


ALTER TABLE "public"."carbon_category" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."carbon_score_history" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "score" numeric NOT NULL,
    "date" "date" DEFAULT CURRENT_DATE
);


ALTER TABLE "public"."carbon_score_history" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."challenge_participants" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "challenge_id" "uuid",
    "user_id" "uuid"
);


ALTER TABLE "public"."challenge_participants" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."challenges" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "target_type" "text",
    "description" "text",
    "start_date" "date",
    "end_date" "date",
    CONSTRAINT "challenges_target_type_check" CHECK (("target_type" = ANY (ARRAY['user'::"text", 'community'::"text"])))
);


ALTER TABLE "public"."challenges" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."communities" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL,
    "code" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "company_id" "uuid"
);


ALTER TABLE "public"."communities" OWNER TO "supabase_admin";


CREATE OR REPLACE VIEW "public"."community_card" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::"text" AS "name",
    NULL::"text" AS "code",
    NULL::"uuid" AS "company_id",
    NULL::integer AS "members_count",
    NULL::numeric AS "avg_score";


ALTER VIEW "public"."community_card" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "email" "text" NOT NULL,
    "password_hash" "text" NOT NULL,
    "pseudo" "text" NOT NULL,
    "avatar_url" "text",
    "company_id" "uuid",
    "community_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."users" OWNER TO "supabase_admin";


CREATE OR REPLACE VIEW "public"."community_impact_stats" AS
 SELECT "c"."id" AS "community_id",
    "c"."name" AS "community_name",
    "sum"((24.6 - "h"."score")) AS "total_co2_saved",
    "count"("h"."id") AS "active_days"
   FROM (("public"."communities" "c"
     JOIN "public"."users" "u" ON (("c"."id" = "u"."community_id")))
     JOIN "public"."carbon_score_history" "h" ON (("u"."id" = "h"."user_id")))
  GROUP BY "c"."id", "c"."name";


ALTER VIEW "public"."community_impact_stats" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."companies" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "logo_url" "text" NOT NULL
);


ALTER TABLE "public"."companies" OWNER TO "supabase_admin";


CREATE OR REPLACE VIEW "public"."global_carbon_distribution" AS
SELECT
    NULL::character varying(255) AS "name",
    NULL::numeric AS "co2",
    NULL::numeric AS "percentage",
    NULL::character varying(7) AS "color";


ALTER VIEW "public"."global_carbon_distribution" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."ignored_actions" (
    "user_id" "uuid" NOT NULL,
    "action_id" "uuid" NOT NULL
);


ALTER TABLE "public"."ignored_actions" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."ignored_categories" (
    "user_id" "uuid" NOT NULL,
    "category_id" "uuid" NOT NULL
);


ALTER TABLE "public"."ignored_categories" OWNER TO "supabase_admin";


CREATE OR REPLACE VIEW "public"."impact_stats" AS
 SELECT "sum"((24.6 - "h"."score")) AS "total_co2_saved",
    "count"(DISTINCT "u"."id") AS "active_members",
    "count"("h"."id") AS "total_actions_count"
   FROM ("public"."users" "u"
     JOIN "public"."carbon_score_history" "h" ON (("u"."id" = "h"."user_id")));


ALTER VIEW "public"."impact_stats" OWNER TO "supabase_admin";


CREATE OR REPLACE VIEW "public"."latest_user_scores" AS
 SELECT DISTINCT ON ("user_id") "user_id",
    "score",
    "date" AS "last_updated"
   FROM "public"."carbon_score_history"
  ORDER BY "user_id", "date" DESC;


ALTER VIEW "public"."latest_user_scores" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."league_memberships" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "league_id" "uuid",
    "joined_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."league_memberships" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."leagues" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL
);


ALTER TABLE "public"."leagues" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."password_history" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "password_hash" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."password_history" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."questions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "text" "text" NOT NULL,
    "category_id" "uuid",
    "mandatory" boolean DEFAULT true,
    "order_index" integer
);


ALTER TABLE "public"."questions" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."streak_history" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "streak_value" integer DEFAULT 0,
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."streak_history" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."user_actions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "action_id" "uuid",
    "validated_at" timestamp with time zone DEFAULT "now"(),
    "synced" boolean DEFAULT false
);


ALTER TABLE "public"."user_actions" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."user_answers" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "question_id" "uuid",
    "answer_value" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."user_answers" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."user_carbon_category" (
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "category_name" character varying NOT NULL,
    "co2_value" numeric
);


ALTER TABLE "public"."user_carbon_category" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."user_community_history" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "community_id" "uuid",
    "joined_at" timestamp with time zone DEFAULT "now"(),
    "left_at" timestamp with time zone
);


ALTER TABLE "public"."user_community_history" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."user_settings" (
    "user_id" "uuid" NOT NULL,
    "notifications_actions" boolean DEFAULT true,
    "notifications_challenges" boolean DEFAULT true,
    "notifications_league" boolean DEFAULT true,
    "accepted_cgu" boolean DEFAULT false,
    "accepted_at" timestamp with time zone
);


ALTER TABLE "public"."user_settings" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "public"."xp_history" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "amount" integer NOT NULL,
    "reason" "text",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."xp_history" OWNER TO "supabase_admin";


ALTER TABLE ONLY "public"."action_categories"
    ADD CONSTRAINT "action_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."actions"
    ADD CONSTRAINT "actions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."answer_options"
    ADD CONSTRAINT "answer_options_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carbon_category"
    ADD CONSTRAINT "carbon_category_pkey" PRIMARY KEY ("name");



ALTER TABLE ONLY "public"."carbon_score_history"
    ADD CONSTRAINT "carbon_score_history_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."challenge_participants"
    ADD CONSTRAINT "challenge_participants_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."challenges"
    ADD CONSTRAINT "challenges_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."communities"
    ADD CONSTRAINT "communities_code_key" UNIQUE ("code");



ALTER TABLE ONLY "public"."communities"
    ADD CONSTRAINT "communities_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."communities"
    ADD CONSTRAINT "communities_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."companies"
    ADD CONSTRAINT "companies_logo_url_key" UNIQUE ("logo_url");



ALTER TABLE ONLY "public"."companies"
    ADD CONSTRAINT "companies_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."companies"
    ADD CONSTRAINT "companies_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."ignored_actions"
    ADD CONSTRAINT "ignored_actions_pkey" PRIMARY KEY ("user_id", "action_id");



ALTER TABLE ONLY "public"."ignored_categories"
    ADD CONSTRAINT "ignored_categories_pkey" PRIMARY KEY ("user_id", "category_id");



ALTER TABLE ONLY "public"."league_memberships"
    ADD CONSTRAINT "league_memberships_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."leagues"
    ADD CONSTRAINT "leagues_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."password_history"
    ADD CONSTRAINT "password_history_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."questions"
    ADD CONSTRAINT "questions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."streak_history"
    ADD CONSTRAINT "streak_history_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."streak_history"
    ADD CONSTRAINT "streak_history_user_id_key" UNIQUE ("user_id");



ALTER TABLE ONLY "public"."carbon_score_history"
    ADD CONSTRAINT "unique_user_daily_score" UNIQUE ("user_id", "date");



ALTER TABLE ONLY "public"."user_actions"
    ADD CONSTRAINT "user_actions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_answers"
    ADD CONSTRAINT "user_answers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_carbon_category"
    ADD CONSTRAINT "user_carbon_category_pkey" PRIMARY KEY ("user_id", "category_name");



ALTER TABLE ONLY "public"."user_community_history"
    ADD CONSTRAINT "user_community_history_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_settings"
    ADD CONSTRAINT "user_settings_pkey" PRIMARY KEY ("user_id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pseudo_key" UNIQUE ("pseudo");



ALTER TABLE ONLY "public"."xp_history"
    ADD CONSTRAINT "xp_history_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_user_actions_user_id" ON "public"."user_actions" USING "btree" ("user_id");



CREATE INDEX "idx_user_answers_user_id" ON "public"."user_answers" USING "btree" ("user_id");



CREATE INDEX "idx_user_email" ON "public"."users" USING "btree" ("email");



CREATE INDEX "idx_user_pseudo" ON "public"."users" USING "btree" ("pseudo");



CREATE INDEX "idx_xp_history_user_id" ON "public"."xp_history" USING "btree" ("user_id");



CREATE OR REPLACE VIEW "public"."community_card" AS
 SELECT "c"."id",
    "c"."name",
    "c"."code",
    "c"."company_id",
    ("count"("u"."id"))::integer AS "members_count",
    "avg"("l"."score") AS "avg_score"
   FROM (("public"."communities" "c"
     LEFT JOIN "public"."users" "u" ON (("c"."id" = "u"."community_id")))
     LEFT JOIN "public"."latest_user_scores" "l" ON (("l"."user_id" = "u"."id")))
  GROUP BY "c"."id"
  ORDER BY ("avg"("l"."score"));



CREATE OR REPLACE VIEW "public"."global_carbon_distribution" AS
 WITH "category_sums" AS (
         SELECT "sc"."name" AS "category_name",
            "sc"."color",
            "sum"("usc"."co2_value") AS "total_co2"
           FROM ("public"."user_carbon_category" "usc"
             JOIN "public"."carbon_category" "sc" ON ((("usc"."category_name")::"text" = ("sc"."name")::"text")))
          GROUP BY "sc"."name"
        ), "total_global" AS (
         SELECT "sum"("category_sums"."total_co2") AS "grand_total"
           FROM "category_sums"
        )
 SELECT "cs"."category_name" AS "name",
    "cs"."total_co2" AS "co2",
    "round"((("cs"."total_co2" / "tg"."grand_total") * (100)::numeric), 2) AS "percentage",
    "cs"."color"
   FROM "category_sums" "cs",
    "total_global" "tg"
  ORDER BY "cs"."total_co2" DESC;



ALTER TABLE ONLY "public"."actions"
    ADD CONSTRAINT "actions_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."action_categories"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."answer_options"
    ADD CONSTRAINT "answer_options_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."questions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."carbon_score_history"
    ADD CONSTRAINT "carbon_score_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."challenge_participants"
    ADD CONSTRAINT "challenge_participants_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "public"."challenges"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."challenge_participants"
    ADD CONSTRAINT "challenge_participants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."communities"
    ADD CONSTRAINT "communities_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."companies"("id");



ALTER TABLE ONLY "public"."ignored_actions"
    ADD CONSTRAINT "ignored_actions_action_id_fkey" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."ignored_actions"
    ADD CONSTRAINT "ignored_actions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."ignored_categories"
    ADD CONSTRAINT "ignored_categories_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."action_categories"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."ignored_categories"
    ADD CONSTRAINT "ignored_categories_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."league_memberships"
    ADD CONSTRAINT "league_memberships_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "public"."leagues"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."league_memberships"
    ADD CONSTRAINT "league_memberships_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."password_history"
    ADD CONSTRAINT "password_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."streak_history"
    ADD CONSTRAINT "streak_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_actions"
    ADD CONSTRAINT "user_actions_action_id_fkey" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_actions"
    ADD CONSTRAINT "user_actions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_answers"
    ADD CONSTRAINT "user_answers_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."questions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_answers"
    ADD CONSTRAINT "user_answers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_carbon_category"
    ADD CONSTRAINT "user_carbon_category_category_name_fkey" FOREIGN KEY ("category_name") REFERENCES "public"."carbon_category"("name");



ALTER TABLE ONLY "public"."user_carbon_category"
    ADD CONSTRAINT "user_carbon_category_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."user_community_history"
    ADD CONSTRAINT "user_community_history_community_id_fkey" FOREIGN KEY ("community_id") REFERENCES "public"."communities"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_community_history"
    ADD CONSTRAINT "user_community_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_settings"
    ADD CONSTRAINT "user_settings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_community_id_fkey" FOREIGN KEY ("community_id") REFERENCES "public"."communities"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."companies"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."xp_history"
    ADD CONSTRAINT "xp_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE "public"."user_carbon_category" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";





REVOKE USAGE ON SCHEMA "public" FROM PUBLIC;
GRANT ALL ON SCHEMA "public" TO "postgres";
GRANT ALL ON SCHEMA "public" TO PUBLIC;
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";














































































































































































GRANT ALL ON TABLE "public"."action_categories" TO "anon";
GRANT ALL ON TABLE "public"."action_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."action_categories" TO "service_role";
GRANT ALL ON TABLE "public"."action_categories" TO "authenticator";



GRANT ALL ON TABLE "public"."actions" TO "anon";
GRANT ALL ON TABLE "public"."actions" TO "authenticated";
GRANT ALL ON TABLE "public"."actions" TO "service_role";
GRANT ALL ON TABLE "public"."actions" TO "authenticator";



GRANT ALL ON TABLE "public"."answer_options" TO "anon";
GRANT ALL ON TABLE "public"."answer_options" TO "authenticated";
GRANT ALL ON TABLE "public"."answer_options" TO "service_role";
GRANT ALL ON TABLE "public"."answer_options" TO "authenticator";



GRANT ALL ON TABLE "public"."carbon_category" TO "anon";
GRANT ALL ON TABLE "public"."carbon_category" TO "authenticated";
GRANT ALL ON TABLE "public"."carbon_category" TO "authenticator";



GRANT ALL ON TABLE "public"."carbon_score_history" TO "anon";
GRANT ALL ON TABLE "public"."carbon_score_history" TO "authenticated";
GRANT ALL ON TABLE "public"."carbon_score_history" TO "service_role";
GRANT ALL ON TABLE "public"."carbon_score_history" TO "authenticator";



GRANT ALL ON TABLE "public"."challenge_participants" TO "anon";
GRANT ALL ON TABLE "public"."challenge_participants" TO "authenticated";
GRANT ALL ON TABLE "public"."challenge_participants" TO "service_role";
GRANT ALL ON TABLE "public"."challenge_participants" TO "authenticator";



GRANT ALL ON TABLE "public"."challenges" TO "anon";
GRANT ALL ON TABLE "public"."challenges" TO "authenticated";
GRANT ALL ON TABLE "public"."challenges" TO "service_role";
GRANT ALL ON TABLE "public"."challenges" TO "authenticator";



GRANT ALL ON TABLE "public"."communities" TO "anon";
GRANT ALL ON TABLE "public"."communities" TO "authenticated";
GRANT ALL ON TABLE "public"."communities" TO "service_role";
GRANT ALL ON TABLE "public"."communities" TO "authenticator";



GRANT SELECT ON TABLE "public"."community_card" TO "anon";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";
GRANT ALL ON TABLE "public"."users" TO "authenticator";



GRANT ALL ON TABLE "public"."community_impact_stats" TO "anon";
GRANT ALL ON TABLE "public"."community_impact_stats" TO "authenticated";
GRANT ALL ON TABLE "public"."community_impact_stats" TO "authenticator";



GRANT ALL ON TABLE "public"."companies" TO "anon";
GRANT ALL ON TABLE "public"."companies" TO "authenticated";
GRANT ALL ON TABLE "public"."companies" TO "authenticator";



GRANT ALL ON TABLE "public"."global_carbon_distribution" TO "anon";
GRANT ALL ON TABLE "public"."global_carbon_distribution" TO "authenticated";
GRANT ALL ON TABLE "public"."global_carbon_distribution" TO "authenticator";



GRANT ALL ON TABLE "public"."ignored_actions" TO "anon";
GRANT ALL ON TABLE "public"."ignored_actions" TO "authenticated";
GRANT ALL ON TABLE "public"."ignored_actions" TO "service_role";
GRANT ALL ON TABLE "public"."ignored_actions" TO "authenticator";



GRANT ALL ON TABLE "public"."ignored_categories" TO "anon";
GRANT ALL ON TABLE "public"."ignored_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."ignored_categories" TO "service_role";
GRANT ALL ON TABLE "public"."ignored_categories" TO "authenticator";



GRANT ALL ON TABLE "public"."impact_stats" TO "anon";
GRANT ALL ON TABLE "public"."impact_stats" TO "authenticated";
GRANT ALL ON TABLE "public"."impact_stats" TO "authenticator";



GRANT ALL ON TABLE "public"."latest_user_scores" TO "anon";
GRANT ALL ON TABLE "public"."latest_user_scores" TO "authenticated";
GRANT ALL ON TABLE "public"."latest_user_scores" TO "authenticator";



GRANT ALL ON TABLE "public"."league_memberships" TO "anon";
GRANT ALL ON TABLE "public"."league_memberships" TO "authenticated";
GRANT ALL ON TABLE "public"."league_memberships" TO "service_role";
GRANT ALL ON TABLE "public"."league_memberships" TO "authenticator";



GRANT ALL ON TABLE "public"."leagues" TO "anon";
GRANT ALL ON TABLE "public"."leagues" TO "authenticated";
GRANT ALL ON TABLE "public"."leagues" TO "service_role";
GRANT ALL ON TABLE "public"."leagues" TO "authenticator";



GRANT ALL ON TABLE "public"."password_history" TO "anon";
GRANT ALL ON TABLE "public"."password_history" TO "authenticated";
GRANT ALL ON TABLE "public"."password_history" TO "service_role";
GRANT ALL ON TABLE "public"."password_history" TO "authenticator";



GRANT ALL ON TABLE "public"."questions" TO "anon";
GRANT ALL ON TABLE "public"."questions" TO "authenticated";
GRANT ALL ON TABLE "public"."questions" TO "service_role";
GRANT ALL ON TABLE "public"."questions" TO "authenticator";



GRANT ALL ON TABLE "public"."streak_history" TO "anon";
GRANT ALL ON TABLE "public"."streak_history" TO "authenticated";
GRANT ALL ON TABLE "public"."streak_history" TO "service_role";
GRANT ALL ON TABLE "public"."streak_history" TO "authenticator";



GRANT ALL ON TABLE "public"."user_actions" TO "anon";
GRANT ALL ON TABLE "public"."user_actions" TO "authenticated";
GRANT ALL ON TABLE "public"."user_actions" TO "service_role";
GRANT ALL ON TABLE "public"."user_actions" TO "authenticator";



GRANT ALL ON TABLE "public"."user_answers" TO "anon";
GRANT ALL ON TABLE "public"."user_answers" TO "authenticated";
GRANT ALL ON TABLE "public"."user_answers" TO "service_role";
GRANT ALL ON TABLE "public"."user_answers" TO "authenticator";



GRANT ALL ON TABLE "public"."user_carbon_category" TO "anon";
GRANT ALL ON TABLE "public"."user_carbon_category" TO "authenticated";
GRANT ALL ON TABLE "public"."user_carbon_category" TO "authenticator";



GRANT ALL ON TABLE "public"."user_community_history" TO "anon";
GRANT ALL ON TABLE "public"."user_community_history" TO "authenticated";
GRANT ALL ON TABLE "public"."user_community_history" TO "service_role";
GRANT ALL ON TABLE "public"."user_community_history" TO "authenticator";



GRANT ALL ON TABLE "public"."user_settings" TO "anon";
GRANT ALL ON TABLE "public"."user_settings" TO "authenticated";
GRANT ALL ON TABLE "public"."user_settings" TO "service_role";
GRANT ALL ON TABLE "public"."user_settings" TO "authenticator";



GRANT ALL ON TABLE "public"."xp_history" TO "anon";
GRANT ALL ON TABLE "public"."xp_history" TO "authenticated";
GRANT ALL ON TABLE "public"."xp_history" TO "service_role";
GRANT ALL ON TABLE "public"."xp_history" TO "authenticator";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";




























