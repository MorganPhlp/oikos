-- 1. Catégories
INSERT INTO categorie_empreinte (nom, icone, couleurHEX, description) VALUES
('Logement', '🏠', '#4CAF50', 'Habitat et énergie'),
('Transport', '🚗', '#2196F3', 'Déplacements et véhicules'),
('Alimentation', '🍽️', '#FF9800', 'Nourriture et boissons'),
('Energie & Eau', '⚡', '#9C27B0', 'Consommation d''énergie et d''eau'),
('Vacances & Loisirs', '🏖️', '#E91E63', 'Voyages et loisirs'),
('Numérique', '💻', '#00BCD4', 'Technologies et appareils numériques'),
('Consommation & Dechets', '🛍️', '#8BC34A', 'Consommation et déchets')
ON CONFLICT (nom) DO NOTHING;

-- 2. Entreprise
INSERT INTO entreprise (nom, description, domaine_email, logo_url) VALUES
('Viveris', 'Entreprise de services du numérique', 'viveris.fr', 'viveris_logo.png')
ON CONFLICT DO NOTHING;
INSERT INTO entreprise (id, nom, description, domaine_email, logo_url) VALUES 
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Oîkos Demo Corp', 'Entreprise fictive pour démonstration', 'oikos-demo.com', 'oikos_demo_logo.png')
ON CONFLICT (id) DO NOTHING;

-- 3. Communauté
INSERT INTO communaute (code, nom, entreprise_id, description, couleurHEX) VALUES
('VIV123', 'Service Informatique Viveris', (SELECT id FROM entreprise WHERE nom = 'Viveris'), 'Service du meilleur métier', '#4CAF50')
ON CONFLICT (code) DO NOTHING;
-- communaute fictive pour les tests
INSERT INTO communaute (code, nom, entreprise_id, description, couleurHEX) VALUES
('DEMO001', 'Communauté de Démo', (SELECT id FROM entreprise WHERE nom = 'Viveris'), 'Communauté pour les tests et démonstrations', '#2196F3')
ON CONFLICT (code) DO NOTHING;


-- 4. Equivalent Carbone
INSERT INTO carbone_equivalent (equivalent_label, valeur_1_tonne, icone) VALUES
('A/R Paris-New York en avion', 0.49, '✈️'),
('Litres d''eau', 130000, '💧'),
('Tour(s) du monde en voiture', 0.11, '🚗')

ON CONFLICT DO NOTHING;


INSERT INTO streak_steps (from_streak_phase, to_streak_phase, required_actions_quotidiennes, required_actions_communautaires) VALUES
(0, 1, 3, 1),
(1, 2, 5, 1),
(2, 3, 7, 1),
(3, 4, 10, 1);


-- 5. actions

-- 5. Insertion des actions (Vérifiée pour Foreign Keys et ENUMs)
-- Assure-toi que la colonne existe avant de lancer l'insert
-- ALTER TABLE public.actions ADD COLUMN IF NOT EXISTS tags text[] DEFAULT '{}';

