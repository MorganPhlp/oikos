-- Scénario fictif : utilisateur "Sophie Martin"

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

-- 4. Equivalent Carbone
INSERT INTO carbone_equivalent (equivalent_label, valeur_1_tonne, icone) VALUES
('A/R Paris-New York en avion', 0.49, '✈️'),
('Litres d''eau', 130000, '💧'),
('% de l''empreinte carbone moyenne d''un français', 11, '🇫🇷')
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
('ef770af9-6495-401c-ae05-f7c470adc344', 'Transport', 'Jambes de fer', 'Faire tous les trajets de moins de 2 km à pied ou à vélo', 'facile', 'directions_walk', ARRAY['Prenez des baskets confortables', 'Écoutez un podcast'], 'quotidienne', ARRAY['mobilité', 'sport', 'santé']),
('ae54e480-8090-4a8a-8584-2b7edb3b37fb', 'Alimentation', 'Ma Gourde à moi', 'Apporter sa gourde aujourd’hui (stop plastique)', 'facile', 'water', ARRAY['Mettez-la dans le sac la veille', 'Remplissez-la d''eau fraîche'], 'quotidienne', ARRAY['zéro-déchet', 'plastique', 'santé']),
('8dd96c53-b99a-4857-adf9-d3bd9d73003b', 'Numérique', 'Bonne nuit les datas', 'Mettre son téléphone en mode avion la nuit', 'facile', 'airplane_mode_active', ARRAY['Utilisez un vrai réveil', 'Profitez du silence'], 'quotidienne', ARRAY['numérique', 'sommeil', 'ondes']),
('64c492c9-abfe-41c6-9370-4ae592794bf0', 'Energie & Eau', 'Le Verre Solitaire', 'Utiliser un verre pour se rincer les dents', 'facile', 'local_bar', ARRAY['Gardez le verre sur le lavabo', 'Ne laissez pas couler l''eau'], 'quotidienne', ARRAY['eau', 'hygiène', 'économie']),
('2e462d90-f8a4-49e8-b1b2-6a406b7e1422', 'Logement', 'Pull over Chauffage', 'Baisser le chauffage à 19°C max aujourd''hui', 'facile', 'checkroom', ARRAY['Mettez un gros pull', 'Buvez une boisson chaude'], 'quotidienne', ARRAY['énergie', 'logement', 'hiver']),
('1c8b95f2-35db-41cc-9f90-0a81ccd13675', 'Consommation & Dechets', 'Tickets ? Non merci', 'Refuser le ticket de caisse systématiquement', 'facile', 'receipt_long', ARRAY['Vérifiez sur l''appli bancaire', 'C''est moins de papier'], 'quotidienne', ARRAY['zéro-déchet', 'papier', 'minimalisme']),
('f9cc3c9d-4edb-4049-a4d1-5acac8374c92', 'Transport', 'Vélotaf Hero', 'Aller au travail à vélo/pied/transports 3 jours cette semaine', 'moyenne', 'pedal_bike', ARRAY['Préparez vos affaires la veille', 'Regardez la météo'], 'hebdomadaire', ARRAY['mobilité', 'travail', 'climat']),
('71fc785b-ddc7-453f-98d6-0a19d74168e7', 'Alimentation', 'Végé-Week', '2 journées complètes sans viande ni poisson cette semaine', 'moyenne', 'spa', ARRAY['Testez les lasagnes végétariennes', 'Découvrez les protéines de soja'], 'hebdomadaire', ARRAY['vege', 'viandard', 'climat']),
('367a08e8-dd3a-43f2-a3c3-ad5d327f8bf5', 'Numérique', 'Grand ménage digital', 'Supprimer 50 emails et vider la corbeille', 'moyenne', 'delete_sweep', ARRAY['Triez par expéditeur', 'Désabonnez-vous des pubs'], 'hebdomadaire', ARRAY['numérique', 'organisation', 'sobriété']),
('fd3b15b8-5b8f-4943-a267-a3d2634dc4a6', 'Logement', 'Team étendoir', 'Sécher le linge à l’air libre (pas de sèche-linge) cette semaine', 'moyenne', 'wb_sunny', ARRAY['Ça sent le frais', 'Ça abîme moins le linge'], 'hebdomadaire', ARRAY['énergie', 'logement', 'économie']),
('c6a9b91e-9641-4b3b-9392-ce8f76eea15b', 'Consommation & Dechets', 'Zéro Emballage', 'Faire ses courses avec ses propres contenants', 'moyenne', 'shopping_basket', ARRAY['Gardez les sacs à vrac dans la voiture', 'Utilisez des bocaux'], 'hebdomadaire', ARRAY['zéro-déchet', 'courses', 'vrac']),
('055358f1-39eb-46d5-9864-8b8bf67ee908', 'Transport', 'Visio > Avion', 'Remplacer un déplacement pro par une visio ce mois-ci', 'difficile', 'videocam', ARRAY['Proposez Teams ou Zoom', 'Valorisez le gain de temps'], 'mensuelle', ARRAY['numérique', 'voyage', 'travail']),
('2475dfb7-7f0a-400f-bf9b-5f0ced178f25', 'Alimentation', 'Moche-ismo no', 'Acheter des fruits & légumes "moches" pendant 1 mois', 'facile', 'sentiment_very_satisfied', ARRAY['Ils sont moins chers', 'Idéal pour les soupes'], 'mensuelle', ARRAY['anti-gaspi', 'alimentation', 'budget']),
('09e60953-70ce-4b0f-8dd6-5ab15dd526a2', 'Numérique', 'Shut Down', 'Éteindre complètement l''ordinateur chaque soir du mois', 'moyenne', 'power_settings_new', ARRAY['Préserve la batterie', 'Économise de l''électricité'], 'mensuelle', ARRAY['numérique', 'énergie', 'matériel']),
('fa8c829d-ff81-481e-8f22-b7d7c742e80d', 'Energie & Eau', 'Laissez de l''eau à Willy', 'Prendre des douches de moins de 3 minutes pendant 1 mois', 'difficile', 'shower', ARRAY['Mettez une chanson de 3 min', 'Coupez l''eau en savonnant'], 'mensuelle', ARRAY['eau', 'énergie', 'défi']),
('570f6a3c-d93a-4e93-9f1f-d210cadd0e55', 'Consommation & Dechets', 'No Shopping', 'Ne rien acheter de neuf (hors alimentaire) ce mois-ci', 'difficile', 'savings', ARRAY['Faites du tri', 'Redécouvrez vos placards'], 'mensuelle', ARRAY['minimalisme', 'économie', 'décroissance']),
('2f3fc84d-f94e-46de-b574-fa5c32c08bfc', 'Transport', 'E-Rider', 'Acheter un vélo électrique', 'difficile', 'electric_bike', ARRAY['Testez les aides de l''État', 'Essayez avant d''acheter'], 'bonus', ARRAY['mobilité', 'investissement', 'électrique']),
('845ab74d-4609-48b3-8e3f-0067ee1e5468', 'Logement', 'Thermostat 2.0', 'Installer un thermostat connecté', 'difficile', 'router', ARRAY['Rentabilisé en 1 an', 'Pilotable à distance'], 'bonus', ARRAY['énergie', 'logement', 'domotique']),
('f7a714a1-1eb5-4413-b7a1-82a16f03b38d', 'Consommation & Dechets', 'Boîte Zen', 'Coller un "Stop Pub" sur sa boîte aux lettres', 'facile', 'markunread_mailbox', ARRAY['Demandez à la mairie', 'Imprimez-le'], 'bonus', ARRAY['zéro-déchet', 'papier', 'minimalisme']),
('c4f651e4-a398-4e9d-952b-7f4d5fccb32a', 'Energie & Eau', 'Quand il pleut, je stocke', 'Installer un récupérateur d''eau de pluie', 'difficile', 'cloud', ARRAY['Arrosez le jardin', 'Lavez la voiture'], 'bonus', ARRAY['eau', 'jardin', 'investissement'])
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.limite_actions_freq VALUES (
    ('quotidienne',5),
    ('hebdomadaire', 8),
    ('mensuelle', 10),
    ('bonus',null);
)