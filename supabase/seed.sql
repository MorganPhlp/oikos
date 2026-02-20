SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict 2j3Xku28ZYafuj8QBTXwvDSbPadK5xuJ5FoePbC5HP4Xwpr5R0XlCnF1QRtWFbk

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', 'f60b1e98-5fef-4c80-aa55-42637b659bbf', 'authenticated', 'authenticated', 'a.b@viveris.fr', '$2a$10$vXuWTw/DdTvKptj5s1URxuRb0vRhOb/qEZcK27iyDudeIkNUpq2qe', '2026-02-02 15:26:15.14609+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-02-02 15:26:46.718782+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "f60b1e98-5fef-4c80-aa55-42637b659bbf", "email": "a.b@viveris.fr", "pseudo": "abc", "community_code": "VIV123", "email_verified": true, "phone_verified": false}', NULL, '2026-02-02 15:26:15.122928+00', '2026-02-02 15:26:46.722666+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '5fa69d4d-94ec-49af-8495-65f6b39a96bb', 'authenticated', 'authenticated', 't.t@viveris.fr', '$2a$10$0VSLaA9d69L5SDAfCHv.guqnkQzBELqHv4zeSdDKFRY/.wvGq305O', '2026-01-23 18:04:05.006072+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-01-23 18:04:05.009259+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "5fa69d4d-94ec-49af-8495-65f6b39a96bb", "email": "t.t@viveris.fr", "pseudo": "test", "community_code": "VIV123", "email_verified": true, "phone_verified": false}', NULL, '2026-01-23 18:04:04.985703+00', '2026-01-27 08:50:39.956668+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('5fa69d4d-94ec-49af-8495-65f6b39a96bb', '5fa69d4d-94ec-49af-8495-65f6b39a96bb', '{"sub": "5fa69d4d-94ec-49af-8495-65f6b39a96bb", "email": "t.t@viveris.fr", "pseudo": "test", "community_code": "VIV123", "email_verified": false, "phone_verified": false}', 'email', '2026-01-23 18:04:05.001893+00', '2026-01-23 18:04:05.001948+00', '2026-01-23 18:04:05.001948+00', '36377fa1-8356-43f6-bddc-8f5a2753d3d4'),
	('f60b1e98-5fef-4c80-aa55-42637b659bbf', 'f60b1e98-5fef-4c80-aa55-42637b659bbf', '{"sub": "f60b1e98-5fef-4c80-aa55-42637b659bbf", "email": "a.b@viveris.fr", "pseudo": "abc", "community_code": "VIV123", "email_verified": false, "phone_verified": false}', 'email', '2026-02-02 15:26:15.140326+00', '2026-02-02 15:26:15.140375+00', '2026-02-02 15:26:15.140375+00', '026a3f7e-8800-423b-ad9d-14b02517cff0');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag", "oauth_client_id", "refresh_token_hmac_key", "refresh_token_counter", "scopes") VALUES
	('d7da41ea-e68d-43af-8e67-1e28fe269d7e', 'f60b1e98-5fef-4c80-aa55-42637b659bbf', '2026-02-02 15:26:15.149705+00', '2026-02-02 15:26:15.149705+00', NULL, 'aal1', NULL, NULL, 'Dart/3.10 (dart:io)', '82.64.15.91', NULL, NULL, NULL, NULL, NULL),
	('93a0dc82-455d-431e-94c7-5ab8554328a4', 'f60b1e98-5fef-4c80-aa55-42637b659bbf', '2026-02-02 15:26:46.718888+00', '2026-02-02 15:26:46.718888+00', NULL, 'aal1', NULL, NULL, 'Dart/3.10 (dart:io)', '82.64.15.91', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('d7da41ea-e68d-43af-8e67-1e28fe269d7e', '2026-02-02 15:26:15.15777+00', '2026-02-02 15:26:15.15777+00', 'password', '9187b294-bf3c-4dea-b5c6-91a4e7042db3'),
	('93a0dc82-455d-431e-94c7-5ab8554328a4', '2026-02-02 15:26:46.722956+00', '2026-02-02 15:26:46.722956+00', 'password', 'b657e41c-ee5e-432c-8ffd-1d676d698aa6');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 153, 'r3tupnoifmst', 'f60b1e98-5fef-4c80-aa55-42637b659bbf', false, '2026-02-02 15:26:15.15593+00', '2026-02-02 15:26:15.15593+00', NULL, 'd7da41ea-e68d-43af-8e67-1e28fe269d7e'),
	('00000000-0000-0000-0000-000000000000', 154, 'fdjgoo47yvpz', 'f60b1e98-5fef-4c80-aa55-42637b659bbf', false, '2026-02-02 15:26:46.721057+00', '2026-02-02 15:26:46.721057+00', NULL, '93a0dc82-455d-431e-94c7-5ab8554328a4');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: categorie_empreinte; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."categorie_empreinte" ("nom", "icone", "couleurhex", "description") VALUES
	('Logement', '🏠', '#4CAF50', 'Habitat et énergie'),
	('Transport', '🚗', '#2196F3', 'Déplacements et véhicules'),
	('Alimentation', '🍽️', '#FF9800', 'Nourriture et boissons'),
	('Energie & Eau', '⚡', '#9C27B0', 'Consommation d''énergie et d''eau'),
	('Vacances & Loisirs', '🏖️', '#E91E63', 'Voyages et loisirs'),
	('Numérique', '💻', '#00BCD4', 'Technologies et appareils numériques'),
	('Consommation & Dechets', '🛍️', '#8BC34A', 'Consommation et déchets');


