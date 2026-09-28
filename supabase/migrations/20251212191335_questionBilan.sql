-- Enum pour savoir quel Widget Flutter afficher
CREATE TYPE type_widget AS ENUM (
    'SLIDER',           -- Curseur
    'NOMBRE',           -- Champ texte clavier numérique (ex: Q4)
    'CHOIX_UNIQUE',     -- Radio buttons
    'CHOIX_MULTIPLE',   -- Checkboxes
    'BOOLEEN',          -- Oui/Non
    'COMPTEUR'          -- Liste d'objets avec boutons - / + (ex: Q15)
);

CREATE TABLE IF NOT EXISTS question_bilan (
    id SERIAL PRIMARY KEY,
    slug TEXT UNIQUE NOT NULL, -- ex: "logement . type"
    categorie_empreinte VARCHAR(255) NOT NULL,
    question TEXT NOT NULL,
    icone VARCHAR(50),
    type_widget type_widget NOT NULL,
    config_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    ordre_affichage INT DEFAULT 0,
    est_obligatoire BOOLEAN DEFAULT TRUE
);
