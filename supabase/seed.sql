-- Synthetic fixtures only. Local password: OikosLocal123!
BEGIN;
INSERT INTO categorie_empreinte (nom, icone, couleurHEX, description) VALUES
('Logement', '🏠', '#4CAF50', 'Habitat et énergie'),
('Transport', '🚗', '#2196F3', 'Déplacements et véhicules'),
('Alimentation', '🍽️', '#FF9800', 'Nourriture et boissons'),
('Energie & Eau', '⚡', '#9C27B0', 'Consommation d''énergie et d''eau'),
('Vacances & Loisirs', '🏖️', '#E91E63', 'Voyages et loisirs'),
('Numérique', '💻', '#00BCD4', 'Technologies et appareils numériques'),
('Consommation & Dechets', '🛍️', '#8BC34A', 'Consommation et déchets')
ON CONFLICT (nom) DO NOTHING;
INSERT INTO entreprise(id,nom,description,domaine_email,logo_url) VALUES
('10000000-0000-0000-0000-000000000001','Oikos Démo','Entreprise fictive locale','oikos.test','viveris/viveris_logo.png'),
('10000000-0000-0000-0000-000000000002','Autre Démo','Isolation entre entreprises','autre.test',null)
ON CONFLICT (id) DO NOTHING;
INSERT INTO communaute(code,nom,entreprise_id,description,couleurhex) VALUES
('DEMO01','Les Cyclistes','10000000-0000-0000-0000-000000000001','Équipe de démonstration','#65BA74'),
('DEMO02','Les Jardiniers','10000000-0000-0000-0000-000000000001','Deuxième équipe','#2196F3'),
('AUTRE1','Autre entreprise','10000000-0000-0000-0000-000000000002','Test isolation','#FF9800')
ON CONFLICT (code) DO NOTHING;
INSERT INTO auth.users(instance_id,id,aud,role,email,encrypted_password,email_confirmed_at,
  raw_app_meta_data,raw_user_meta_data,created_at,updated_at,confirmation_token,
  recovery_token,email_change_token_new,email_change)
SELECT '00000000-0000-0000-0000-000000000000', id::uuid,'authenticated','authenticated',email,
  extensions.crypt('OikosLocal123!',extensions.gen_salt('bf')),now(),
  '{"provider":"email","providers":["email"]}'::jsonb,
  jsonb_build_object('pseudo',pseudo,'code_communaute',code),now(),now(),'','','',''
FROM (VALUES
 ('20000000-0000-0000-0000-000000000001','admin@oikos.test','Admin démo','DEMO01'),
 ('20000000-0000-0000-0000-000000000002','alice@oikos.test','Alice','DEMO01'),
 ('20000000-0000-0000-0000-000000000003','bob@oikos.test','Bob','DEMO02'),
 ('20000000-0000-0000-0000-000000000004','eve@autre.test','Eve','AUTRE1'),
 ('20000000-0000-0000-0000-000000000005','nouveau@oikos.test','Nouveau','DEMO01')) t(id,email,pseudo,code)
ON CONFLICT (id) DO NOTHING;
INSERT INTO auth.identities(id,user_id,provider_id,identity_data,provider,created_at,updated_at)
SELECT id,id,id::text,jsonb_build_object('sub',id::text,'email',email,'email_verified',true),'email',now(),now()
FROM auth.users WHERE email LIKE '%@oikos.test' OR email LIKE '%@autre.test'
ON CONFLICT (provider_id,provider) DO NOTHING;
UPDATE utilisateur SET role='ADMINISTRATEUR' WHERE id='20000000-0000-0000-0000-000000000001';
INSERT INTO streak_steps VALUES (0,1,3,1),(1,2,5,1),(2,3,7,1),(3,4,10,1) ON CONFLICT DO NOTHING;
INSERT INTO public.actions (
    id,
    categorie_nom,
    titre,
    description,
    difficulte,
    icon_name,
    tips,
    frequence,
    tags
) VALUES
-- QUOTIDIENNES
('ef770af9-6495-401c-ae05-f7c470adc344', 'Transport', 'Jambes de fer', 'Fais tous tes trajets de moins de 2 km à pied ou à vélo', 'facile', 'directions_walk', ARRAY['Prends des baskets confortables', 'Écoute un podcast en marchant'], 'quotidienne', ARRAY['mobilité', 'sport', 'santé']),

('ae54e480-8090-4a8a-8584-2b7edb3b37fb', 'Alimentation', 'Ma Gourde à moi', 'Apporte ta gourde avec toi aujourd’hui pour dire stop au plastique', 'facile', 'water', ARRAY['Mets-la dans ton sac la veille', 'Remplis-la d''eau bien fraîche'], 'quotidienne', ARRAY['zéro-déchet', 'plastique', 'santé']),

