CREATE TABLE IF NOT EXISTS communaute (
    code TEXT PRIMARY KEY NOT NULL,
    nom TEXT NOT NULL,
    entreprise_id UUID NOT NULL,
    description TEXT,
    logo TEXT,
    couleurHEX VARCHAR(7) NOT NULL,
    FOREIGN KEY (logo) REFERENCES entreprise(logo) ON DELETE SET NULL,
    FOREIGN KEY (entreprise_id) REFERENCES entreprise(id) ON DELETE SET NULL
);