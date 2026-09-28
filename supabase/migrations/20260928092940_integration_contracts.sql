-- Contracts shared by mobile and administration. Only local execution has been
-- authorized; reconcile historical migrations before applying to a hosted DB.
create schema if not exists private;
revoke all on schema private from public;
grant usage on schema private to authenticated;

create function private.company_id() returns uuid language sql stable security definer
set search_path = '' as $$
  select entreprise_id from public.utilisateur
  where id=(select auth.uid()) and etat_compte='ACTIF' and est_compte_valide;
$$;
create function private.is_admin(company uuid) returns boolean language sql stable security definer
set search_path = '' as $$
  select exists(select 1 from public.utilisateur where id=(select auth.uid())
    and entreprise_id=company and role='ADMINISTRATEUR' and etat_compte='ACTIF' and est_compte_valide);
$$;
revoke all on all functions in schema private from public;
grant execute on function private.company_id(), private.is_admin(uuid) to authenticated;

-- Every public table gets RLS, including tables inherited without policies.
do $$ declare t record; begin
 for t in select tablename from pg_tables where schemaname='public' loop
  execute format('alter table public.%I enable row level security',t.tablename);
 end loop;
end $$;
revoke all on all tables in schema public from anon, authenticated;
grant select on categorie_empreinte,question_bilan,carbone_equivalent,actions,limite_actions_freq,streak_steps to anon,authenticated;
do $$ declare t text; begin
 foreach t in array array['categorie_empreinte','question_bilan','carbone_equivalent','actions','limite_actions_freq','streak_steps'] loop
  execute format('create policy catalog_read on public.%I for select to anon,authenticated using (true)',t);
 end loop;
end $$;

grant select on utilisateur,entreprise,communaute to authenticated;
create policy profile_read on utilisateur for select to authenticated
 using (id=(select auth.uid()) or private.is_admin(entreprise_id));
grant update(pseudo,avatar_url,est_actif,objectif,code_communaute) on utilisateur to authenticated;
create policy profile_update on utilisateur for update to authenticated
 using (id=(select auth.uid()) or private.is_admin(entreprise_id))
 with check ((id=(select auth.uid()) or private.is_admin(entreprise_id))
   and exists(select 1 from communaute c where c.code=code_communaute and c.entreprise_id=utilisateur.entreprise_id));
create policy company_read on entreprise for select to authenticated using (id=(select private.company_id()));
grant update(nom,description,logo_url) on entreprise to authenticated;
create policy company_update on entreprise for update to authenticated
 using (private.is_admin(id)) with check(private.is_admin(id));
grant insert,update,delete on communaute to authenticated;
create policy community_read on communaute for select to authenticated using (entreprise_id=(select private.company_id()));
create policy community_admin on communaute for all to authenticated
 using(private.is_admin(entreprise_id)) with check(private.is_admin(entreprise_id));

-- Community codes can be renamed without orphaning profiles.
alter table utilisateur drop constraint fk_communaute;
alter table utilisateur add constraint fk_communaute foreign key(code_communaute)
 references communaute(code) on update cascade on delete set null;
create index if not exists utilisateur_entreprise_idx on utilisateur(entreprise_id);
create index if not exists utilisateur_communaute_idx on utilisateur(code_communaute);
create index if not exists communaute_entreprise_idx on communaute(entreprise_id);
create index if not exists bilan_user_date_idx on bilan_carbone(utilisateur_id,date_bilan desc);

grant select,insert,update,delete on bilan_carbone,reponse_utilisateur,utilisateur_categorie_preference,
 actions_en_cours,utilisateur_habitudes,actions_ecartees,tags_ecartes,categories_ecartees to authenticated;
do $$ declare t text; begin
 foreach t in array array['bilan_carbone','utilisateur_categorie_preference',
 'actions_en_cours','utilisateur_habitudes','actions_ecartees','tags_ecartes','categories_ecartees'] loop
  execute format('create policy owner_access on public.%I for all to authenticated using(utilisateur_id=(select auth.uid())) with check(utilisateur_id=(select auth.uid()))',t);
 end loop;
end $$;
create policy answer_owner on reponse_utilisateur for all to authenticated
using(exists(select 1 from bilan_carbone b where b.id=bilan_id and b.utilisateur_id=(select auth.uid())))
with check(exists(select 1 from bilan_carbone b where b.id=bilan_id and b.utilisateur_id=(select auth.uid())));
create policy admin_bilan_read on bilan_carbone for select to authenticated using (
 exists(select 1 from utilisateur u where u.id=utilisateur_id and private.is_admin(u.entreprise_id)));
