-- 1. Table des défis lancés
CREATE TABLE IF NOT EXISTS defi_communautaire (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entreprise_id text NOT NULL,                -- Pour limiter le défi à la même entreprise
  action_id uuid NOT NULL,                    -- L'ID de l'action choisie
  titre_personnalise text,                    -- Optionnel : si on veut renommer le défi
  date_debut timestamptz DEFAULT now(),
  date_fin timestamptz NOT NULL,              -- Date de fin (ex: +7 jours)
  createur_id uuid REFERENCES utilisateur(id) -- Celui qui a lancé le défi (null si admin)
);

-- 2. Table des participations
CREATE TABLE IF NOT EXISTS defi_participation (
  defi_id uuid REFERENCES defi_communautaire(id) ON DELETE CASCADE,
  user_id uuid REFERENCES utilisateur(id) ON DELETE CASCADE,
  code_communaute text NOT NULL,              -- Pour calculer vite les scores des commus
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (defi_id, user_id)              -- Un user ne rejoint qu'une fois un défi
);

CREATE OR REPLACE VIEW vue_defis_actifs AS
SELECT 
  dc.id AS defi_id,
  dc.entreprise_id,
  COALESCE(dc.titre_personnalise, a.titre) AS titre,
  a.description,
  a.icon_name,
  a.xp_gain,
  dc.date_fin,
  -- On compte combien de personnes participent à ce défi
  (SELECT count(*) FROM defi_participation dp WHERE dp.defi_id = dc.id) AS participants_count
FROM defi_communautaire dc
-- On fait le lien avec ta table "actions"
JOIN actions a ON dc.action_id::text = a.id::text
WHERE dc.date_fin > now(); -- On ne garde que les défis qui ne sont pas terminés

CREATE OR REPLACE FUNCTION add_xp_to_user(user_id_param uuid, xp_amount int)
RETURNS void AS $$
BEGIN
  -- On met à jour l'utilisateur en ajoutant les points à son total existant
  UPDATE utilisateur
  SET impact_score_xp = COALESCE(impact_score_xp, 0) + xp_amount
  WHERE id = user_id_param;
END;
$$ LANGUAGE plpgsql;