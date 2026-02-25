CREATE OR REPLACE VIEW public.vue_communaute AS
SELECT 
    c.*,
    COALESCE(stats.nombre_membres, 0) AS nombre_membres,
    COALESCE(stats.bilan_moyen, 0) AS bilan_moyen
FROM public.communaute c
LEFT JOIN (
    SELECT 
        u.code_communaute,
        COUNT(DISTINCT u.id) AS nombre_membres,
        AVG(b.scoretotalco2ean) FILTER (WHERE b.complet = true) AS bilan_moyen
    FROM public.utilisateur u
    LEFT JOIN public.bilan_carbone b ON u.id = b.utilisateur_id
    GROUP BY u.code_communaute
) stats ON c.code = stats.code_communaute;


CREATE OR REPLACE FUNCTION generate_mock_users(qty INTEGER)
RETURNS VOID AS $$
DECLARE
    v_entreprise_id UUID;
    v_communaute_codes TEXT[];
    v_user_id UUID;
    v_pseudo TEXT;
    v_email TEXT;
    v_selected_commu TEXT;
    v_i INTEGER;
BEGIN
    -- 1. Récupérer l'entreprise et les communautés Mok
    SELECT id INTO v_entreprise_id FROM public.entreprise WHERE nom = 'Viveris' LIMIT 1;
    SELECT array_agg(code) INTO v_communaute_codes FROM public.communaute WHERE nom LIKE 'Mok%';

    IF v_communaute_codes IS NULL THEN
        RAISE EXCEPTION 'Aucune communauté Mok trouvée. Lancez generate_mock_communities d''abord.';
    END IF;

    FOR v_i IN 1..qty LOOP
        v_user_id := gen_random_uuid();
        v_pseudo := 'Mok' || floor(random() * 10000)::text;
        v_email := v_pseudo || '@mock.com';
        v_selected_commu := v_communaute_codes[floor(random() * array_length(v_communaute_codes, 1) + 1)];

        -- A. INSERTION DANS AUTH.USERS
        -- On passe le pseudo et le code_communaute dans raw_user_meta_data pour satisfaire ton trigger
        INSERT INTO auth.users (
            id, instance_id, email, aud, role, 
            raw_app_meta_data, 
            raw_user_meta_data, 
            is_super_admin, created_at, updated_at, last_sign_in_at, email_confirmed_at
        )
        VALUES (
            v_user_id, 
            '00000000-0000-0000-0000-000000000000', 
            v_email, 
            'authenticated', 
            'authenticated', 
            '{"provider":"email","providers":["email"]}', 
            jsonb_build_object('pseudo', v_pseudo, 'code_communaute', v_selected_commu), 
            false, 
            now(), now(), now(), now()
        );

        -- B. MISE À JOUR DU PROFIL (Optionnel mais recommandé)
        -- Ton trigger a déjà créé la ligne, mais on met à jour l'XP et l'entreprise si le trigger ne le fait pas
        UPDATE public.utilisateur SET
            impact_score_xp = floor(random() * (10000 - 6000 + 1) + 6000)::int,
            entreprise_id = v_entreprise_id,
            a_complete_bilan = true,
            updated_at = now()
        WHERE id = v_user_id;

        -- C. INSERTION BILAN CARBONE
        INSERT INTO public.bilan_carbone (
            utilisateur_id, 
            scoretotalco2ean, 
            complet, 
            date_bilan
        ) VALUES (
            v_user_id,
            random() * (12000 - 800) + 800,
            true,
            now() - (random() * interval '90 days')
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION clear_mock_users()
RETURNS VOID AS $$
BEGIN
    -- 1. Supprimer les bilans
    DELETE FROM public.bilan_carbone 
    WHERE utilisateur_id IN (SELECT id FROM public.utilisateur WHERE pseudo LIKE 'Mok%');
    
    -- 2. Stocker les IDs à supprimer
    -- Note: La suppression dans auth.users peut supprimer par cascade dans public.utilisateur 
    -- selon ton trigger, mais on le fait proprement :
    DELETE FROM public.utilisateur WHERE pseudo LIKE 'Mok%';
    
    -- 3. Supprimer de auth.users (les emails finissant par @mock.com)
    DELETE FROM auth.users WHERE email LIKE '%@mock.com';
END;
$$ LANGUAGE plpgsql;

-- GÉNÉRATION DES COMMUNAUTÉS
CREATE OR REPLACE FUNCTION generate_mock_communities(qty INTEGER)
RETURNS VOID AS $$
DECLARE
    v_entreprise_id UUID;
    v_i INTEGER;
    v_code TEXT;
BEGIN
    -- Récupérer l'ID de Viveris
    SELECT id INTO v_entreprise_id FROM public.entreprise WHERE nom = 'Viveris' LIMIT 1;
    IF v_entreprise_id IS NULL THEN
        RAISE EXCEPTION 'Entreprise Viveris non trouvée. Veuillez la créer d''abord.';
    END IF;

    FOR v_i IN 1..qty LOOP
        -- Génération d'un code unique de 6 caractères (A-Z, 0-9)
        v_code := upper(substring(md5(random()::text) from 1 for 6));
        
        INSERT INTO public.communaute (code, nom, entreprise_id, couleurhex, description,plant_xp)
        VALUES (
            v_code, 
            'Mok' || floor(random() * 1000)::text, 
            v_entreprise_id, 
            '#4CAF50', 
            'Communauté de test générée automatiquement',
            floor(random() * (10000 - 6000 + 1) + 6000)::int
        ) ON CONFLICT (code) DO NOTHING;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- NETTOYAGE DES COMMUNAUTÉS
CREATE OR REPLACE FUNCTION clear_mock_communities()
RETURNS VOID AS $$
BEGIN
    DELETE FROM public.communaute WHERE nom LIKE 'Mok%';
END;
$$ LANGUAGE plpgsql;


SELECT generate_mock_communities(5); -- Crée 5 communautés
SELECT generate_mock_users(50);      -- Crée 50 utilisateurs répartis dedans
-- select clear_mock_users();
-- select clear_mock_communities();