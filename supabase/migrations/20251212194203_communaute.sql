CREATE TABLE IF NOT EXISTS communaute (
    code TEXT PRIMARY KEY NOT NULL,
    nom TEXT NOT NULL,
    entreprise_id UUID NOT NULL,
    description TEXT,
    couleurHEX VARCHAR(7) NOT NULL,

    CONSTRAINT fk_entreprise
        FOREIGN KEY (entreprise_id)
        REFERENCES entreprise(id)
        ON DELETE SET NULL
);