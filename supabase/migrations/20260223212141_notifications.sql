CREATE TYPE notification_type AS ENUM (
    'vote_defi_collectif', 
    'nouveau_defi_collectif', 
    'streak_loss',
     'bilan',
     'nouvelle_action_communautaire',
     'defi_termine');
     

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    type notification_type NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamptz DEFAULT now(),
    
    data jsonb NOT NULL DEFAULT '{}'::jsonb 
);





CREATE OR REPLACE FUNCTION fn_notify_defi_events()
RETURNS TRIGGER AS $$
DECLARE
    v_user_id UUID;
    v_msg TEXT;
    v_type notification_type;
BEGIN
    -- 1. CAS : NOUVEAU DÉFI (VOTE_LANCEMENT)
    -- On prévient tous les membres des deux communautés qu'un vote est ouvert
    IF (TG_OP = 'INSERT' AND NEW.status = 'VOTE_LANCEMENT') THEN
        INSERT INTO public.notifications (user_id, type, data)
        SELECT 
            u.id, 
            'vote_defi_collectif'::notification_type,
            jsonb_build_object(
                'defi_id', NEW.id,
                'titre', COALESCE(NEW.titre_personnalise, 'Nouveau défi disponible'),
                'message', 'Un nouveau défi a été proposé ! Votez pour le lancer.'
            )
        FROM public.utilisateur u
        WHERE u.code_communaute IN (NEW.communaute_demandeur_code, NEW.communaute_cible_code)
          AND u.est_actif = TRUE;

    -- 2. CAS : PASSAGE EN ACTIF
    -- Le quorum est atteint, le défi commence réellement
    ELSIF (TG_OP = 'UPDATE' AND OLD.status = 'VOTE_LANCEMENT' AND NEW.status = 'ACTIF') THEN
        INSERT INTO public.notifications (user_id, type, data)
        SELECT 
            u.id, 
            'nouveau_defi_collectif'::notification_type,
            jsonb_build_object(
                'defi_id', NEW.id,
                'titre', 'Un nouveau défi à relever !',
                'message', 'Affronte ' || (SELECT c.nom FROM public.communaute c WHERE c.code = NEW.communaute_cible_code) || ' !'
            )
        FROM public.utilisateur u
        WHERE u.code_communaute IN (NEW.communaute_demandeur_code, NEW.communaute_cible_code)
          AND u.est_actif = TRUE;

    -- 3. CAS : DÉFI TERMINÉ
    -- On annonce la fin et le gagnant
    ELSIF (TG_OP = 'UPDATE' AND OLD.status = 'ACTIF' AND NEW.status = 'TERMINE') THEN
        INSERT INTO public.notifications (user_id, type, data)
        SELECT 
            u.id, 
            'defi_termine'::notification_type,
            jsonb_build_object(
                'defi_id', NEW.id,
                'titre', 'Défi terminé',
                'gagnant_code', NEW.communaute_gagnante_code,
                'message', CASE 
                    WHEN u.code_communaute = NEW.communaute_gagnante_code THEN 'Félicitations ! Votre communauté a remporté le défi.'
                    WHEN NEW.communaute_gagnante_code IS NULL THEN 'Le défi est terminé sans vainqueur.'
                    ELSE 'Le défi est terminé. La communauté adverse a été plus rapide !'
                END
            )
        FROM public.utilisateur u
        WHERE u.code_communaute IN (NEW.communaute_demandeur_code, NEW.communaute_cible_code)
          AND u.est_actif = TRUE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_defi_notifications
AFTER INSERT OR UPDATE ON public.defi
FOR EACH ROW EXECUTE FUNCTION fn_notify_defi_events();