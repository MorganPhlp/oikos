-- 1. CRÉATION DES TYPES ENUM (Inchangé mais sécurisé)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'role_utilisateur') THEN
        CREATE TYPE role_utilisateur AS ENUM ('UTILISATEUR', 'ADMINISTRATEUR');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'etat_compte') THEN
        CREATE TYPE etat_compte AS ENUM ('ACTIF', 'ANONYMISE', 'SUPPRIME');
    END IF;
END
$$ LANGUAGE plpgsql;

-- 2. CRÉATION DE LA TABLE UTILISATEUR (Version Supabase)
CREATE TABLE IF NOT EXISTS utilisateur (
    -- On utilise l'ID de Supabase Auth comme Clé Primaire
    id uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    
    email VARCHAR(255) UNIQUE NOT NULL,
    pseudo VARCHAR(255) UNIQUE NOT NULL,
    -- Note : Le mot de passe est géré par auth.users, on ne le stocke pas ici par sécurité
    avatar_url VARCHAR(255),
    
    role role_utilisateur DEFAULT 'UTILISATEUR',
    etat_compte etat_compte DEFAULT 'ACTIF',
    
    est_compte_valide BOOLEAN DEFAULT FALSE, -- Snake_case recommandé en SQL
    impact_score_xp INT DEFAULT 0,
    co2_economise_total FLOAT DEFAULT 0,
    a_accepte_cgu BOOLEAN DEFAULT FALSE,
    communaute_nom VARCHAR(255),
    code_communaute VARCHAR(100),
    objectif FLOAT DEFAULT 0.1,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Foreign Key vers ta table communauté (qui doit exister)
    CONSTRAINT fk_communaute 
        FOREIGN KEY (communaute_nom) 
        REFERENCES communaute(nom) 
        ON DELETE SET NULL
);

