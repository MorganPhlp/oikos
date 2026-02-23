-- Catalogue des défis créés par les admins
CREATE TABLE  IF NOT EXISTS defis (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entreprise_id UUID REFERENCES entreprise(id),
    categorie_nom TEXT,
    titre TEXT NOT NULL,
    description TEXT,
    difficulte TEXT,
    gain_co2 FLOAT,
    xp_gain INT,
    icon_name TEXT,
    frequence TEXT,
    tips TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Suivi des défis lancés (Duels ou Globaux)
CREATE TABLE IF NOT EXISTS defis_communautes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    defi_id UUID REFERENCES defis(id),
    entreprise_id UUID REFERENCES entreprise(id),
    
    -- Pour un duel : codes des deux communautés
    communaute_demandeur_code TEXT, 
    communaute_cible_code TEXT,
    
    -- Pour un défi admin global
    is_global BOOLEAN DEFAULT FALSE,
    
    date_expiration TIMESTAMP WITH TIME ZONE NOT NULL,
    statut TEXT DEFAULT 'EN_ATTENTE', -- 'VOTE_LANCEMENT', 'EN_ATTENTE_CIBLE', 'ACTIF', 'TERMINE'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table pour gérer les votes de lancement (le seuil des 60%)
CREATE TABLE IF NOT EXISTS votes_lancement_defi (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    defi_communaute_id UUID REFERENCES defis_communautes(id),
    user_id UUID REFERENCES utilisateur(id),
    code_communaute TEXT,
    UNIQUE(defi_communaute_id, user_id)
);

CREATE OR REPLACE FUNCTION check_defi_launch_threshold(
  defi_id_param UUID,
  community_code_param TEXT
) RETURNS VOID AS $$
DECLARE
  active_members_count INT;
  votes_count INT;
BEGIN
  -- 1. Compter les membres 'ACTIF'
  SELECT count(*) INTO active_members_count 
  FROM utilisateur 
  WHERE code_communaute = community_code_param AND etat_compte = 'ACTIF';

  -- 2. Compter les votes pour ce défi
  SELECT count(*) INTO votes_count 
  FROM votes_lancement_defi 
  WHERE defi_communaute_id = defi_id_param AND code_communaute = community_code_param;

  -- 3. Si 60% atteint, passer le statut à 'EN_ATTENTE_CIBLE'
  IF active_members_count > 0 AND (votes_count::float / active_members_count::float) >= 0.6 THEN
    UPDATE defis_communautes 
    SET statut = 'EN_ATTENTE_CIBLE' 
    WHERE id = defi_id_param;
  END IF;
END;
$$ LANGUAGE plpgsql;

create table IF NOT EXISTS validations_defis (
  id uuid id default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  defi_id uuid references public.defis(id) on delete cascade,
  user_id uuid references auth.users(id),
  code_communaute text not null,
  xp_gain int not null
);
