CREATE TABLE IF NOT EXISTS carbone_equivalent (
    id SERIAL PRIMARY KEY,
    equivalent_label VARCHAR NOT NULL,
    valeur_1_tonne FLOAT NOT NULL
);