CREATE TABLE IF NOT EXISTS reponse_utilisateur (
    id SERIAL PRIMARY KEY,
    bilan_id INT NOT NULL,
    question_id INT NOT NULL,
    valeur VARCHAR(255),
    foreign KEY (bilan_id) REFERENCES bilan_carbone(id) ON DELETE CASCADE,
    foreign KEY (question_id) REFERENCES question_bilan(id) ON DELETE CASCADE,
    unique (bilan_id, question_id)
);