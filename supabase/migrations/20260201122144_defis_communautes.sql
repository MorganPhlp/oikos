CREATE TYPE defi_statut AS ENUM ('VOTE_LANCEMENT', 'ACTIF', 'TERMINE');
-- Table principale des défis
CREATE TABLE IF NOT EXISTS defi (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titre_personnalise TEXT,
    createur_id UUID REFERENCES utilisateur(id) ON DELETE SET NULL,
    communaute_demandeur_code TEXT REFERENCES communaute(code) ON DELETE SET NULL,
    communaute_cible_code TEXT REFERENCES communaute(code) ON DELETE SET NULL,
    categorie_nom TEXT NOT NULL REFERENCES categorie_empreinte(nom) ON DELETE SET NULL,
    action_id UUID REFERENCES actions(id) ON DELETE SET NULL,
    status defi_statut DEFAULT 'VOTE_LANCEMENT',
    communaute_gagnante_code TEXT REFERENCES communaute(code) ON DELETE SET NULL,
    is_global BOOLEAN DEFAULT FALSE,
    date_fin TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des votes de lancement (avec choix Oui/Non)
CREATE TABLE IF NOT EXISTS votes_lancement_defi (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    defi_id UUID REFERENCES defi(id) ON DELETE CASCADE,
    user_id UUID REFERENCES utilisateur(id) ON DELETE CASCADE,
    est_favorable BOOLEAN NOT NULL DEFAULT TRUE, -- TRUE = OUI, FALSE = NON
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(defi_id, user_id)
);

-- Table de participation effective (une fois le défi ACTIF)
CREATE TABLE IF NOT EXISTS defi_participation (
    defi_id UUID REFERENCES defi(id) ON DELETE CASCADE,
    user_id UUID REFERENCES utilisateur(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (defi_id, user_id)
);

-- ==========================================================
-- 3. VUE POUR L'APPLICATION
-- ==========================================================

CREATE OR REPLACE VIEW vue_defis_complet AS
WITH stats_membres AS (
  -- On compte les membres actifs pour chaque communauté
  SELECT 
    code_communaute,
    COUNT(*) AS total_membres
  FROM utilisateur
  WHERE est_actif = TRUE 
    AND role != 'ADMINISTRATEUR' 
    AND etat_compte != 'ANONYMISE'
  GROUP BY code_communaute
),
stats_votes AS (
  SELECT 
    v.defi_id,
    COUNT(*) FILTER (WHERE u.code_communaute = d.communaute_demandeur_code AND v.est_favorable = TRUE) AS votes_oui_commu1,
    COUNT(*) FILTER (WHERE u.code_communaute = d.communaute_demandeur_code AND v.est_favorable = FALSE) AS votes_non_commu1,
    COUNT(*) FILTER (WHERE u.code_communaute = d.communaute_cible_code AND v.est_favorable = TRUE) AS votes_oui_commu2,
    COUNT(*) FILTER (WHERE u.code_communaute = d.communaute_cible_code AND v.est_favorable = FALSE) AS votes_non_commu2
  FROM votes_lancement_defi v
  JOIN utilisateur u ON v.user_id = u.id
  JOIN defi d ON v.defi_id = d.id
  GROUP BY v.defi_id
),
stats_participation AS (
  SELECT 
    dp.defi_id, 
    COUNT(u.id) FILTER (WHERE u.code_communaute = d.communaute_demandeur_code) AS participants_commu1,
    COUNT(u.id) FILTER (WHERE u.code_communaute = d.communaute_cible_code) AS participants_commu2
  FROM defi_participation dp
  JOIN utilisateur u ON dp.user_id = u.id
  JOIN defi d ON dp.defi_id = d.id
  WHERE u.etat_compte != 'ANONYMISE'
  GROUP BY dp.defi_id
)
SELECT 
  d.id AS defi_id,
  d.titre_personnalise,
  d.status,
  d.categorie_nom,
  d.communaute_demandeur_code,
  d.communaute_cible_code,
  d.date_fin,
  d.created_at,
  d.is_global,
  d.communaute_gagnante_code,
  d.communaute_gagnante_code as gagnant_code,
  (SELECT nom FROM communaute WHERE code = d.communaute_gagnante_code) AS gagnant_nom,
  a.id AS action_id,
  a.titre AS action_titre,
  a.description AS action_description,
  a.impact_score AS action_impact_score,
  a.icon_name AS action_icon_name,
  c1.nom AS nom_commu1,
  c2.nom AS nom_commu2,
  c1.logo_url AS logo_commu1,
  c2.logo_url AS logo_commu2,
  -- Nouveaux champs : Nombre total de membres
  COALESCE(sm1.total_membres, 0) AS membres_total_commu1,
  COALESCE(sm2.total_membres, 0) AS membres_total_commu2,
  -- Statistiques de Vote
  COALESCE(sv.votes_oui_commu1, 0) AS votes_oui_commu1,
  COALESCE(sv.votes_non_commu1, 0) AS votes_non_commu1,
  COALESCE(sv.votes_oui_commu2, 0) AS votes_oui_commu2,
  COALESCE(sv.votes_non_commu2, 0) AS votes_non_commu2,
  -- Statistiques de Participation
  COALESCE(sp.participants_commu1, 0) AS participants_commu1,
  COALESCE(sp.participants_commu2, 0) AS participants_commu2
FROM defi d
LEFT JOIN actions a ON d.action_id = a.id
LEFT JOIN stats_votes sv ON d.id = sv.defi_id
LEFT JOIN stats_participation sp ON d.id = sp.defi_id
LEFT JOIN communaute c1 ON d.communaute_demandeur_code = c1.code
LEFT JOIN communaute c2 ON d.communaute_cible_code = c2.code
-- Jointures pour récupérer les totaux de membres
LEFT JOIN stats_membres sm1 ON d.communaute_demandeur_code = sm1.code_communaute
LEFT JOIN stats_membres sm2 ON d.communaute_cible_code = sm2.code_communaute;

-- ==========================================================
-- 4. LOGIQUE D'ACTIVATION (TRIGGER SUR VOTE)
-- ==========================================================



CREATE OR REPLACE FUNCTION fn_check_and_activate_defi()
RETURNS TRIGGER AS $$
DECLARE
    v_rec RECORD;
    v_total_demandeur INT;
    v_total_cible INT;
    v_votes_positifs_demandeur INT;
    v_votes_positifs_cible INT;
    v_random_action_id UUID;
BEGIN
    -- 1. Infos du défi
    SELECT communaute_demandeur_code, communaute_cible_code, categorie_nom, status
    INTO v_rec FROM defi WHERE id = NEW.defi_id;

    IF v_rec.status != 'VOTE_LANCEMENT' THEN RETURN NEW; END IF;

    -- 2. Calcul du quorum (membres actifs)
    SELECT COUNT(*) INTO v_total_demandeur FROM utilisateur 
    WHERE code_communaute = v_rec.communaute_demandeur_code AND est_actif = TRUE AND role != 'ADMINISTRATEUR';
    
    SELECT COUNT(*) INTO v_total_cible FROM utilisateur 
    WHERE code_communaute = v_rec.communaute_cible_code AND est_actif = TRUE AND role != 'ADMINISTRATEUR';

    -- 3. Compte des votes favorables uniquement
    SELECT COUNT(*) INTO v_votes_positifs_demandeur FROM votes_lancement_defi v
    JOIN utilisateur u ON v.user_id = u.id
    WHERE v.defi_id = NEW.defi_id AND u.code_communaute = v_rec.communaute_demandeur_code AND v.est_favorable = TRUE;

    SELECT COUNT(*) INTO v_votes_positifs_cible FROM votes_lancement_defi v
    JOIN utilisateur u ON v.user_id = u.id
    WHERE v.defi_id = NEW.defi_id AND u.code_communaute = v_rec.communaute_cible_code AND v.est_favorable = TRUE;

    -- 4. Activation si 60% de OUI dans chaque communauté
    IF (v_votes_positifs_demandeur::float / NULLIF(v_total_demandeur, 0)::float >= 0.6) AND 
       (v_votes_positifs_cible::float / NULLIF(v_total_cible, 0)::float >= 0.6) THEN
       
        -- Sélection d'une action aléatoire dans la catégorie choisie
        SELECT id INTO v_random_action_id FROM actions 
        WHERE categorie_nom = v_rec.categorie_nom
        ORDER BY RANDOM() LIMIT 1;

        UPDATE defi SET status = 'ACTIF', action_id = v_random_action_id WHERE id = NEW.defi_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_after_new_vote
AFTER INSERT OR UPDATE ON votes_lancement_defi
FOR EACH ROW EXECUTE FUNCTION fn_check_and_activate_defi();

-- ==========================================================
-- 5. LOGIQUE DE RÉCOMPENSE (TRIGGER SUR PARTICIPATION)
-- ==========================================================

CREATE OR REPLACE FUNCTION fn_check_completion_and_reward()
RETURNS TRIGGER AS $$
DECLARE
    v_rec RECORD;
    v_total_demandeur INT; v_total_cible INT;
    v_part_demandeur INT; v_part_cible INT;
    v_xp_gain INT; 
BEGIN
    -- 1. Récupération des données
    SELECT d.communaute_demandeur_code, d.communaute_cible_code, d.status, d.date_fin, a.impact_score
    INTO v_rec FROM defi d LEFT JOIN actions a ON d.action_id = a.id WHERE d.id = NEW.defi_id;

    -- Vérification expiration
    IF v_rec.date_fin < NOW() THEN
        UPDATE defi SET status = 'TERMINE' WHERE id = NEW.defi_id;
        RETURN NEW;
    END IF;

    IF v_rec.status != 'ACTIF' THEN RETURN NEW; END IF;
    v_xp_gain := COALESCE(v_rec.impact_score, 0);

    -- 2. Totaux actifs
    SELECT COUNT(*) INTO v_total_demandeur FROM utilisateur WHERE code_communaute = v_rec.communaute_demandeur_code AND est_actif = TRUE AND role != 'ADMINISTRATEUR' AND etat_compte != 'ANONYMISE';
    SELECT COUNT(*) INTO v_total_cible FROM utilisateur WHERE code_communaute = v_rec.communaute_cible_code AND est_actif = TRUE AND role != 'ADMINISTRATEUR' AND etat_compte != 'ANONYMISE';

    -- 3. Participations
    SELECT COUNT(*) INTO v_part_demandeur FROM defi_participation dp JOIN utilisateur u ON dp.user_id = u.id
    WHERE dp.defi_id = NEW.defi_id AND u.code_communaute = v_rec.communaute_demandeur_code AND u.etat_compte != 'ANONYMISE';

    SELECT COUNT(*) INTO v_part_cible FROM defi_participation dp JOIN utilisateur u ON dp.user_id = u.id
    WHERE dp.defi_id = NEW.defi_id AND u.code_communaute = v_rec.communaute_cible_code;

    -- 4. Détermination du gagnant (Premier à 60%)
    IF v_total_demandeur > 0 AND (v_part_demandeur::float / v_total_demandeur::float) >= 0.6 THEN
        UPDATE defi SET status = 'TERMINE', communaute_gagnante_code = v_rec.communaute_demandeur_code WHERE id = NEW.defi_id;
        UPDATE communaute SET plant_xp = plant_xp + v_xp_gain WHERE code = v_rec.communaute_demandeur_code;
    
    ELSIF v_total_cible > 0 AND (v_part_cible::float / v_total_cible::float) >= 0.6 THEN
        UPDATE defi SET status = 'TERMINE', communaute_gagnante_code = v_rec.communaute_cible_code WHERE id = NEW.defi_id;
        UPDATE communaute SET plant_xp = plant_xp + v_xp_gain WHERE code = v_rec.communaute_cible_code;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_after_new_participation
AFTER INSERT ON defi_participation
FOR EACH ROW EXECUTE FUNCTION fn_check_completion_and_reward();


CREATE OR REPLACE VIEW public.vue_communaute_stats AS
SELECT 
    c.*,
    COALESCE(count(u.id), 0) AS nb_membres
FROM 
    public.communaute c
LEFT JOIN 
    public.utilisateur u ON u.code_communaute = c.code
GROUP BY 
    c.code;

CREATE OR REPLACE VIEW vue_votes_defis AS
SELECT 
    defi_id,
    user_id, 
    true AS has_voted,
    est_favorable 
FROM votes_lancement_defi;

CREATE OR REPLACE VIEW vue_participations_defis AS
SELECT 
    defi_id,
    user_id,
    true AS has_participated
FROM defi_participation; 