--
-- Data for Name: actions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."actions" ("id", "categorie_nom", "titre", "description", "difficulte", "cout", "temps_mise_en_place", "gain_co2", "xp_gain", "icon_name", "tips") VALUES
	('071258e4-520c-4d2d-b19d-8f6f3f18075f', 'Transport', 'Covoiturage', 'Partagez vos trajets', 'Facile', NULL, NULL, 20.5, 150, 'car', '{"Utilisez BlaBlaCar","Proposez aux voisins"}'),
	('17ab7246-4049-47b0-a30b-bea5205b4445', 'Alimentation', 'Menu Végé', 'Repas sans viande', 'Moyen', NULL, NULL, 12, 120, 'food', '{"Testez les lentilles","Steak de soja"}');


--
-- Data for Name: entreprise; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."entreprise" ("id", "nom", "logo_url", "description", "domaine_email") VALUES
	('2efcc515-54c1-4beb-a45a-90cc251d5792', 'Viveris', 'viveris_logo.png', 'Entreprise de services du numérique', 'viveris.fr');


--
-- Data for Name: communaute; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."communaute" ("code", "nom", "entreprise_id", "description", "couleurhex", "plant_xp", "total_carbon_saved") VALUES
	('VIV123', 'Service Informatique Viveris', '2efcc515-54c1-4beb-a45a-90cc251d5792', 'Service du meilleur métier', '#4CAF50', 0, 0);


--
-- Data for Name: utilisateur; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."utilisateur" ("id", "email", "pseudo", "avatar_url", "role", "etat_compte", "est_compte_valide", "a_accepte_cgu", "impact_score_xp", "co2_economise_total", "entreprise_id", "code_communaute", "objectif", "updated_at", "a_complete_bilan", "impact_stats", "actions_count", "streak_days") VALUES
	('f60b1e98-5fef-4c80-aa55-42637b659bbf', 'a.b@viveris.fr', 'abc', NULL, 'UTILISATEUR', 'ACTIF', true, true, 0, 0, '2efcc515-54c1-4beb-a45a-90cc251d5792', 'VIV123', 0.1, '2026-02-02 15:26:15.122578+00', false, '-0kg', 0, 0);


--
-- Data for Name: bilan_carbone; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."bilan_carbone" ("id", "utilisateur_id", "date_bilan", "scoretotalco2ean", "complet") VALUES
	(15, 'f60b1e98-5fef-4c80-aa55-42637b659bbf', '2026-02-02 16:26:10.956367+00', 0, false);


--
-- Data for Name: carbone_equivalent; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."carbone_equivalent" ("id", "equivalent_label", "valeur_1_tonne", "icone") VALUES
	(4, 'A/R Paris-New York en avion', 0.49, '✈️'),
	(5, 'Litres d''eau', 130000, '💧'),
	(6, '% de l''empreinte carbone moyenne d''un français', 11, '🇫🇷');


--
-- Data for Name: defis_personnels; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."defis_personnels" ("id", "utilisateur_id", "action_id", "frequence", "statut", "date_creation") VALUES
	('cc57872d-81e9-4aeb-b746-0508d0b21054', '5fa69d4d-94ec-49af-8495-65f6b39a96bb', '17ab7246-4049-47b0-a30b-bea5205b4445', 'unique', 'actif', '2026-01-23 23:34:53.746608+00'),
	('b9680225-ab19-4ae2-8792-54a03b6ba031', '5fa69d4d-94ec-49af-8495-65f6b39a96bb', '17ab7246-4049-47b0-a30b-bea5205b4445', 'journalier', 'actif', '2026-01-24 00:23:21.032724+00'),
	('e4c16a6f-68a2-4e22-926b-94edb8e1ff70', '5fa69d4d-94ec-49af-8495-65f6b39a96bb', '17ab7246-4049-47b0-a30b-bea5205b4445', 'journalier', 'actif', '2026-01-24 00:47:35.790254+00'),
	('aa73578d-3315-4397-8027-3a2b2e28c0bc', '5fa69d4d-94ec-49af-8495-65f6b39a96bb', '17ab7246-4049-47b0-a30b-bea5205b4445', 'journalier', 'actif', '2026-01-30 12:40:38.89038+00'),
	('2867d307-0b60-4b6f-b935-26c799a0b76b', '5fa69d4d-94ec-49af-8495-65f6b39a96bb', '071258e4-520c-4d2d-b19d-8f6f3f18075f', 'journalier', 'actif', '2026-01-30 20:29:35.84995+00');


