-- Table des actions communautaires
CREATE TABLE IF NOT EXISTS action_communautaire (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entreprise_id text NOT NULL,
  action_id uuid NOT NULL,
  titre_personnalise text,
  date_debut timestamptz DEFAULT now(),
  date_fin timestamptz NOT NULL,
  createur_id uuid REFERENCES utilisateur(id)
);

-- Table des participations aux actions communautaires
CREATE TABLE IF NOT EXISTS action_communautaire_participation (
  action_id uuid REFERENCES action_communautaire(id) ON DELETE CASCADE,
  user_id uuid REFERENCES utilisateur(id) ON DELETE CASCADE,
  code_communaute text NOT NULL,
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (action_id, user_id)
);

-- Vue des actions actives
CREATE OR REPLACE VIEW vue_actions_communautaires_actives AS
SELECT 
  dc.id AS action_id,
  a.id AS base_action_id,
  dc.entreprise_id,
  COALESCE(dc.titre_personnalise, a.titre) AS titre,
  a.description,
  a.icon_name,
  a.impact_score,
  dc.date_fin,
  (SELECT count(*) FROM action_communautaire_participation dp WHERE dp.action_id = dc.id) AS participants_count
FROM action_communautaire dc
JOIN actions a ON dc.action_id::text = a.id::text
WHERE dc.date_fin > now();

-- Fonction d'ajout d'XP à l'utilisateur uuid
CREATE OR REPLACE FUNCTION add_xp_to_user(user_id_param uuid, xp_amount int)
RETURNS void AS $$
BEGIN
  UPDATE utilisateur
  SET impact_score_xp = COALESCE(impact_score_xp, 0) + xp_amount
  WHERE id = user_id_param;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.water_plant(
    community_code_arg TEXT, 
    xp_amount INT
)
RETURNS VOID AS $$
BEGIN
    UPDATE public.communaute
    SET plant_xp = COALESCE(plant_xp, 0) + xp_amount
    WHERE code = community_code_arg; 
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour vérifier le seuil et ajouter des XP à la plante communautaire
CREATE OR REPLACE FUNCTION check_and_reward_community_action(
  instance_id_param UUID,
  community_code_param TEXT,
  xp_reward INT
) RETURNS VOID AS $$
DECLARE
  active_members_count INT;
  participants_count INT;
BEGIN
  SELECT count(*) INTO active_members_count 
  FROM utilisateur 
  WHERE code_communaute = community_code_param 
    AND etat_compte = 'ACTIF' 
    AND (est_actif = true);

  SELECT count(*) INTO participants_count 
  FROM action_communautaire_participation 
  WHERE action_id = instance_id_param;

  IF active_members_count > 0 AND (participants_count::float / active_members_count::float) >= 0.6 THEN
    PERFORM water_plant(community_code_param, xp_reward);
  END IF;
END;
$$ LANGUAGE plpgsql;

