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
  rank() over (partition by u.code_communaute order by u.impact_score_xp desc) as rank
from utilisateur u;

-- Création de la vue classement de communauté
create or replace view vue_community_ranking as
select 
  c.code as community_code,
  c.nom as community_name,
  coalesce(sum(u.impact_score_xp), 0) as total_xp,
  c.entreprise_id,
  count(u.id) as members_count,
  coalesce(sum(u.actions_count), 0) as total_actions
from communaute c
left join utilisateur u on c.code = u.code_communaute
group by c.code;