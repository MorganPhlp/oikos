CREATE TABLE IF NOT EXISTS detail_bilan (
    id SERIAL PRIMARY KEY REFERENCES bilan_Carbone(id) ON DELETE CASCADE,
    transport FLOAT DEFAULT 0,
    alimentation FLOAT DEFAULT 0,
    logement FLOAT DEFAULT 0,
    divers FLOAT DEFAULT 0,
    services_societaux FLOAT DEFAULT 0
);