INSERT INTO "public"."actions" (
    "id", "categorie_nom", "titre", "description", "difficulte", "impact_score", "icon_name", "tips", "frequence", "tags"
) VALUES
('055358f1-39eb-46d5-9864-8b8bf67ee908', 'Transport', 'Visio > Avion', 'Remplace un déplacement professionnel par une visio ce mois-ci', 'difficile', 300, 'videocam', ARRAY['Propose Teams ou Zoom à tes collègues','Valorise ton gain de temps et d''énergie'], 'mensuelle', ARRAY['numerique','voyage','travail','carbone']),
('09e60953-70ce-4b0f-8dd6-5ab15dd526a2', 'Numérique', 'Shut Down', 'Éteins complètement ton ordinateur chaque soir pendant un mois', 'moyenne', 150, 'power_settings_new', ARRAY['Cela préserve ta batterie','Tu économises de l''électricité'], 'mensuelle', ARRAY['numerique','energie','materiel','sobriete']),
('1c8b95f2-35db-41cc-9f90-0a81ccd13675', 'Consommation & Dechets', 'Tickets ? Non merci', 'Refuse systématiquement ton ticket de caisse aujourd’hui', 'facile', 10, 'receipt_long', ARRAY['Vérifie tes dépenses sur ton appli bancaire','C''est autant de papier économisé'], 'quotidienne', ARRAY['zero-dechet','papier','minimalisme','consommation']),
('2475dfb7-7f0a-400f-bf9b-5f0ced178f25', 'Alimentation', 'Moche-ismo no', 'Privilégie l''achat de fruits et légumes "moches" pendant tout ce mois', 'facile', 150, 'sentiment_very_satisfied', ARRAY['Ils sont souvent moins chers','Ils sont parfaits pour tes soupes'], 'mensuelle', ARRAY['anti-gaspi','alimentation','budget','ethique']),
('2e462d90-f8a4-49e8-b1b2-6a406b7e1422', 'Logement', 'Pull over Chauffage', 'Baisse ton chauffage à 19°C maximum aujourd’hui', 'facile', 40, 'checkroom', ARRAY['Mets un gros pull','Bois une boisson chaude'], 'quotidienne', ARRAY['energie','logement','hiver','chauffage']),
('2f3fc84d-f94e-46de-b574-fa5c32c08bfc', 'Transport', 'E-Rider', 'Passe à la vitesse supérieure en t''équipant d''un vélo électrique', 'difficile', 500, 'electric_bike', ARRAY['Vérifie les aides de l''État disponibles','Essaie-le avant de l''acheter'], 'bonus', ARRAY['mobilite','investissement','electrique','transport']),
('367a08e8-dd3a-43f2-a3c3-ad5d327f8bf5', 'Numérique', 'Grand ménage digital', 'Fais ton ménage digital : supprime 50 emails et vide ta corbeille', 'moyenne', 50, 'delete_sweep', ARRAY['Trie par expéditeur','Désabonne-toi des publicités'], 'hebdomadaire', ARRAY['numerique','organisation','sobriete','pollution-numerique']),
('570f6a3c-d93a-4e93-9f1f-d210cadd0e55', 'Consommation & Dechets', 'No Shopping', 'Ne fais aucun achat neuf (hors alimentaire) durant tout ce mois', 'difficile', 250, 'savings', ARRAY['Fais du tri chez toi','Redécouvre ce que tu as déjà dans tes placards'], 'mensuelle', ARRAY['minimalisme','economie','decroissance','consommation']),
('64c492c9-abfe-41c6-9370-4ae592794bf0', 'Energie & Eau', 'Le Verre Solitaire', 'Utilise un verre pour te rincer les dents plutôt que de laisser couler l’eau', 'facile', 20, 'local_bar', ARRAY['Garde ton verre sur le lavabo','Ne laisse pas couler l''eau inutilement'], 'quotidienne', ARRAY['eau','hygiene','economie','ressources']),
('71fc785b-ddc7-453f-98d6-0a19d74168e7', 'Alimentation', 'Végé-Week', 'Relève le défi de passer 2 journées complètes sans viande ni poisson cette semaine', 'moyenne', 100, 'spa', ARRAY['Teste les lasagnes végétariennes','Découvre les protéines de soja'], 'hebdomadaire', ARRAY['alimentation','vegetarien','climat','sante']),
('845ab74d-4609-48b3-8e3f-0067ee1e5468', 'Logement', 'Thermostat 2.0', 'Installe un thermostat connecté pour mieux gérer ton énergie', 'difficile', 600, 'router', ARRAY['Il sera rentabilisé en moins d''un an','Pilote ton chauffage à distance'], 'bonus', ARRAY['energie','logement','domotique','innovation']),
('8dd96c53-b99a-4857-adf9-d3bd9d73003b', 'Numérique', 'Bonne nuit les datas', 'Mets ton téléphone en mode avion cette nuit pour limiter les ondes', 'facile', 30, 'airplane_mode_active', ARRAY['Utilise un vrai réveil','Profite du silence'], 'quotidienne', ARRAY['numerique','sommeil','ondes','bien-etre']),
('ae54e480-8090-4a8a-8584-2b7edb3b37fb', 'Alimentation', 'Ma Gourde à moi', 'Apporte ta gourde avec toi aujourd’hui pour dire stop au plastique', 'facile', 20, 'water', ARRAY['Mets-la dans ton sac la veille','Remplis-la d''eau bien fraîche'], 'quotidienne', ARRAY['zero-dechet','plastique','sante','eco-geste']),
('c4f651e4-a398-4e9d-952b-7f4d5fccb32a', 'Energie & Eau', 'Quand il pleut, je stocke', 'Installe un récupérateur d’eau de pluie pour ton jardin ou tes plantes', 'difficile', 1000, 'cloud', ARRAY['Utilise cette eau pour arroser ton jardin','Tu peux aussi t''en servir pour laver ta voiture'], 'bonus', ARRAY['eau','jardin','investissement','autonomie']),
('c6a9b91e-9641-4b3b-9392-ce8f76eea15b', 'Consommation & Dechets', 'Zéro Emballage', 'Fais tes courses en utilisant tes propres contenants réutilisables', 'moyenne', 50, 'shopping_basket', ARRAY['Garde tes sacs à vrac dans ta voiture ou ton sac','Utilise des bocaux en verre'], 'hebdomadaire', ARRAY['zero-dechet','courses','vrac','consommation']),
('ef770af9-6495-401c-ae05-f7c470adc344', 'Transport', 'Jambes de fer', 'Fais tous tes trajets de moins de 2 km à pied ou à vélo', 'facile', 20, 'directions_walk', ARRAY['Prends des baskets confortables','Écoute un podcast en marchant'], 'quotidienne', ARRAY['mobilite','sport','sante','carbone']),
('f7a714a1-1eb5-4413-b7a1-82a16f03b38d', 'Consommation & Dechets', 'Boîte Zen', 'Colle un autocollant "Stop Pub" sur ta boîte aux lettres', 'facile', 100, 'markunread_mailbox', ARRAY['Demande-le à ta mairie','Tu peux aussi l''imprimer toi-même'], 'bonus', ARRAY['zero-dechet','papier','minimalisme','boite-aux-lettres']),
('f9cc3c9d-4edb-4049-a4d1-5acac8374c92', 'Transport', 'Vélotaf Hero', 'Rends-toi au travail à vélo, à pied ou en transports au moins 3 jours cette semaine', 'moyenne', 100, 'pedal_bike', ARRAY['Prépare tes affaires la veille','Regarde la météo pour t''équiper'], 'hebdomadaire', ARRAY['mobilite','travail','climat','transport']),
('fa8c829d-ff81-481e-8f22-b7d7c742e80d', 'Energie & Eau', 'Laissez de l''eau à Willy', 'Prends des douches de moins de 3 minutes pendant 1 mois', 'difficile', 300, 'shower', ARRAY['Mets une chanson de 3 min pour te chronométrer','Coupe l''eau pendant que tu te savonnes'], 'mensuelle', ARRAY['eau','energie','defi','hygiene']),
('fd3b15b8-5b8f-4943-a267-a3d2634dc4a6', 'Logement', 'Team étendoir', 'Sèche ton linge à l’air libre toute la semaine (oublie le sèche-linge)', 'moyenne', 100, 'wb_sunny', ARRAY['Tes vêtements sentiront le frais','Cela abîme beaucoup moins le linge'], 'hebdomadaire', ARRAY['energie','logement','economie','electricite'])
ON CONFLICT (id) DO UPDATE SET
    categorie_nom = EXCLUDED.categorie_nom,
    titre = EXCLUDED.titre,
    difficulte = EXCLUDED.difficulte,
    impact_score = EXCLUDED.impact_score;


