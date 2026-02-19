CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  v_entreprise_id UUID;
  v_domaine TEXT;
BEGIN
  -- Extraire le domaine de l'email (après le @)
  v_domaine := split_part(NEW.email, '@', 2);

  -- Récupérer l'entreprise_id correspondant au domaine
  SELECT id INTO v_entreprise_id
  FROM public.entreprise
  WHERE domaine_email = v_domaine
  LIMIT 1;

  -- Insérer le nouvel utilisateur avec l'entreprise_id
  INSERT INTO public.utilisateur (
    id, 
    email, 
    pseudo, 
    code_communaute, 
    entreprise_id,
    avatar_url,
    est_compte_valide,
    a_accepte_cgu
  )
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'pseudo',
    NEW.raw_user_meta_data->>'code_communaute',
    v_entreprise_id,
    'assets/avatars/avatar_1.png', 
    TRUE,
    TRUE 
  );
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Maj status bilan carbone
CREATE OR REPLACE FUNCTION sync_user_bilan_status()
RETURNS TRIGGER AS $$
BEGIN
  -- Si le bilan passe à complet = true
  IF (NEW.complet = true) THEN
    UPDATE public.utilisateur
    SET a_complete_bilan = true
    WHERE id = NEW.utilisateur_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Créer le trigger qui se déclenche à chaque mise à jour de bilan_carbone
CREATE TRIGGER on_bilan_completed
AFTER UPDATE ON public.bilan_carbone
FOR EACH ROW
EXECUTE FUNCTION sync_user_bilan_status();