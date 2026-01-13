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
    est_compte_valide,
    a_accepte_cgu
  )
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'pseudo',
    NEW.raw_user_meta_data->>'code_communaute',
    v_entreprise_id,
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