('8dd96c53-b99a-4857-adf9-d3bd9d73003b', 'Numérique', 'Bonne nuit les datas', 'Mets ton téléphone en mode avion cette nuit pour limiter les ondes', 'facile', 'airplane_mode_active', ARRAY['Utilise un vrai réveil', 'Profite du silence'], 'quotidienne', ARRAY['numérique', 'sommeil', 'ondes']),

('64c492c9-abfe-41c6-9370-4ae592794bf0', 'Energie & Eau', 'Le Verre Solitaire', 'Utilise un verre pour te rincer les dents plutôt que de laisser couler l’eau', 'facile', 'local_bar', ARRAY['Garde ton verre sur le lavabo', 'Ne laisse pas couler l''eau inutilement'], 'quotidienne', ARRAY['eau', 'hygiène', 'économie']),

('2e462d90-f8a4-49e8-b1b2-6a406b7e1422', 'Logement', 'Pull over Chauffage', 'Baisse ton chauffage à 19°C maximum aujourd’hui', 'facile', 'checkroom', ARRAY['Mets un gros pull', 'Bois une boisson chaude'], 'quotidienne', ARRAY['énergie', 'logement', 'hiver']),

('1c8b95f2-35db-41cc-9f90-0a81ccd13675', 'Consommation & Dechets', 'Tickets ? Non merci', 'Refuse systématiquement ton ticket de caisse aujourd’hui', 'facile', 'receipt_long', ARRAY['Vérifie tes dépenses sur ton appli bancaire', 'C''est autant de papier économisé'], 'quotidienne', ARRAY['zéro-déchet', 'papier', 'minimalisme']),

-- HEBDOMADAIRES
('f9cc3c9d-4edb-4049-a4d1-5acac8374c92', 'Transport', 'Vélotaf Hero', 'Rends-toi au travail à vélo, à pied ou en transports au moins 3 jours cette semaine', 'moyenne', 'pedal_bike', ARRAY['Prépare tes affaires la veille', 'Regarde la météo pour t''équiper'], 'hebdomadaire', ARRAY['mobilité', 'travail', 'climat']),

('71fc785b-ddc7-453f-98d6-0a19d74168e7', 'Alimentation', 'Végé-Week', 'Relève le défi de passer 2 journées complètes sans viande ni poisson cette semaine', 'moyenne', 'spa', ARRAY['Teste les lasagnes végétariennes', 'Découvre les protéines de soja'], 'hebdomadaire', ARRAY['vege', 'viandard', 'climat']),

('367a08e8-dd3a-43f2-a3c3-ad5d327f8bf5', 'Numérique', 'Grand ménage digital', 'Fais ton ménage digital : supprime 50 emails et vide ta corbeille', 'moyenne', 'delete_sweep', ARRAY['Trie par expéditeur', 'Désabonne-toi des publicités'], 'hebdomadaire', ARRAY['numérique', 'organisation', 'sobriété']),

('fd3b15b8-5b8f-4943-a267-a3d2634dc4a6', 'Logement', 'Team étendoir', 'Sèche ton linge à l’air libre toute la semaine (oublie le sèche-linge)', 'moyenne', 'wb_sunny', ARRAY['Tes vêtements sentiront le frais', 'Cela abîme beaucoup moins le linge'], 'hebdomadaire', ARRAY['énergie', 'logement', 'économie']),

('c6a9b91e-9641-4b3b-9392-ce8f76eea15b', 'Consommation & Dechets', 'Zéro Emballage', 'Fais tes courses en utilisant tes propres contenants réutilisables', 'moyenne', 'shopping_basket', ARRAY['Garde tes sacs à vrac dans ta voiture ou ton sac', 'Utilise des bocaux en verre'], 'hebdomadaire', ARRAY['zéro-déchet', 'courses', 'vrac']),

-- MENSUELLES
('055358f1-39eb-46d5-9864-8b8bf67ee908', 'Transport', 'Visio > Avion', 'Remplace un déplacement professionnel par une visio ce mois-ci', 'difficile', 'videocam', ARRAY['Propose Teams ou Zoom à tes collègues', 'Valorise ton gain de temps et d''énergie'], 'mensuelle', ARRAY['numérique', 'voyage', 'travail']),

('2475dfb7-7f0a-400f-bf9b-5f0ced178f25', 'Alimentation', 'Moche-ismo no', 'Privilégie l''achat de fruits et légumes "moches" pendant tout ce mois', 'facile', 'sentiment_very_satisfied', ARRAY['Ils sont souvent moins chers', 'Ils sont parfaits pour tes soupes'], 'mensuelle', ARRAY['anti-gaspi', 'alimentation', 'budget']),

('09e60953-70ce-4b0f-8dd6-5ab15dd526a2', 'Numérique', 'Shut Down', 'Éteins complètement ton ordinateur chaque soir pendant un mois', 'moyenne', 'power_settings_new', ARRAY['Cela préserve ta batterie', 'Tu économises de l''électricité'], 'mensuelle', ARRAY['numérique', 'énergie', 'matériel']),

