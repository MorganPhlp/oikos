CREATE TABLE IF NOT EXISTS entreprise (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nom TEXT NOT NULL,
    logo TEXT,
    description TEXT,
    domaine_email TEXT NOT NULL
);