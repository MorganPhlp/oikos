-- 1. Table des défis lancés
CREATE TABLE IF NOT EXISTS action_communautaire (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entreprise_id text NOT NULL,                -- Pour limiter le défi à la même entreprise
  action_id uuid NOT NULL,                    -- L'ID de l'action choisie
  titre_personnalise text,                    -- Optionnel : si on veut renommer le défi
  date_debut timestamptz DEFAULT now(),
  date_fin timestamptz NOT NULL,              -- Date de fin (ex: +7 jours)
  createur_id uuid REFERENCES utilisateur(id) -- Celui qui a lancé le défi (null si admin)
);

-- 2. Table des participations
CREATE TABLE IF NOT EXISTS action_communautaire_participation (
  action_id uuid REFERENCES action_communautaire(id) ON DELETE CASCADE,
  user_id uuid REFERENCES utilisateur(id) ON DELETE CASCADE,
  code_communaute text NOT NULL,              -- Pour calculer vite les scores des commus
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (defi_id, user_id)              -- Un user ne rejoint qu'une fois un défi
);

CREATE OR REPLACE VIEW vue_actions_communautaires_actives AS
SELECT 
  dc.id AS action_id,           -- ID de l'instance
  a.id AS base_action_id,       -- ID du catalogue
  dc.entreprise_id,
  COALESCE(dc.titre_personnalise, a.titre) AS titre,
  a.description,
  a.icon_name,
  a.xp_gain,
  dc.date_fin,
  (SELECT count(*) FROM action_communautaire_participation dp WHERE dp.action_id = dc.id) AS participants_count
FROM action_communautaire dc
JOIN actions a ON dc.action_id::text = a.id::text
WHERE dc.date_fin > now();

CREATE OR REPLACE FUNCTION add_xp_to_user(user_id_param uuid, xp_amount int)
RETURNS void AS $$
BEGIN
  -- On met à jour l'utilisateur en ajoutant les points à son total existant
  UPDATE utilisateur
  SET impact_score_xp = COALESCE(impact_score_xp, 0) + xp_amount
  WHERE id = user_id_param;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour vérifier le seuil et récompenser la plante communautaire
CREATE OR REPLACE FUNCTION check_and_reward_community_action(
  instance_id_param UUID,
  community_code_param TEXT,
  xp_reward INT
) RETURNS VOID AS $$
DECLARE
  active_members_count INT;
  participants_count INT;
BEGIN
  -- 1. Compter les membres actifs (non anonymes, non en pause)
  SELECT count(*) INTO active_members_count 
  FROM utilisateur 
  WHERE code_communaute = community_code_param 
    AND etat_compte = 'ACTIF' 
    AND (est_actif = true);

  -- 2. Compter les participants uniques pour cette instance d'action
  SELECT count(*) INTO participants_count 
  FROM action_communautaire_participation 
  WHERE action_id = instance_id_param;

  -- 3. Si le seuil de 60% est atteint, on arrose la plante
  IF active_members_count > 0 AND (participants_count::float / active_members_count::float) >= 0.6 THEN
    PERFORM water_plant(community_code_param, xp_reward);
  END IF;
END;
$$ LANGUAGE plpgsql;