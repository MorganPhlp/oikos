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
    
    est_compte_valide BOOLEAN DEFAULT TRUE,
    a_accepte_cgu BOOLEAN DEFAULT TRUE,
    impact_score_xp INT DEFAULT 0,
    co2_economise_total FLOAT DEFAULT 0,
    entreprise_id UUID,
    code_communaute TEXT,
    objectif FLOAT DEFAULT 0.1,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Foreign Keys
    CONSTRAINT fk_communaute 
        FOREIGN KEY (code_communaute)
        REFERENCES communaute(code)
        ON DELETE SET NULL,

    CONSTRAINT fk_entreprise
        FOREIGN KEY (entreprise_id)
        REFERENCES entreprise(id)
        ON DELETE SET NULL
);

