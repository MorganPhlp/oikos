CREATE OR REPLACE VIEW vue_situation_publicodes AS
SELECT 
    b.utilisateur_id,
    b.id AS bilan_id,
    q.slug AS question_slug,
    q.type_widget AS type_widget,
    r.valeur AS reponse_valeur -- La virgule a été supprimée ici
FROM 
    reponse_utilisateur r
JOIN 
    question_bilan q ON r.question_id = q.id
JOIN 
    bilan_carbone b ON r.bilan_id = b.id;