('fa8c829d-ff81-481e-8f22-b7d7c742e80d', 'Energie & Eau', 'Laissez de l''eau à Willy', 'Prends des douches de moins de 3 minutes pendant 1 mois', 'difficile', 'shower', ARRAY['Mets une chanson de 3 min pour te chronométrer', 'Coupe l''eau pendant que tu te savonnes'], 'mensuelle', ARRAY['eau', 'énergie', 'défi']),

('570f6a3c-d93a-4e93-9f1f-d210cadd0e55', 'Consommation & Dechets', 'No Shopping', 'Ne fais aucun achat neuf (hors alimentaire) durant tout ce mois', 'difficile', 'savings', ARRAY['Fais du tri chez toi', 'Redécouvre ce que tu as déjà dans tes placards'], 'mensuelle', ARRAY['minimalisme', 'économie', 'décroissance']),

-- BONUS
('2f3fc84d-f94e-46de-b574-fa5c32c08bfc', 'Transport', 'E-Rider', 'Passe à la vitesse supérieure en t''équipant d''un vélo électrique', 'difficile', 'electric_bike', ARRAY['Vérifie les aides de l''État disponibles', 'Essaie-le avant de l''acheter'], 'bonus', ARRAY['mobilité', 'investissement', 'électrique']),

('845ab74d-4609-48b3-8e3f-0067ee1e5468', 'Logement', 'Thermostat 2.0', 'Installe un thermostat connecté pour mieux gérer ton énergie', 'difficile', 'router', ARRAY['Il sera rentabilisé en moins d''un an', 'Pilote ton chauffage à distance'], 'bonus', ARRAY['énergie', 'logement', 'domotique']),

('f7a714a1-1eb5-4413-b7a1-82a16f03b38d', 'Consommation & Dechets', 'Boîte Zen', 'Colle un autocollant "Stop Pub" sur ta boîte aux lettres', 'facile', 'markunread_mailbox', ARRAY['Demande-le à ta mairie', 'Tu peux aussi l''imprimer toi-même'], 'bonus', ARRAY['zéro-déchet', 'papier', 'minimalisme']),

('c4f651e4-a398-4e9d-952b-7f4d5fccb32a', 'Energie & Eau', 'Quand il pleut, je stocke', 'Installe un récupérateur d’eau de pluie pour ton jardin ou tes plantes', 'difficile', 'cloud', ARRAY['Utilise cette eau pour arroser ton jardin', 'Tu peux aussi t''en servir pour laver ta voiture'], 'bonus', ARRAY['eau', 'jardin', 'investissement'])

ON CONFLICT (id) DO UPDATE SET
    description = EXCLUDED.description,
    tips = EXCLUDED.tips;
INSERT INTO public.limite_actions_freq (frequence, nombre)
VALUES
    ('quotidienne', 5),
    ('hebdomadaire', 8),
    ('mensuelle', 10),
    ('bonus', 5);
INSERT INTO bilan_carbone(id,utilisateur_id,date_bilan,scoretotalco2ean,complet) VALUES
(1001,'20000000-0000-0000-0000-000000000002',now()-interval '35 days',8000,true),
(1002,'20000000-0000-0000-0000-000000000002',now()-interval '2 days',6500,true),
(1003,'20000000-0000-0000-0000-000000000003',now()-interval '1 day',7200,true),
(1004,'20000000-0000-0000-0000-000000000004',now(),9000,true)
ON CONFLICT (id) DO NOTHING;
UPDATE utilisateur SET a_complete_bilan=true WHERE id IN
('20000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000004');
INSERT INTO detail_bilan(id,transport,alimentation,logement,divers,services_societaux) VALUES
(1001,3000,2000,1500,700,800),(1002,2100,1800,1200,600,800),(1003,2500,2000,1200,700,800),(1004,4000,2000,1500,700,800)
ON CONFLICT(id) DO NOTHING;
SELECT setval(pg_get_serial_sequence('bilan_carbone','id'),1004,true);
SELECT setval(pg_get_serial_sequence('detail_bilan','id'),1004,true);
INSERT INTO carbone_equivalent(equivalent_label,valeur_1_tonne,icone)
SELECT 'A/R Paris-New York en avion',0.49,'✈️' WHERE NOT EXISTS (SELECT FROM carbone_equivalent);
INSERT INTO action_communautaire(id,entreprise_id,action_id,titre_personnalise,date_fin,createur_id)
SELECT '30000000-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000001',id,
 'Semaine mobilité douce', now()+interval '14 days','20000000-0000-0000-0000-000000000001'
FROM actions WHERE categorie_nom='Transport' ORDER BY id LIMIT 1 ON CONFLICT(id) DO NOTHING;
INSERT INTO notifications(id,user_id,type,data) VALUES
('40000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000002','bilan','{"title":"Ton bilan est disponible"}')
ON CONFLICT(id) DO NOTHING;
COMMIT;