grant select,insert,update,delete on detail_bilan to authenticated;
create policy detail_read on detail_bilan for select to authenticated using(exists(select 1 from bilan_carbone b where b.id=detail_bilan.id));
create policy detail_write on detail_bilan for all to authenticated using(exists(select 1 from bilan_carbone b where b.id=detail_bilan.id and b.utilisateur_id=(select auth.uid())))
 with check(exists(select 1 from bilan_carbone b where b.id=detail_bilan.id and b.utilisateur_id=(select auth.uid())));
grant select on realisation_actions,utilisateur_streak,saison,notifications to authenticated;
grant insert on realisation_actions to authenticated;
grant update(last_streak_seen) on utilisateur_streak to authenticated;
grant update(is_read) on notifications to authenticated;
create policy realisation_read on realisation_actions for select to authenticated using(utilisateur_id=(select auth.uid()) or exists(select 1 from utilisateur u where u.id=utilisateur_id and private.is_admin(u.entreprise_id)));
create policy realisation_insert on realisation_actions for insert to authenticated with check(utilisateur_id=(select auth.uid()));
create policy streak_owner on utilisateur_streak for all to authenticated using(utilisateur_id=(select auth.uid())) with check(utilisateur_id=(select auth.uid()));
create policy season_read on saison for select to authenticated using(entreprise_id=(select private.company_id()));
create policy notification_owner on notifications for all to authenticated using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));
grant usage,select on all sequences in schema public to authenticated;

-- Trigger-only functions need privileges for derived fields, never RPC access.
alter function calculer_et_ajouter_xp() security definer;
alter function calculer_et_ajouter_xp() set search_path=public;
alter function sync_user_bilan_status() security definer;
alter function sync_user_bilan_status() set search_path=public;
alter function tg_calculer_streak_actions() security definer;
alter function tg_calculer_streak_actions() set search_path=public;
alter function tg_calculer_streak_actions_communautaires() security definer;
alter function tg_calculer_streak_actions_communautaires() set search_path=public;
revoke execute on all functions in schema public from public,anon,authenticated;

-- Guard replayed validations, including concurrent double taps.
create function private.guard_action_validation() returns trigger language plpgsql security definer set search_path='' as $$
declare frequency text; start_at timestamptz;
begin
 perform pg_advisory_xact_lock(hashtextextended(new.utilisateur_id::text||new.action_id::text,0));
 select frequence::text into frequency from public.actions where id=new.action_id;
 start_at := case frequency when 'quotidienne' then date_trunc('day',now())
 when 'hebdomadaire' then date_trunc('week',now()) when 'mensuelle' then date_trunc('month',now()) else '-infinity'::timestamptz end;
 if exists(select 1 from public.realisation_actions where utilisateur_id=new.utilisateur_id and action_id=new.action_id and date_realisation>=start_at) then
   raise exception 'Action déjà validée pour cette période' using errcode='23505';
 end if;
 return new;
end $$;
create trigger a_guard_validation before insert on realisation_actions for each row execute function private.guard_action_validation();
-- Multiple habits per user are supported by the UI.
alter table utilisateur_habitudes drop constraint utilisateur_habitudes_pkey;
alter table utilisateur_habitudes add primary key(utilisateur_id,action_id);

-- Admin aggregates use the invoker's RLS, with one latest balance per user.
create view vue_communaute with (security_invoker=true) as
select c.*, (select count(*) from utilisateur u where u.code_communaute=c.code and u.etat_compte='ACTIF') as nombre_membres,
 (select avg(b.scoretotalco2ean) from utilisateur u cross join lateral
  (select scoretotalco2ean from bilan_carbone where utilisateur_id=u.id and complet order by date_bilan desc,id desc limit 1) b
  where u.code_communaute=c.code) as bilan_moyen from communaute c;
grant select on vue_communaute to authenticated;

create function get_co2_evolution(company_id uuid,interval_type text)
returns table(average_co2 double precision,period timestamptz) language sql stable security invoker set search_path='' as $$
 select avg(b.scoretotalco2ean)/1000.0,date_trunc(case when interval_type='year' then 'year' else 'month' end,b.date_bilan)
 from public.bilan_carbone b join public.utilisateur u on u.id=b.utilisateur_id
 where u.entreprise_id=company_id and private.is_admin(company_id) and b.complet
 group by 2 order by 2;
