CREATE TABLE IF NOT EXISTS utilisateur_categorie_preference (
    utilisateur_id INT REFERENCES utilisateur(id) ON DELETE CASCADE NOT NULL,
    categorie_nom TEXT REFERENCES categorie_empreinte(nom) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    
    -- Clé primaire composée : un utilisateur ne peut pas liker deux fois la même catégorie
    PRIMARY KEY (utilisateur_id, categorie_nom)
);
