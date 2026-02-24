-- Ajout des colonnes gamification à la table utilisateur
alter table utilisateur 
add column if not exists impact_stats text default '-0kg',
add column if not exists actions_count int default 0,
add column if not exists streak_days int default 0;

-- Création de la vue classement
create or replace view vue_user_ranking as
select 
  u.id as user_id,
  u.pseudo as username,
  u.impact_score_xp as total_xp,
  u.code_communaute,
  u.impact_stats,
  u.actions_count,
  u.streak_days,
  u.avatar_url,
  rank() over (partition by u.code_communaute order by u.impact_score_xp desc) as rank
from utilisateur u
where u.est_actif = true
  and u.role != 'ADMINISTRATEUR'
  and u.etat_compte != 'ANONYMISE';

-- Création de la vue classement de communauté
CREATE OR REPLACE VIEW public.vue_community_ranking AS
SELECT 
    c.entreprise_id,
    c.code AS community_code,
    c.nom AS community_name,
    COALESCE((SELECT SUM(impact_score_xp) FROM public.utilisateur u WHERE u.code_communaute = c.code AND u.est_actif = true AND u.role != 'ADMINISTRATEUR' AND u.etat_compte != 'ANONYMISE'), 0)
    + COALESCE(c.plant_xp, 0) AS total_xp,
    
    c.logo_url,
    (SELECT COUNT(*) FROM public.utilisateur u WHERE u.code_communaute = c.code AND u.est_actif = true AND u.role != 'ADMINISTRATEUR' AND u.etat_compte != 'ANONYMISE') AS members_count,
    (SELECT COALESCE(SUM(actions_count), 0) FROM public.utilisateur u WHERE u.code_communaute = c.code AND u.est_actif = true AND u.role != 'ADMINISTRATEUR' AND u.etat_compte != 'ANONYMISE') AS total_actions
FROM
    public.communaute c;
