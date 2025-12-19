CREATE TABLE IF NOT EXISTS public.utilisateur_categorie_preference (
    utilisateur_id UUID REFERENCES public.utilisateur(id) ON DELETE CASCADE,
    categorie_nom TEXT REFERENCES public.categorie_empreinte(nom) ON DELETE CASCADE,
    PRIMARY KEY (utilisateur_id, categorie_nom) 
);