$$;
create function get_carbon_distribution(company_id uuid)
returns table(name text,co2 double precision,percentage double precision) language sql stable security invoker set search_path='' as $$
 with latest as (select distinct on (b.utilisateur_id) b.id from public.bilan_carbone b join public.utilisateur u on u.id=b.utilisateur_id
 where u.entreprise_id=company_id and private.is_admin(company_id) and b.complet order by b.utilisateur_id,b.date_bilan desc,b.id desc),
 totals as(select v.name,coalesce(sum(v.value),0) as co2 from latest l join public.detail_bilan d on d.id=l.id
 cross join lateral(values ('Transport',d.transport),('Alimentation',d.alimentation),('Logement',d.logement),('Divers',d.divers),('Services sociétaux',d.services_societaux)) v(name,value) group by v.name)
 select name,co2,coalesce(100.0*co2/nullif(sum(co2) over(),0),0) from totals;
$$;
grant execute on function get_co2_evolution(uuid,text), get_carbon_distribution(uuid) to authenticated;

create function get_admin_kpis(company_id uuid) returns jsonb language sql stable security invoker set search_path='' as $$
 with members as(select * from public.utilisateur where entreprise_id=company_id and role='UTILISATEUR' and etat_compte='ACTIF' and private.is_admin(company_id)),
 counts as(select count(*) n,count(*) filter(where a_complete_bilan) completed from members),
 details as(select count(distinct b.utilisateur_id) n from public.detail_bilan d join public.bilan_carbone b on b.id=d.id join members u on u.id=b.utilisateur_id where b.complet),
 activity as(select count(*) n,count(distinct r.utilisateur_id) filter(where r.date_realisation>=current_date) daily from public.realisation_actions r join members u on u.id=r.utilisateur_id)
 select jsonb_build_object('completed',coalesce(100.0*c.completed/nullif(c.n,0),0),
 'detailed',coalesce(100.0*d.n/nullif(c.n,0),0),'actions',a.n,'daily',coalesce(100.0*a.daily/nullif(c.n,0),0))
 from counts c,details d,activity a;
$$;
grant execute on function get_admin_kpis(uuid) to authenticated;

-- Signup exposes only the fields needed for onboarding, not entire tables.
create function public.lookup_company(email_domain text) returns jsonb language sql stable security definer set search_path='' as $$
 select jsonb_build_object('nom',nom,'logo_url',logo_url) from public.entreprise where lower(domaine_email)=lower(email_domain) limit 1;
$$;
create function public.lookup_community(community_code text) returns jsonb language sql stable security definer set search_path='' as $$
 select jsonb_build_object('nom',nom) from public.communaute where code=upper(community_code);
$$;
create function public.pseudo_available(candidate text) returns boolean language sql stable security definer set search_path='' as $$
 select not exists(select 1 from public.utilisateur where lower(pseudo)=lower(candidate));
$$;
revoke all on function lookup_company(text),lookup_community(text),pseudo_available(text) from public;
grant execute on function lookup_company(text),lookup_community(text),pseudo_available(text) to anon,authenticated;
-- Prevent role/company spoofing through signup metadata.
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path='' as $$
declare company uuid; community text;
begin
 select id into company from public.entreprise where lower(domaine_email)=lower(split_part(new.email,'@',2));
 community:=upper(new.raw_user_meta_data->>'code_communaute');
 if company is null or not exists(select 1 from public.communaute where code=community and entreprise_id=company) then
   raise exception 'Entreprise ou communauté invalide';
 end if;
 insert into public.utilisateur(id,email,pseudo,code_communaute,entreprise_id,avatar_url,role)
 values(new.id,new.email,new.raw_user_meta_data->>'pseudo',community,company,'avatar_1.png','UTILISATEUR');
 return new;
end $$;
create function private.sync_confirmed_email() returns trigger language plpgsql security definer set search_path='' as $$
begin update public.utilisateur set email=new.email where id=new.id; return new; end $$;
create trigger sync_confirmed_email after update of email on auth.users for each row when(old.email is distinct from new.email) execute function private.sync_confirmed_email();

create function private.anonymize_profile(target_user_id uuid) returns void language plpgsql security definer set search_path='' as $$
declare target_company uuid;
begin
 select entreprise_id into target_company from public.utilisateur where id=target_user_id for update;
 if auth.uid() is null or (auth.uid()<>target_user_id and not private.is_admin(target_company)) then
   raise exception 'Accès refusé' using errcode='42501';
 end if;
 update public.utilisateur set pseudo='Anonyme-'||id,email=id||'@anonymous.invalid',avatar_url=null,
 etat_compte='ANONYMISE',est_compte_valide=false,est_actif=false where id=target_user_id;
 delete from auth.sessions where user_id=target_user_id;
 update auth.users set banned_until='infinity' where id=target_user_id;