--
-- Data for Name: detail_bilan; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: question_bilan; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."question_bilan" ("id", "slug", "categorie_empreinte", "question", "icone", "type_widget", "config_json", "ordre_affichage", "est_obligatoire") VALUES
	(2, 'logement . surface', 'logement', 'Quelle est la surface de votre logement ?', '📏', 'NOMBRE', '{"max": 999, "min": 1, "note": "Valeur par défaut obtenue dans [ce jeu de données du Ceren et SDES](https://www.statistiques.developpement-durable.gouv.fr/consommation-denergie-par-usage-du-residentiel).\n\n> Les logements ont une surface moyenne d’environ 91 m2.\n\n> Si vous vivez dans un logement original, par exemple un camping-car / un camion / une péniche, renseignez simplement les m² de ce logement.\n", "unit": "m2", "description": "Si vous êtes en colocation, chez vos parents, ou habitat partagé, renseignez la surface totale du logement. Le nombre de personnes sera pris en compte par la suite.\n", "suggestions": {"studio": 30, "1 chambre": 50, "2 chambres": 70, "3 chambres": 100, "Plus de 4 chambres": 150}, "defaultValue": {"arrondi": "1 décimale", "variations": [{"si": "logement . est un appartement", "alors": "parc français . surface moyenne appartement"}, {"si": "logement . est une maison", "alors": "parc français . surface moyenne maison"}, {"si": "logement . est un autre logement", "alors": "20 m2"}, {"sinon": "parc français . surface moyenne"}]}}', 2, true),
	(4, 'logement . habitants', 'logement', 'Combien de personnes vivent chez vous ?', '👥', 'NOMBRE', '{"max": 30, "min": 1, "description": "Cette information permet de rapporter les consommations collectives du foyer (mobilier, chauffage, etc.) à votre part individuelle.\n\n> 💡 Si vous vivez seul, répondez **1**, si un membre de votre foyer n''y habite pas tous les jours, vous pouvez rentrer quelque-chose comme **1,5**.\n", "suggestions": {"j''habite seul": 1, "deux personnes": 2, "famille nombreuse": 6, "parents et 2 enfants": 4}, "defaultValue": "habitants . moyen"}', 4, true),
	(5, 'logement . chauffage', 'logement', 'Qu''utilisez vous pour la cuisson, l''eau chaude et chauffer ou climatiser votre logement ?', '🔥', 'CHOIX_MULTIPLE', '{"options": ["électricité . présent", "gaz . présent", "PAC . présent", "bois . présent", "réseau de chaleur . présent", "bouteille gaz . présent", "fioul . présent", "citerne propane . présent", "chauffe eau solaire . présent", "logement . climatisation . présent", "logement . électricité . photovoltaique . présent", "aucun . présent"], "description": "**Ne sélectionnez pas \"électricité\"** si elle alimente seulement vos appareils électriques quotidiens (éclairage, électroménager, etc.).\n"}', 5, true),
	(6, 'logement . chauffage . précision consommation . ressenti', 'logement', 'Quel est votre ressenti sur le confort thermique de votre logement en hiver ?', '🌡️', 'CHOIX_UNIQUE', '{"note": "L''idée est d''utiliser cette variable pour pondérer les consommations d''un logement moyen estimées via les consommations réelles du parc français, en considérant un DPE moyen en France à D. Ainsi, on peut ajuster la valeur moyenne de consommation avec un saut de classe de D vers A ou de D vers G selon le ressenti de l''utilisateur.\n", "options": ["passoire thermique", "moyen", "confortable"], "description": "Si vous vivez dans une région où il n''est pas nécessaire de chauffer, transposez la question sur le ressenti en été, avec la climatisation par exemple.\n", "defaultValue": "''moyen''"}', 6, true),
	(7, 'transport . voiture . utilisateur', 'transport', 'Vous arrive t-il de vous déplacer en voiture (en tant que passager ou conducteur) ?', '🚗', 'CHOIX_UNIQUE', '{"note": "Deux données sont importantes dans le cadre du calcul de l''empreinte liée à la construction :\n\n- L''usage ou non d''un même véhicule pour tous les kilomètres parcourus (si non : on vous attribue un véhicule \"moyen\")\n- La propriété ou non dudit véhicule s''il s''agit toujours du même\n\nNous avons fait le choix d''attribuer l''empreinte de construction au pro-rata des kilomètres parcourus. Mais cette approche avait deux défauts :\n\n- Elle était extrêmement avantageuse pour les petits rouleurs, alors que leur véhicule qui roule moins peut s''user plus vite (un moteur a besoin de tourner régulièrement) et donc avoir une durée de vie inférieure.\n- Elle ne permettait pas de valoriser l''engagement de ne pas disposer de son propre véhicule, et de pratiquer à la place l''autopartage, ou la location ponctuelle (car l''empreinte de construction était la même, que l''on soit propriétaire ou non).\n\n> Pour pallier ces deux problèmes, et mieux représenter qu''un véhicule possédé mais sous-utilisé s''use plus vite et mérite une empreinte de construction plus importante, **nous appliquons un seuil pour la partie construction de l''empreinte, pour les propriétaires**.\n", "options": ["propriétaire", "régulier non propriétaire", "non régulier", "jamais"], "description": "Choisissez ce qui correspond à la majorité de vos trajets.\n"}', 7, true),
	(8, 'transport . voiture . km', 'transport', 'Quelle distance parcourez-vous à l''année en voiture ?', '⛽', 'NOMBRE', '{"max": 99999, "min": 1, "unit": "km", "dependances": [{"key": "transport . voiture . utilisateur", "type": "IN", "value": ["propriétaire", "régulier non propriétaire", "non régulier"]}], "description": "Ne comptez que les kilomètres de déplacement personnel (courses, loisirs, famille, etc.) et de déplacement domicile-travail.\n\nSi une mission professionnelle vous amène à vous déplacer plus loin que votre lieu de travail habituel, ne comptez pas ici les km concernés.\n", "suggestions": {"vacances": 2000, "10 km / jour": 3600, "20000 km / an": 20000, "1000 km / mois": 12000}, "defaultValue": "km annuels moyen"}', 8, true),
	(10, 'transport . mobilité douce', 'transport', 'Parmi ces modes de déplacement, lesquels utilisez-vous ?', '🚲', 'CHOIX_MULTIPLE', '{"options": ["vélo . présent", "vae . présent", "autres véhicules à moteur . présent", "aucun . présent"], "description": "Si vous possédez un vélo-cargo disposant d''une assistance électrique, classez-le dans la catégorie VAE ! Sinon, il est du côté des vélos \"classiques\".\n"}', 10, true),
	(12, 'transport . avion . moyen courrier . heures de vol', 'transport', 'Sur une année, combien d''heures voyagez-vous sur des vols entre 2 et 6h (moyen-courrier) ?', '🕒', 'NOMBRE', '{"max": 600, "min": 0, "note": "La caractérisation \"moyen courrier\" par le temps de trajet est donnée par la règle `court courrier . durée max`=2.17h et `moyen courrier . durée max` = 6.48h.", "unit": "h", "dependances": [{"key": "transport . avion . usager", "type": "EQUAL", "value": "oui"}], "description": "Comptez les heures que vous avez passées dans un avion pour des trajets entre 2h et 6h.\n\nSi vous avez fait un trajet de 8h en deux vols de 4h, ils sont bien à comptabiliser ici.\n\n💡 Ne comptez que les km de déplacement personnel.\n", "suggestions": {"Aucun": 0, "Paris ⇄ Alger": 5, "Paris ⇄ Liban": 8, "Paris ⇄ Athènes": 6, "Paris ⇄ Copenhague": 4}, "defaultValue": "durée moyenne"}', 12, true),
	(9, 'transport . voiture . motorisation', 'transport', 'Quel type de voiture utilisez-vous ?', '🔧', 'CHOIX_UNIQUE', '{"options": ["thermique", "électrique", "hybride non rechargeable", "hybride rechargeable"], "dependances": [{"key": "transport . voiture . utilisateur", "type": "IN", "value": ["propriétaire", "régulier non propriétaire"]}], "description": "💡 **Si vous utilisez plusieurs voitures (par exemple dans le cas où vous n''en possédez pas une), choisissez la réponse la plus représentative de votre usage.**", "defaultValue": "''thermique''"}', 9, true),
	(11, 'transport . avion . usager', 'transport', 'Avez-vous pris l''avion au moins une fois ces 3 dernières années ?', '✈️', 'BOOLEEN', '{"options": ["oui", "non"]}', 11, true),
	(13, 'alimentation . plats', 'alimentation', 'Choisissez les 14 repas (déjeuners et dîners) de votre semaine-type', '🍽️', 'COMPTEUR', '{"max": 14, "min": 0, "note": "Pour le moment, nous proposons 6 repas types pour 6 régimes différents. Il a été choisi de limiter la granularité du modèle via 6 menus représentatifs\ndes régimes associés pour simplifier l''estimation de l''empreinte du poste alimentation pour l''utilisateur\n(les spécificités de l''alimentation de chacun pourraient donner lieu à un simulateur complet dédié à l''alimentation).\n\nIls ne sont pas directement basés sur les régimes de la Base Empreinte, [documentés par l''ADEME](https://www.bilans-ges.ademe.fr/documentation/UPLOAD_DOC_FR/index.htm?repas.htm), jugés obsolètes (peu exhaustifs, FE non issus d''Agribalyse).\n\nEn revanche, nous avons travaillé sur des repas types basés sur une consolidation multi-facteurs (quantité totale d''aliments consommés, quantité de viande et poisson consommés, apports énergétiques, empreinte carbone moyenne d''un repas)\nbasé sur les données de [l''étude INCA 3](https://www.anses.fr/fr/system/files/NUT2014SA0234Ra.pdf), permettant de se rapprocher du régime moyen d''un Français.\n\n💡 Vous trouverez la documentation complète dans [notre wiki](https://accelerateur-transition-ecologique-ademe.notion.site/Empreinte-des-repas-NGC-377d2143f3a14b558ab2c8e0426d2e23).\n\n🧮 Le calcul détaillé est [disponible ici](https://docs.google.com/spreadsheets/d/1L3p1m2jtbSK7f3i9AYvWIHntXhI_IiVIY9RM6-IxTb8/edit?gid=925636017#gid=925636017) sous forme de tableur.\n", "options": ["végétalien . nombre", "végétarien . nombre", "viande blanche . nombre", "viande rouge . nombre", "poisson gras . nombre", "poisson blanc . nombre"], "description": "Choisissez les plats qui représentent votre semaine type. A priori, vous en aurez 14 : 7 déjeuners et 7 dîners. Mais vous pouvez néanmoins en saisir moins, ou plus.\n\nLes menus ont été travaillés pour être représentatifs des consommations alimentaires des français.\n", "suggestions": {"végétalien": {"poisson gras . nombre": 0, "viande rouge . nombre": 0, "végétalien . nombre": 14, "végétarien . nombre": 0, "poisson blanc . nombre": 0, "viande blanche . nombre": 0}, "végétarien": {"poisson gras . nombre": 0, "viande rouge . nombre": 0, "végétalien . nombre": 3, "végétarien . nombre": 11, "poisson blanc . nombre": 0, "viande blanche . nombre": 0}, "peu de viande": {"poisson gras . nombre": 1, "viande rouge . nombre": 0, "végétalien . nombre": 1, "végétarien . nombre": 7, "poisson blanc . nombre": 1, "viande blanche . nombre": 4}, "viande chaque jour": {"poisson gras . nombre": 1, "viande rouge . nombre": 6, "végétalien . nombre": 0, "végétarien . nombre": 0, "poisson blanc . nombre": 1, "viande blanche . nombre": 6}}}', 13, true),
	(14, 'alimentation . boisson . eau en bouteille . consommateur', 'alimentation', 'Buvez-vous votre eau en bouteille ?', '💧', 'BOOLEEN', '{"note": "Les français boivent en moyenne entre 100 et 150 litres d''eau en bouteille par an [source](https://www.planetoscope.com/consommation-eau/854-litres-d-eau-en-bouteille-vendus-en-france.html), soit environ un tiers de nos besoins de 1-1,5l par jour [source](https://www.mangerbouger.fr/Le-Mag/Bien-etre/L-eau-indispensable-a-notre-bonne-sante).\n\nNous avons considéré que la valeur par défaut était donc \"non\".\n", "options": ["oui", "non"], "description": "Nous cherchons à capter ici si votre consommation d''eau en bouteille est très régulière : cochez oui seulement si vous buvez de l''eau en bouteille chaque jour.\n\n> La consommation d''eau du robinet (pour tous usages) a une empreinte climat négligeable. Nous ne posons donc pas la question !\n"}', 14, true),
	(16, 'divers . textile . volume', 'divers', 'Pour quelle raison achetez-vous de nouveaux vêtements ?', '🛍️', 'CHOIX_UNIQUE', '{"options": ["minimum", "renouvellement occasionnel", "accro au shopping"], "description": "L''achat \"coup-de-coeur\" peut-être vu comme l''achat d''une pièce à la mode, tendance. L''achat par besoin est un achat réfléchi qui se fait par nécessité : remplacement de vêtements usés ou abîmés, ou nouvel usage (vous vous inscrivez au football et vous n''avez ni crampons ni short).\n"}', 16, true),
	(58, 'logement . âge', 'logement', 'Quel est l''âge de votre logement ?', '🏚️', 'CHOIX_UNIQUE', '{"note": "Il n''est pas évident de trouver un \"chiffre moyen\" pour l''âge des logements en France. Néanmoins, l''[INSEE](https://www.insee.fr/fr/statistiques/7632072?geo=EPCI-242900553&sommaire=7632098) fournit, jusqu''à 2018, les tranches d''ancienneté des résidences principales en France métropolitaine, à savoir :\n\n| Période        | Répartition (%) |\n|----------------|----------------|\n| Avant 1919     | 7,2            |\n| 1919–1945      | 5,4            |\n| 1946–1970      | 15,7           |\n| 1971–1990      | 32,0           |\n| 1991–2005      | 21,3           |\n| 2006–2017      | 18,4           |\n\nEn affectant une tranche médiane pour chaque période, on obtient un âge moyen pondéré d''environ 41 ans. En considérant que le parc de logements s''agrandit chaque année tout en vieillissant de manière générale, on peut arrondir cette valeur à 45 ans pour 2025.\n\nNB: Pour Paris, [cette carte](https://www.comeetie.fr/galerie/BatiParis) interactive est fascinante si la question de l''âge de ses logements vous intéresse.\n", "options": ["très récent", "récent", "ancien"], "description": "Un petit doute ? La date de construction de votre logement apparaît sans doute sur votre contrat d''assurance.\n", "defaultValue": "''récent''"}', 17, false),
	(59, 'logement . vacances', 'logement', 'Comment êtes-vous hébergé pour vos week-ends, vos vacances ?', '🏖️', 'CHOIX_MULTIPLE', '{"note": "### Qu''entend-on par \"nuitées hors logement\" dans Nos Gestes Climat?\n\n  - Hôtel ou chambre d''hôtes\n  - Emplacement en camping\n  - Auberge de jeunesse\n  - Locations meublées\n  - Famille ou amis\n  - Échange de maison\n  - Résidence secondaire\n  - Bateau de croisière\n\nSont donc exclues les nuits en hôtel pour **raisons professionnelles**.\n\n### Quelles données utilisons nous ?\n\nUne étude ADEME sur le secteur du tourisme en France sortie fin 2024, [Bilan des émissions de gaz à effet de serre du secteur du tourisme en France](https://librairie.ademe.fr/changement-climatique/7637-bilan-des-emissions-de-gaz-a-effet-de-serre-du-secteur-du-tourisme-en-france-en-2022.html), fournit divers chiffres relatifs aux nuitées des logements touristiques. Néanmoins, nous manquons d''hypothèses d''arrière plan et ne sommes pas en mesure de \"vérifier\" leur contenu pour éviter le double comptage par exemple. Malheureusement, le service en charge de l''étude n''a pas pu nous fournir de données plus précises. Nous avons donc retravaillé certains mode d''hébergement à partir de données plus transparentes lorsque c''était possible.\n\n### Nos hypothèses en bref\n\n- Pour l''empreinte d''une nuit au sein de sa famille ou chez des amis, l''empreinte est aujourd''hui indirectement comptée dans l''empreinte des accueillants.\n\n- Pour les hôtels et les chambres privées / chambres d''hôtes, nous considérons un facteur d''émission commun pour le moment.\n\n- L''empreinte des logements de vacances (hors auberge de jeunesse et croisière) est divisée par le nombre d''habitants du logement. C''est une hypothèse forte car on peut facilement imaginer que le famille / foyer ne voyage pas toujours au complet ! Néanmoins, on considère tout de qu''une famille composée de plus de 4 personnes prendra 2 chambres.\n", "options": ["hotel . présent", "camping . présent", "auberge de jeunesse . présent", "locations . présent", "famille ou amis . présent", "échange . présent", "résidence secondaire . présent", "croisière . présent", "aucun . présent"], "description": "Renseignez ici les différents types de logement que vous occupez pour vos voyages (à motif **personnel**).\n\n> 💡 Si vous ne partez jamais en week-end ou en vacances, vous pouvez cliquer sur \"aucun\" juste en dessous de cette question, puis \"Suivant\".\n"}', 18, false),
	(60, 'alimentation . petit déjeuner . type', 'alimentation', 'Quel petit-déjeuner vous correspond le plus ?', '🥐', 'CHOIX_UNIQUE', '{"options": ["continental", "lait céréales", "britannique", "végétalien", "aucun"], "description": "Si vous hésitez, choisissez celui qui se rapproche le plus de vos habitudes.\n\nVotre consommation de jus de fruits / café / thé / chocolat chaud sera comptabilisée dans les questions dédiées aux boissons.\n", "defaultValue": "''continental''"}', 19, false),
	(61, 'alimentation . local . consommation', 'alimentation', 'À quelle fréquence consommez-vous des produits locaux ?', '🌍', 'CHOIX_UNIQUE', '{"note": "Voir détail de l''approche de calcul [ici](http://nosgestesclimat/documentation/alimentation/local/part-locale)", "options": ["jamais", "parfois", "souvent", "oui toujours"], "description": "Si comme 40 % de français.e.s, vous cultivez vos fruits et légumes, bravo ! \nDifficile toutefois d’en estimer l’empreinte, de par la diversité des pratiques et du degré d’autonomie alimentaire.\n", "defaultValue": "''jamais''"}', 20, false),
	(63, 'alimentation . boisson . sucrées . litres', 'alimentation', 'Quelle est votre consommation par semaine de sodas, jus de fruits, etc. ?', '🥤', 'NOMBRE', '{"max": 20, "min": 0, "note": "La consommation de sodas et boissons sucrées en France est en moyenne de 50,9 litres par habitant ([source](https://www.sante-et-nutrition.com/consommation-soda-france/)) soit à peu près 1 litre par semaine.", "unit": "l/semaine", "suggestions": {"nulle": 0, "ponctuelle": 1, "quotidienne": 3}, "defaultValue": 1}', 23, false),
	(64, 'alimentation . boisson . alcool . litres', 'alimentation', 'Quelle est votre consommation par semaine d''alcool (vin, bière, etc.) ?', '🍷', 'NOMBRE', '{"max": 20, "min": 0, "note": "La consommation d''alcool en France est de 79,6 litres d''alcool, tous alcools confondus, soit à peu près 1,5 litres par semaine ([source](https://www.insee.fr/fr/statistiques/4319377#graphique-figure2))", "unit": "l/semaine", "suggestions": {"nulle": 0, "ponctuelle": 1, "quotidienne": 3}, "defaultValue": 1.5}', 24, false),
	(65, 'alimentation . déchets . quantité jetée', 'alimentation', 'Comment estimeriez-vous la quantité de déchets que vous jetez ?', '🗑️', 'CHOIX_UNIQUE', '{"options": ["base", "réduction", "zéro déchet"], "description": "Répondez ''Zéro Déchet'' uniquement si vous traquez le moindre déchet et ne sortez (quasiment) jamais vos poubelles, et \"je limite\" sinon (nous vous questionnerons alors sur les actions que vous avez mises en œuvre).\n", "defaultValue": "''réduction''"}', 25, false),
	(66, 'transport . voiture . gabarit', 'transport', 'Quel est le gabarit de la voiture ?', '🚙', 'CHOIX_UNIQUE', '{"note": "Nous considérons que la voiture par défaut est une \"Berline\", en témoigne [une étude menée par AAA Data](https://www.alphabet.com/fr-fr/parc-automobile-roulant-les-donnees-cles)\nqui indique que \"Si les SUV ont représenté 38 % des ventes de véhicules en 2019, ils ne représentent que 16 % de la totalité des véhicules en circulation, loin derrière les berlines qui comptent pour 58 %, soit 23 millions de véhicules.\"\n", "options": ["petite", "moyenne", "VUL", "berline", "SUV"], "dependances": [{"key": "transport . voiture . utilisateur", "type": "IN", "value": ["propriétaire", "régulier non propriétaire"]}], "description": "**💡 Si vous utilisez plusieurs voitures (par exemple dans le cas où vous n''en possédez pas une), choisissez la réponse la plus représentative de votre usage.**\n", "defaultValue": "''VUL''"}', 26, false),
	(67, 'transport . voiture . thermique . carburant', 'transport', 'Quel type de carburant votre voiture consomme-t-elle ?', '⛽', 'CHOIX_UNIQUE', '{"note": "La domination du couple gazole-essence est écrasante [source](https://www.leprogres.fr/magazine-automobile/2021/03/27/quels-sont-les-carburants-les-plus-utilises-dans-votre-commune).\n\nPar contre, parmi les véhicules neufs, l''essence domine aujourd''hui.\n\nLe facteur d''émission associé au biocarburant E85 n''est pas représentatif des conséquences environnementales liées à l''utilisation des biocarburants.\nEn effet, au vu des problématiques liées au changement d''affectation des sols et autres impacts environnementaux liés à la culture du maïs par exemple, les **biocarburants** ne sont pas pris en compte\n(le facteur d''émission de la base carbone étant particulièrement incertain). Voir nos discussions [ici](https://github.com/incubateur-ademe/nosgestesclimat/pull/1324).\n\nLe GPL (Gaz de Pétrole Liquéfiés) est un [résidu de l''extraction du pétrole qui était autrefois brûlé](https://fr.wikipedia.org/wiki/Gaz_de_p%C3%A9trole_liqu%C3%A9fi%C3%A9).\nIl a une empreinte carbone par litre moins importante que les véhicules essence ou diesel, par contre sa consommation est légèrement supérieure, ce qui compense légèrement le gain.\nMais si les rejets de CO2e sont au final presque équivalents entre le GPL et les autres carburants, c''est [du côté de l''émission de particules nocives](https://agirpourlatransition.ademe.fr/particuliers/conso/conso-responsable/comment-choisir-voiture-deux-roues-moins-polluant) que le GPL est un bien meilleur élève que les autres carburants thermiques.\n\nPour comprendre les différents types de carburants, [cet article pédagogique](https://www.francetvinfo.fr/economie/automobile/essence/les-carburants-changent-de-nom-a-la-pompe-voici-comment-vous-y-retrouver_2967013.html) est très utile.\n\n[Cet article](https://www.ecologie.gouv.fr/carburants-et-combustibles-autorises-en-france) du ministère de l''Écologie explique plus en détail les carburants légaux en France.\n", "options": ["gazole B7 ou B10", "essence E5 ou E10", "essence E85", "GPL"], "dependances": [{"key": "transport . voiture . motorisation", "type": "EQUAL", "value": "thermique"}], "description": "> Attention, si le type de carburant fait varier de façon significative l''empreinte climat au litre, la consommation en litre par 100km elle aussi varie. Veillez à saisir une consommation au litre basée sur votre moyenne réelle.\n", "defaultValue": "''essence E5 ou E10''"}', 27, false),
	(68, 'divers . animaux domestiques . empreinte', 'divers', 'Combien d''animaux vivent avec vous, au sein de votre foyer ?', '🐶', 'COMPTEUR', '{"options": ["petit chien . nombre", "chien moyen . nombre", "gros chien . nombre", "chats . nombre", "aucun . présent"], "description": "Les petits animaux (hamsters, canaris…) ne sont pas pris en compte, car leur empreinte est négligeable. Quant aux animaux de basse-cour comme les poules, leur faible impact est compensé par d''autres bénéfices.\n"}', 28, false),
	(69, 'divers . loisirs . culture', 'divers', 'Quelles sont vos pratiques culturelles ?', '🎭', 'CHOIX_MULTIPLE', '{"options": ["concerts et spectacles . présent", "musées et monuments . présent", "édition . présent", "pratique de la musique . présent", "aucun . présent"]}', 29, false),
	(62, 'alimentation . de saison . consommation', 'alimentation', 'À quelle fréquence consommez vous des fruits et légumes de saison ?', '🍓', 'CHOIX_UNIQUE', '{"note": "Voir détail de l''approche de calcul [ici](http://nosgestesclimat/documentation/alimentation/de-saison/pourcentage-saisonable)", "options": ["jamais", "parfois", "souvent", "oui toujours"], "defaultValue": "''jamais''"}', 21, false),
	(15, 'divers . numérique . appareils', 'divers', 'Quels appareils numériques possédez-vous ?', '💻', 'COMPTEUR', '{"note": "Cette catégorie est un peu particulière au niveau de l''amortissement. En effet, à l''inverse de l''ameublement ou l''on considère que tout est partagé au sein du foyer, ici, certains appareils sont partagés alors que d''autres sont considérés comme étant individuels.\n\nAinsi nous avons défini arbitrairement les appareils individuels (téléphone, tablette, enceinte bluetooth, ordinateur portable, console portable) et collectifs (TV, ordinateur fixe, console de salon).\n\nPour le moment, nous ne considérons pas la fin de vie des appareils ici mais dans le poste \"déchets\".\n\nSelon [le baromètre du numérique 2025](https://www.arcep.fr/uploads/tx_gspublication/barometre-du-numerique_edition_2025_RAPPORT_mars2025.pdf), un foyer français possède en moyenne 9,6 équipements numériques avec écran, soit 4,4 équipements par personne. Selon ce même rapport, parmi ces 9,6 équipements, 1,8 sont inutilisés, ce qui peut laisser penser que les saisies seront souvent sous-estimées.\n", "options": ["téléphone . nombre", "TV . nombre", "ordinateur portable . nombre", "ordinateur fixe . nombre", "tablette . nombre", "enceinte bluetooth . nombre", "console de salon . nombre", "console portable . nombre", "imprimante . nombre", "aucun . présent"], "description": "L''empreinte des **appareils partagés** au niveau du foyer (télévision ou ordinateur fixe par exemple) est **divisée par le nombre d''habitants**.\n\nL''empreinte des **appareils individuels** (comme le téléphone portable) vous est **attribuée personnellement**.\n", "suggestions": {"gamer": {"TV . nombre": 3, "tablette . nombre": 1, "imprimante . nombre": 1, "téléphone . nombre": 1, "ordinateur fixe . nombre": 1, "console de salon . nombre": 2, "console portable . nombre": 1, "enceinte bluetooth . nombre": 1, "ordinateur portable . nombre": 1}, "vie connectée": {"TV . nombre": 2, "tablette . nombre": 1, "imprimante . nombre": 1, "téléphone . nombre": 1, "ordinateur fixe . nombre": 1, "console de salon . nombre": 0, "console portable . nombre": 1, "enceinte bluetooth . nombre": 1, "ordinateur portable . nombre": 1}, "vie sans écran": {"TV . nombre": 0, "tablette . nombre": 0, "imprimante . nombre": 0, "téléphone . nombre": 1, "ordinateur fixe . nombre": 0, "console de salon . nombre": 0, "console portable . nombre": 0, "enceinte bluetooth . nombre": 1, "ordinateur portable . nombre": 1}}}', 15, true),
	(1, 'logement . type', 'logement', 'Dans quel type de logement vivez-vous principalement ?', '🏠', 'CHOIX_UNIQUE', '{"note": "En 2018, l’habitat individuel représente 56 % des logements ([Source INSEE](https://www.insee.fr/fr/statistiques/3676693?sommaire=3696937)) : il est majoritaire parmi les résidences principales comme parmi les résidences secondaires et logements occasionnels. Après avoir progressé entre 1999 et 2008 sa part recule légèrement, car le nombre de logements collectifs augmente plus vite que celui des logements individuels du fait des évolutions récentes de la construction neuve.\nNotons qu''il s''agit d''une proportion de logements ; or on peut s''attendre (à vérifier) à ce que les maisons contiennent davantage de gens en moyenne que les appartements, ce qui renforce le choix de la valeur par défaut.\n", "options": ["maison", "appartement", "autre"]}', 1, true),
	(3, 'logement . propriétaire', 'logement', 'Êtes-vous propriétaire ou locataire de votre logement ?', '🔑', 'CHOIX_UNIQUE', '{"note": "En tant que locataire, il est évidemment délicat de faire les investissements qui améliorent l''empreinte du logement : isolation, changement de source d''énergie sont impossibles sauf à tomber sur un propriétaire particulièrement conciliant.\n\nPourtant, la loi pourrait dès 2023 être un soutien de poids : les passoires thermiques [seront interdites à la location](https://www.gouvernement.fr/interdiction-a-la-location-des-logements-avec-une-forte-consommation-d-energie-des-2023), forçant les propriétaires à lancer des travaux substentiels.\n", "options": ["propriétaire", "locataire", "hébergé"], "defaultValue": "''propriétaire''"}', 3, true),
	(70, 'divers . loisirs . sports', 'divers', 'Quels sont les sports que vous pratiquez régulièrement ?', '⚽', 'CHOIX_MULTIPLE', '{"note": "La notion de régularité est volontairement imprécise, car elle dépend des sports pratiqués ainsi que du niveau du sportif.\n\nAinsi, on pourra estimer que faire de la voile une fois par mois est une pratique régulière, alors que faire un footing par mois est une pratique anecdotique.\n\nÉgalement, un sportif \"engagé\" considérera qu''une pratique régulière implique plusieurs entraînements par semaine, quand un sportif plus amateur placera peut-être la barre un peu plus bas.\n", "options": ["individuel extérieur . présent", "balle ou ballon . présent", "aquatique . présent", "salle de sport . présent", "martial ou combat . présent", "athlétisme . présent", "équitation . présent", "golf . présent", "nautique . présent", "hiver montagne . présent", "sports énergivores . présent", "autres sports . présent", "aucun . présent"]}', 30, false),
	(71, 'divers . numérique . appareils . renouvellement téléphone', 'divers', 'En 5 ans, combien de fois avez-vous changé de téléphone ?', '📱', 'CHOIX_UNIQUE', '{"note": "La durée de vie d''un smartphone est de 2,5 ans environ selon les dernières données ADEME.\nPour le moment, nous ne posons pas de question sur le caractère reconditionné de ses appareils, faute de données notamment.\n", "options": ["faible", "moyen", "élevé"], "description": "Indiquez la fréquence de renouvellement de votre téléphone. Cette information nous aide à mieux estimer l''empreinte de vos appareils numériques.\n", "defaultValue": "''moyen''"}', 31, false),
	(72, 'divers . tabac . consommation par semaine', 'divers', 'Quelle est votre consommation par semaine de tabac ?', '🚬', 'NOMBRE', '{"max": 21, "min": 0, "note": "D''après l''étude INSEE sur les [dépenses des ménages en 2017](https://www.insee.fr/fr/statistiques/4648319?sommaire=4648339), un ménage dépense en moyenne 402€ par an pour l''achat de tabac (tous ménages confondus).\nLe prix d''un paquet de cigarettes en 2017 était de [7,05 euros en moyenne](https://www.toutsurmesfinances.com/argent/a/prix-du-tabac-2017-2018-en-france-historique-et-augmentation).\nPour un ménage de 2,2 personnes (moyenne française), et à raison de 20 cigarettes par paquet, un Français moyen consomme donc environ 520 cigarettes par an, soit 26 paquets par an, soit un demi-paquet par semaine !\n\n> Autre source de données: d''après [Santé Publique France](https://www.santepubliquefrance.fr/determinants-de-sante/tabac/donnees/#tabs),\nun fumeur consomme en moyenne 12,7 cigarettes par jour, soit 4636 cigarettes par jour, ce qui est équivalent à 65 kgCO2e par an. Néanmoins, ce chiffre n''est pas pris en compte dans le calcul.\n\nAvec les hypothèses présentées en début de paragraphe, on attribue une moyenne de 7 kgCO2e environ à chacun des Français.\n", "unit": "paquet/semaine", "description": "💡 Renseignez ici votre consommation de paquets de cigarettes par semaine. On considère qu''un paquet contient 20 cigarettes.\nSi vous fumez des roulées, pensez à adapter votre calcul.\n\n> La cigarette électronique n''est pas encore prise en compte dans nos calculs, faute de données !\n", "suggestions": {"1 paquet / semaine": 1, "3 paquets / semaine": 3, "❌ Je ne fume jamais": 0}, "defaultValue": 0.5}', 32, false);


