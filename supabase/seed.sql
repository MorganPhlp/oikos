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

-- 2. Communauté
INSERT INTO communaute (nom, description, logo, couleurHEX) VALUES
('Viveris', 'Le sang', 'logo', '#4CAF50')
ON CONFLICT (nom) DO NOTHING;

-- 3. Equivalent Carbone
INSERT INTO carbone_equivalent (equivalent_label, valeur_1_tonne) VALUES
('A/R Paris-New York en avion', 0.49),
('A/R Paris-Marseille en TGV', 227),
('kg de baguette tradition', 1287)

-- =============================================
-- 3. UTILISATEUR FICTIF (Lien Auth + Profil)
-- =============================================

/*
-- 4. Questions du bilan
INSERT INTO questionBilan (categorieEmpreinte, question, icone, type_widget, config_json, ordre_affichage) VALUES

-- =============================================
-- 1. LOGEMENT
-- =============================================

-- Q1 Type de logement
('Logement', 'Dans quel type de logement vivez-vous principalement ?', 'home', 'CHOIX_UNIQUE', 
 '{
   "options": [
     {"label": "Maison", "value": "maison"},
     {"label": "Appartement", "value": "appartement"},
     {"label": "Autre", "value": "atypique"}
   ]
 }', 1),

-- Q2 Surface (SLIDER avec SUGGESTIONS)
('Logement', 'Quelle est la surface de votre logement ?', 'square_foot', 'SLIDER', 
 '{
   "min": 9, 
   "max": 300, 
   "step": 1, 
   "unit": "m²", 
   "defaultValue": 40,
   "suggestions": [
     {"label": "Studio (20m²)", "value": 20},
     {"label": "T2 (45m²)", "value": 45},
     {"label": "Maison (100m²)", "value": 100}
   ]
 }', 2),

-- Q3 Statut
('Logement', 'Êtes-vous propriétaire ou locataire ?', 'key', 'CHOIX_UNIQUE', 
 '{
   "options": [
     {"label": "Propriétaire", "value": "proprietaire"},
     {"label": "Locataire", "value": "locataire"},
     {"label": "Hébergé(e) gratuitement", "value": "gratuit"}
   ]
 }', 3),

-- Q4 Habitants (TYPE NOMBRE avec SUGGESTIONS)
-- L''utilisateur tape le chiffre exact, ou clique sur un bouton rapide.
('Logement', 'Combien de personnes composent votre foyer ?', 'group', 'NOMBRE', 
 '{
   "min": 1, 
   "max": 15, 
   "unit": "pers", 
   "defaultValue": 1,
   "suggestions": [
     {"label": "Seul(e)", "value": 1},
     {"label": "Couple", "value": 2},
     {"label": "Famille (4)", "value": 4},
     {"label": "Coloc (5)", "value": 5}
   ]
 }', 4),

-- Q5 Énergie
('Logement', 'Quelle(s) énergie(s) utilisez-vous ?', 'local_fire_department', 'CHOIX_MULTIPLE', 
 '{
   "options": [
    {"label": "Électricité", "value": "electricite", "hidden": false},
    {"label": "Pompe à chaleur", "value": "pompe_chaleur", "hidden": false},
    {"label": "Bois ou granules", "value": "bois_granules", "hidden": false},
    {"label": "Climatiseurs", "value": "climatiseurs", "hidden": false},
    {"label": "Panneaux photovoltaïques", "value": "panneaux_photovoltaiques", "hidden": false},
    {"label": "Gaz naturel", "value": "gaz_naturel", hidden": false},
    {"label": "Chauffe-eau solaire", "value": "chauffe_eau_solaire", "hidden": true},
    {"label": "Réseau de chaleur", "value": "reseau_chaleur", "hidden": true},
    {"label": "Bouteille de gaz", "value": "bouteille_gaz", "hidden": true},
    {"label": "Gaz propane en citerne", "value": "gaz_propane_citerne", "hidden": true},
    {"label": "Fioul domestique", "value": "fioul_domestique", "hidden": true},
    {"label": "Autre" , "value": "autre", "hidden": true}
   ]
 }', 5),

-- Q6 Confort
('Logement', 'Comment ressentez-vous la température chez vous en hiver ?', 'thermostat', 'CHOIX_UNIQUE', 
 '{
   "options": [
     {"label": "Froid", "value": "froid"},
     {"label": "Confortable", "value": "confort"},
     {"label": "Chaud", "value": "chaud"}
   ]
 }', 6),


-- =============================================
-- 2. TRANSPORT
-- =============================================

-- Q7 Voiture (Bool)
('Transport', 'Vous arrive-t-il de vous déplacer en voiture ?', 'directions_car', 'CHOIX_UNIQUE', 
    '{ 
    "options": [ 
        {"label": "Oui, avec ma voiture", "value": "oui_propre"}, 
        {"label": "Oui, avec le véhicule de un proche", "value": "oui_proche"},
        {"label": "Oui, avec des voitures différentes (covoiturage, location...)", "value": "oui_divers"},
        {"label": "Non", "value": "non"} 
    ] 
    }'
, 7),

-- Q8 Distance (SLIDER avec SUGGESTIONS de profils)
('Transport', 'Quelle distance parcourez-vous par an en voiture ?', 'speed', 'SLIDER', 
 '{
   "min": 0, 
   "max": 50000, 
   "step": 500, 
   "unit": "km", 
   "defaultValue": 5000,
   "suggestions": [
     {"label": "Occasionnel (3000 km)", "value": 3000},
     {"label": "Moyen (12 000 km)", "value": 12000},
     {"label": "Gros rouleur (25 000 km)", "value": 25000}
   ]
 }', 8),

-- Q9 Type moteur
('Transport', 'Type de motorisation principal ?', 'ev_station', 'CHOIX_UNIQUE', 
 '{
   "options": [
     {"label": "Thermique", "value": "thermique"},
     {"label": "Hybride rechargeable", "value": "hybride_rechargeable"},
     {"label": "Hybride non rechargeable", "value": "hybride_non_rechargeable"},
     {"label": "Électrique", "value": "electrique"}
   ]
 }', 9),

-- Q10 Alternatifs
('Transport', 'Autres modes de transport ?', 'pedal_bike', 'CHOIX_MULTIPLE', 
 '{
   "options": [
     {"label": "Marche/Vélo", "value": "actif"},
     {"label": "Petit véhicule électrique", "value": "pve"},
     {"label": "Vélo électrique", "value": "vae"},
   ]
 }', 10),

-- Q11 Avion (Bool)
('Transport', 'Avez-vous pris l''avion au moins une fois ces 3 dernières années ?', 'flight', 'BOOLEEN', 
 '{"label_true": "Oui", "label_false": "Non"}', 11),

-- Q12 Heures vol (SLIDER avec SUGGESTIONS)
('Transport', 'Si oui, sur une année le nombre d''heures de vol long, moyen et court-courrier (>6h, 2-6h, <2h)', 'schedule', 'NO?MBRE', 
    '{
    "min": 0, 
    "max": 200, 
    "unit": "heures", 
    "defaultValue": 0,
    "suggestions": [
        {"label": "Occasionnel (10h)", "value": 10},
        {"label": "Voyageur régulier (50h)", "value": 50},
        {"label": "Grand voyageur (100h)", "value": 100}
    ]
 }', 12),


-- =============================================
-- 3. ALIMENTATION
-- =============================================

-- Q13 Régime
('Alimentation', 'Choisissez les 14 types de repas (déjeuners et dîners) de votre semaine-type :', 'restaurant', 'COMPTEUR', 
 '{
    "min": 0,
    "max": 21,
    "options": [
      {"label": "Végétalien", "value": "alimentation . plats . végétalien . nombre"},
      {"label": "Végétarien", "value": "alimentation . plats . végétarien . nombre"},
      {"label": "Viande Blanche", "value": "alimentation . plats . viande blanche . nombre"},
      {"label": "Viande Rouge", "value": "alimentation . plats . viande rouge . nombre"},
      {"label": "Poisson Gras", "value": "alimentation . plats . poisson gras . nombre"},
      {"label": "Poisson Blanc", "value": "alimentation . plats . poisson blanc . nombre"}

    ]
 }', 13),

-- Q14 Eau
('Alimentation', 'Buvez-vous votre eau en bouteille ?', 'water_drop', 'CHOIX_UNIQUE', 
 '{
   "options": [
     {"label": "Oui", "value": "alimentation . boisson . eau en bouteille"},
     {"label": "Non", "value": "alimentation . boisson . eau en bouteille"}
   ]
 }', 14),


-- =============================================
-- 4. NUMÉRIQUE (NOUVEAU TYPE COMPTEUR)
-- =============================================

-- Q15 Équipements (COMPTEUR)
-- L''interface affichera chaque label avec un bouton [-] 0 [+] à côté.
('Numérique', 'Indiquez le nombre d''appareils que vous possédez (achetés neufs) :', 'devices', 'COMPTEUR', 
 '{
   "options": [
     {"label": "Téléphone", "value": "divers . numérique . appareils . téléphone . nombre"},
     {"label": "Ordinateur Portable", "value": "divers . numérique . appareils . ordinateur portable . nombre"},
     {"label": "Ordinateur Fixe", "value": "divers . numérique . appareils . ordinateur fixe . nombre"},
     {"label": "Tablette", "value": "divers . numérique . appareils . tablette . nombre"},
     {"label": "TV", "value": "divers . numérique . appareils . TV . nombre"},
     {"label": "Console de salon", "value": "divers . numérique . appareils . console de salon . nombre"},
     {"label": "Imprimante", "value": "divers . numérique . appareils . imprimante . nombre"},
     {"label": "Console portable", "value": "divers . numérique . appareils . console portable . nombre"},
     {"label": "Enceinte bluetooth", "value": "divers . numérique . appareils . enceinte bluetooth . nombre"},
     {"label": "Aucun", "value": ""}
   ]
 }', 15),


-- =============================================
-- 5. CONSOMMATION
-- =============================================

-- Q16 Vêtements
('Consommation_Dechets', 'Pour quelle raison achetez-vous de nouveaux vêtements ?​', 'shopping_bag', 'CHOIX_UNIQUE', 
 '{
   "options": [
     {"label": "Je n''achète que le strict nécessaire", "value": "divers . textile . volume . minimum"},
     {"label": "J''achète par besoin mais je peux céder à des achats coup-de-coeur", "value": "divers . textile . volume . renouvellement occasionnel"},
     {"label": "Je fais plus souvent des achats par plaisir que besoin", "value": "divers . textile . volume . accro au shopping
     "}
   ]
 }', 16);
 */