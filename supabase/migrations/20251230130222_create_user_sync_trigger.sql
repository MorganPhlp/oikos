CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.utilisateur (
    id, 
    email, 
    pseudo, 
    code_communaute, 
    est_compte_valide, 
    a_accepte_cgu
  )
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'pseudo',
    NEW.raw_user_meta_data->>'code_communaute',
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