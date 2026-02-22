-- Vue agrégée pour les statistiques de la page d'accueil
CREATE OR REPLACE VIEW vue_home_stats AS
SELECT
    u.id AS utilisateur_id,

    -- Nombre total d'actions réalisées
    COALESCE(ra.nb_actions_realisees, 0) AS nb_actions_realisees,

    -- Total XP gagné via les actions
    COALESCE(ra.total_xp_gagne, 0) AS total_xp_gagne,

    -- Score XP de l'utilisateur
    COALESCE(u.impact_score_xp, 0) AS impact_score_xp,

    -- Nombre d'actions en cours
    COALESCE(aec.nb_actions_en_cours, 0) AS nb_actions_en_cours,

    -- Nombre d'habitudes
    COALESCE(hab.nb_habitudes, 0) AS nb_habitudes,

    -- Score total CO2 du dernier bilan
    bc.scoreTotalCO2eAn AS score_total_co2,

    -- Détails du dernier bilan par catégorie
    COALESCE(db.transport, 0) AS transport,
    COALESCE(db.alimentation, 0) AS alimentation,
    COALESCE(db.logement, 0) AS logement,
    COALESCE(db.divers, 0) AS divers,
    COALESCE(db.services_societaux, 0) AS services_societaux,

    -- Catégorie la plus émettrice
    CASE
        WHEN GREATEST(
            COALESCE(db.transport, 0),
            COALESCE(db.alimentation, 0),
            COALESCE(db.logement, 0),
            COALESCE(db.divers, 0),
            COALESCE(db.services_societaux, 0)
        ) = 0 THEN NULL
        WHEN GREATEST(
            COALESCE(db.transport, 0),
            COALESCE(db.alimentation, 0),
            COALESCE(db.logement, 0),
            COALESCE(db.divers, 0),
            COALESCE(db.services_societaux, 0)
        ) = COALESCE(db.transport, 0) THEN 'Transport'
        WHEN GREATEST(
            COALESCE(db.transport, 0),
            COALESCE(db.alimentation, 0),
            COALESCE(db.logement, 0),
            COALESCE(db.divers, 0),
            COALESCE(db.services_societaux, 0)
        ) = COALESCE(db.alimentation, 0) THEN 'Alimentation'
        WHEN GREATEST(
            COALESCE(db.transport, 0),
            COALESCE(db.alimentation, 0),
            COALESCE(db.logement, 0),
            COALESCE(db.divers, 0),
            COALESCE(db.services_societaux, 0)
        ) = COALESCE(db.logement, 0) THEN 'Logement'
        WHEN GREATEST(
            COALESCE(db.transport, 0),
            COALESCE(db.alimentation, 0),
            COALESCE(db.logement, 0),
            COALESCE(db.divers, 0),
            COALESCE(db.services_societaux, 0)
        ) = COALESCE(db.divers, 0) THEN 'Divers'
        ELSE 'Services sociétaux'
    END AS categorie_plus_emettrice,

    -- Valeur de la catégorie la plus émettrice
    GREATEST(
        COALESCE(db.transport, 0),
        COALESCE(db.alimentation, 0),
        COALESCE(db.logement, 0),
        COALESCE(db.divers, 0),
        COALESCE(db.services_societaux, 0)
    ) AS valeur_categorie_max

FROM utilisateur u

LEFT JOIN (
    SELECT
        utilisateur_id,
        COUNT(*) AS nb_actions_realisees,
        COALESCE(SUM(xp_gagne), 0) AS total_xp_gagne
    FROM realisation_actions
    GROUP BY utilisateur_id
) ra ON ra.utilisateur_id = u.id

LEFT JOIN (
    SELECT utilisateur_id, COUNT(*) AS nb_actions_en_cours
    FROM actions_en_cours
    WHERE est_actif = true
    GROUP BY utilisateur_id
) aec ON aec.utilisateur_id = u.id

LEFT JOIN (
    SELECT utilisateur_id, COUNT(*) AS nb_habitudes
    FROM utilisateur_habitudes
    GROUP BY utilisateur_id
) hab ON hab.utilisateur_id = u.id

LEFT JOIN LATERAL (
    SELECT id, scoreTotalCO2eAn
    FROM bilan_carbone
    WHERE utilisateur_id = u.id
    ORDER BY date_bilan DESC
    LIMIT 1
) bc ON TRUE

LEFT JOIN detail_bilan db ON db.id = bc.id;

-- Politique RLS pour la vue
ALTER VIEW vue_home_stats SET (security_invoker = on);