end $$;
create function public.anonymize_user(target_user_id uuid) returns void language sql security invoker set search_path='' as $$select private.anonymize_profile(target_user_id);$$;
revoke all on function private.anonymize_profile(uuid),public.anonymize_user(uuid) from public;
grant execute on function private.anonymize_profile(uuid),public.anonymize_user(uuid) to authenticated;

grant select on action_communautaire,action_communautaire_participation,defis,defis_communautes,votes_lancement_defi,validations_defis to authenticated;
create policy collective_read on action_communautaire for select to authenticated using(entreprise_id=(select private.company_id())::text);
create policy participation_read on action_communautaire_participation for select to authenticated using(exists(select 1 from action_communautaire a where a.id=action_id));
create function private.validate_collective(instance_id uuid) returns void language plpgsql security definer set search_path='' as $$
declare profile public.utilisateur; instance public.action_communautaire; reward integer;
begin
 select * into profile from public.utilisateur where id=auth.uid() and etat_compte='ACTIF' and est_compte_valide for update;
 if profile.id is null then raise exception 'Accès refusé' using errcode='42501'; end if;
 select * into instance from public.action_communautaire where id=instance_id and entreprise_id=profile.entreprise_id::text and date_fin>now();
 if instance.id is null then raise exception 'Action indisponible'; end if;
 select impact_score into reward from public.actions where id=instance.action_id;
 insert into public.action_communautaire_participation(action_id,user_id,code_communaute) values(instance_id,profile.id,profile.code_communaute);
 update public.utilisateur set impact_score_xp=impact_score_xp+reward,actions_count=actions_count+1 where id=profile.id;
 update public.communaute set plant_xp=plant_xp+reward where code=profile.code_communaute;
end $$;
create function public.validate_collective_action(instance_id uuid) returns void language sql security invoker set search_path='' as $$select private.validate_collective(instance_id);$$;
revoke all on function private.validate_collective(uuid),public.validate_collective_action(uuid) from public;
grant execute on function private.validate_collective(uuid),public.validate_collective_action(uuid) to authenticated;

-- Collective challenges remain available to members of the same company.
grant insert on defis,defis_communautes,votes_lancement_defi,validations_defis,action_communautaire to authenticated;
grant update(statut) on defis_communautes to authenticated;
create policy collective_create on action_communautaire for insert to authenticated with check(
 entreprise_id=(select private.company_id())::text and createur_id=(select auth.uid()));
create policy challenge_read on defis for select to authenticated using(entreprise_id=(select private.company_id()));
create policy challenge_create on defis for insert to authenticated with check(entreprise_id=(select private.company_id()));
create policy duel_read on defis_communautes for select to authenticated using(entreprise_id=(select private.company_id()));
create policy duel_create on defis_communautes for insert to authenticated with check(
 entreprise_id=(select private.company_id()) and statut='VOTE_LANCEMENT'
 and communaute_demandeur_code=(select code_communaute from utilisateur where id=(select auth.uid()))
 and exists(select 1 from communaute where code=communaute_cible_code and entreprise_id=(select private.company_id()))
 and exists(select 1 from defis where id=defi_id and entreprise_id=(select private.company_id())));
create policy duel_respond on defis_communautes for update to authenticated using(
 statut='EN_ATTENTE_CIBLE' and communaute_cible_code=(select code_communaute from utilisateur where id=(select auth.uid())))
 with check(statut in ('ACTIF','REFUSE') and communaute_cible_code=(select code_communaute from utilisateur where id=(select auth.uid())));
create policy votes_read on votes_lancement_defi for select to authenticated using(exists(select 1 from defis_communautes d where d.id=defi_communaute_id));
create policy votes_insert on votes_lancement_defi for insert to authenticated with check(
 user_id=(select auth.uid()) and code_communaute=(select code_communaute from utilisateur where id=(select auth.uid()))
 and exists(select 1 from defis_communautes d where d.id=defi_communaute_id and d.statut='VOTE_LANCEMENT' and d.communaute_demandeur_code=code_communaute));
create policy validations_read on validations_defis for select to authenticated using(exists(select 1 from defis d where d.id=defi_id));
create policy validations_insert on validations_defis for insert to authenticated with check(
 user_id=(select auth.uid()) and code_communaute=(select code_communaute from utilisateur where id=(select auth.uid()))
 and exists(select 1 from defis_communautes d where d.defi_id=validations_defis.defi_id and d.statut='ACTIF' and d.date_expiration>now()
 and code_communaute in(d.communaute_demandeur_code,d.communaute_cible_code)));