--
-- Data for Name: realisation_actions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: reponse_utilisateur; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."reponse_utilisateur" ("id", "bilan_id", "question_id", "valeur") VALUES
	(1851, 15, 1, 'maison'),
	(1852, 15, 2, '150'),
	(1853, 15, 3, 'propriétaire'),
	(1854, 15, 4, '6'),
	(1855, 15, 5, '["électricité . présent","gaz . présent"]'),
	(1856, 15, 6, 'passoire thermique'),
	(1857, 15, 7, 'régulier non propriétaire'),
	(1858, 15, 8, NULL),
	(1859, 15, 9, NULL),
	(1860, 15, 10, NULL),
	(1861, 15, 11, NULL),
	(1862, 15, 13, NULL),
	(1863, 15, 14, NULL),
	(1864, 15, 15, NULL),
	(1867, 15, 58, 'récent'),
	(1868, 15, 59, '["camping . présent","auberge de jeunesse . présent"]'),
	(1869, 15, 60, 'continental'),
	(1870, 15, 61, 'oui toujours'),
	(1865, 15, 16, NULL);


--
-- Data for Name: utilisateur_categorie_preference; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id", "type") VALUES
	('avatars', 'avatars', NULL, '2025-12-29 16:35:50.572773+00', '2025-12-29 16:35:50.572773+00', false, false, NULL, NULL, NULL, 'STANDARD'),
	('logos', 'logos', NULL, '2026-01-11 15:14:00.531785+00', '2026-01-11 15:14:00.531785+00', true, false, 512000, '{image/*}', NULL, 'STANDARD');


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id", "user_metadata", "level") VALUES
	('6853b5b5-879f-4437-9ba2-04912ebee545', 'logos', 'viveris_logo.png', NULL, '2026-01-11 15:15:19.788506+00', '2026-01-11 15:15:19.788506+00', '2026-01-11 15:15:19.788506+00', '{"eTag": "\"15ca1076106d7f531117769472467a34-1\"", "size": 6744, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-01-11T15:15:20.000Z", "contentLength": 6744, "httpStatusCode": 200}', '1989eb62-b26c-4c8a-822d-2bef6b8eeed4', NULL, NULL, 1);


--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 154, true);


--
-- Name: bilan_carbone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."bilan_carbone_id_seq"', 15, true);


--
-- Name: carbone_equivalent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."carbone_equivalent_id_seq"', 6, true);


--
-- Name: detail_bilan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."detail_bilan_id_seq"', 1, false);


--
-- Name: question_bilan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."question_bilan_id_seq"', 134, true);


--
-- Name: reponse_utilisateur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."reponse_utilisateur_id_seq"', 1882, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict 2j3Xku28ZYafuj8QBTXwvDSbPadK5xuJ5FoePbC5HP4Xwpr5R0XlCnF1QRtWFbk

RESET ALL;
