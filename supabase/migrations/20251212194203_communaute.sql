CREATE TABLE IF NOT EXISTS communaute (
    nom VARCHAR(255) PRIMARY KEY,
    description TEXT,
    logo VARCHAR(255),
    couleurHEX VARCHAR(7) NOT NULL
);