create function private.check_launch(defi uuid,community text) returns void language plpgsql security definer set search_path='' as $$
declare members integer; votes integer;
begin
 if not exists(select 1 from public.utilisateur where id=auth.uid() and code_communaute=community and etat_compte='ACTIF') then raise exception 'Accès refusé' using errcode='42501'; end if;
 perform 1 from public.defis_communautes where id=defi and communaute_demandeur_code=community and statut='VOTE_LANCEMENT' for update;
 if not found then return; end if;
 select count(*) into members from public.utilisateur where code_communaute=community and est_actif and etat_compte='ACTIF' and role<>'ADMINISTRATEUR';
 select count(*) into votes from public.votes_lancement_defi v join public.utilisateur u on u.id=v.user_id
 where v.defi_communaute_id=defi and v.code_communaute=community and u.est_actif and u.etat_compte='ACTIF' and u.role<>'ADMINISTRATEUR';
 if members>0 and votes::numeric/members>=0.6 then update public.defis_communautes set statut='EN_ATTENTE_CIBLE' where id=defi; end if;
end $$;
create or replace function public.check_defi_launch_threshold(defi_id_param uuid,community_code_param text)
returns void language sql security invoker set search_path='' as $$select private.check_launch(defi_id_param,community_code_param);$$;
revoke all on function private.check_launch(uuid,text) from public;
grant execute on function private.check_launch(uuid,text),public.check_defi_launch_threshold(uuid,text) to authenticated;

-- Rankings expose the existing public profile fields without granting access
-- to other members' emails, preferences or private balance answers.
create function private.ranking_users() returns table(user_id uuid,username varchar,total_xp integer,code_communaute text,
 impact_stats text,actions_count integer,streak_days integer,avatar_url varchar,rank bigint)
language sql stable security definer set search_path='' as $$
select u.id,u.pseudo,u.impact_score_xp,u.code_communaute,u.impact_stats,u.actions_count,u.streak_days,u.avatar_url,
rank() over(partition by u.code_communaute order by u.impact_score_xp desc)
from public.utilisateur u where u.entreprise_id=private.company_id() and u.est_actif and u.role<>'ADMINISTRATEUR' and u.etat_compte='ACTIF';
$$;
create function private.ranking_communities() returns table(entreprise_id uuid,community_code text,community_name text,total_xp bigint,logo_url text,members_count bigint,total_actions bigint)
language sql stable security definer set search_path='' as $$
select c.entreprise_id,c.code,c.nom,coalesce(sum(u.impact_score_xp),0)+coalesce(c.plant_xp,0),c.logo_url,count(u.id),coalesce(sum(u.actions_count),0)
from public.communaute c left join public.utilisateur u on u.code_communaute=c.code and u.est_actif and u.role<>'ADMINISTRATEUR' and u.etat_compte='ACTIF'
where c.entreprise_id=private.company_id() group by c.code;
$$;
revoke all on function private.ranking_users(),private.ranking_communities() from public;
grant execute on function private.ranking_users(),private.ranking_communities() to authenticated;
create or replace view vue_user_ranking with(security_invoker=true) as
select user_id,username::varchar(255),total_xp,code_communaute,impact_stats,actions_count,streak_days,avatar_url::varchar(255),rank from private.ranking_users();
create or replace view vue_community_ranking with(security_invoker=true) as select * from private.ranking_communities();

-- Exposed views obey the same table policies; explicit grants for Data API.
do $$ declare v record; begin
 for v in select viewname from pg_views where schemaname='public' loop
  execute format('alter view public.%I set (security_invoker=true)',v.viewname);
  execute format('grant select on public.%I to authenticated',v.viewname);
 end loop;
end $$;

-- Storage contains curated public assets; only server-side tooling uploads.
insert into storage.buckets(id,name,public) values('avatars','avatars',true),('logos','logos',true),('streak','streak',true)
on conflict(id) do nothing;
create policy curated_assets_read on storage.objects for select to anon,authenticated using(bucket_id in ('avatars','logos','streak'));

-- Publish only necessary profile/notification changes.
do $$ begin
 if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and tablename='utilisateur') then
  alter publication supabase_realtime add table utilisateur;
 end if;
 if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and tablename='notifications') then
  alter publication supabase_realtime add table notifications;
 end if;
end $$;
