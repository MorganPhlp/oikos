CREATE TABLE IF NOT EXISTS bilan_carbone (
    id SERIAL PRIMARY KEY,
    utilisateur_id UUID NOT NULL,
    date_bilan TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    scoreTotalCO2eAn FLOAT NOT NULL,
    CONSTRAINT fk_utilisateur 
        FOREIGN KEY (utilisateur_id) 
        REFERENCES public.utilisateur(id) 
        ON DELETE CASCADE
);