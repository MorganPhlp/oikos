CREATE OR REPLACE VIEW public.vue_bilan_questions_restantes AS
WITH dernier_bilan AS (
    SELECT DISTINCT ON (utilisateur_id)
    id AS bilan_id,
    utilisateur_id
    FROM bilan_carbone
    ORDER BY utilisateur_id, date_bilan DESC
),
stats_questions AS (
    SELECT db.utilisateur_id, (SELECT COUNT(*) FROM public.question_bilan) AS total_questions,
    COUNT(ru.id) AS questions_repondues
    FROM dernier_bilan db
    LEFT JOIN reponse_utilisateur ru ON ru.bilan_id = db.bilan_id
    GROUP BY db.utilisateur_id
)
SELECT utilisateur_id, total_questions - questions_repondues AS questions_restantes
FROM stats_questions;
