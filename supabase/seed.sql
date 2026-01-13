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
