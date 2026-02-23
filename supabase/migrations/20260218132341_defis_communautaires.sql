-- Table des défis lancés
CREATE TABLE IF NOT EXISTS defi_communautaire (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entreprise_id text NOT NULL,
  action_id uuid NOT NULL,
  titre_personnalise text,
  date_debut timestamptz DEFAULT now(),
  date_fin timestamptz NOT NULL,
  createur_id uuid REFERENCES utilisateur(id)
);

-- Table des participations
CREATE TABLE IF NOT EXISTS defi_participation (
  defi_id uuid REFERENCES defi_communautaire(id) ON DELETE CASCADE,
  user_id uuid REFERENCES utilisateur(id) ON DELETE CASCADE,
  code_communaute text NOT NULL,
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (defi_id, user_id)
);

-- Vue des défis actifs
CREATE OR REPLACE VIEW vue_defis_actifs AS
SELECT 
  dc.id AS defi_id,
  dc.entreprise_id,
  COALESCE(dc.titre_personnalise, a.titre) AS titre,
  a.description,
  a.icon_name,
  a.impact_score,
  dc.date_fin,
  (SELECT count(*) FROM defi_participation dp WHERE dp.defi_id = dc.id) AS participants_count
FROM defi_communautaire dc
JOIN actions a ON dc.action_id::text = a.id::text
WHERE dc.date_fin > now();

-- Fonction d'ajout d'XP à un utilisateur
CREATE OR REPLACE FUNCTION add_xp_to_user(user_id_param uuid, xp_amount int)
RETURNS void AS $$
BEGIN
  UPDATE utilisateur
  SET impact_score_xp = COALESCE(impact_score_xp, 0) + xp_amount
  WHERE id = user_id_param;
END;
$$ LANGUAGE plpgsql;