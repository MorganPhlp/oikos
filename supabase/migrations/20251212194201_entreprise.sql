-- Création de la table ENTREPRISE
CREATE TABLE IF NOT EXISTS entreprise (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nom TEXT NOT NULL,
    logo_url TEXT,
    description TEXT,
    domaine_email TEXT NOT NULL
);

