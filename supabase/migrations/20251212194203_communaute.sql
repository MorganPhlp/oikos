-- Table des communautés
CREATE TABLE IF NOT EXISTS communaute (
    code TEXT PRIMARY KEY NOT NULL,
    nom TEXT NOT NULL,
    entreprise_id UUID,
    description TEXT,
    couleurHEX VARCHAR(7) NOT NULL,
    plant_xp INT DEFAULT 0,
    total_carbon_saved FLOAT DEFAULT 0,
    logo_url TEXT,

    CONSTRAINT fk_entreprise
        FOREIGN KEY (entreprise_id)
        REFERENCES entreprise(id)
        ON DELETE SET NULL
);