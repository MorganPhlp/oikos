DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'roleutilisateur') THEN
        CREATE TYPE role_utilisateur AS ENUM ('UTILISATEUR', 'ADMINISTRATEUR');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'etatcompte') THEN
        CREATE TYPE etat_compte AS ENUM ('ACTIF', 'ANONYMISE', 'SUPPRIME');
    END IF;
END
$$ LANGUAGE plpgsql;


-- 2. CRÉATION DE LA TABLE UTILISATEUR
-- Note: J'ai retiré les FOREIGN KEY et autres tables connexes, car 
-- elles doivent elles aussi être créées avant d'être référencées.
-- Assurez-vous que la table 'communaute' est créée avant celle-ci.

CREATE TABLE IF NOT EXISTS utilisateur (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    pseudo VARCHAR(255) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    avatar VARCHAR(255),
    
    -- Les types existent maintenant
    role role_utilisateur DEFAULT 'UTILISATEUR',
    etat_compte etat_compte DEFAULT 'ACTIF',
    
    estCompteValide BOOLEAN DEFAULT FALSE,
    impactScoreXP INT DEFAULT 0,
    co2EconomiseTotal FLOAT DEFAULT 0,
    aAccepteCGU BOOLEAN DEFAULT FALSE,
    communaute VARCHAR(255),
    
    -- Assurez-vous que 'communaute' existe avant d'utiliser cette FK
    FOREIGN KEY (communaute) REFERENCES communaute(nom) ON DELETE SET NULL
);