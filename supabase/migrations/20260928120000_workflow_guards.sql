-- Server authority for rewards, dates and account revocation.
revoke create on schema public from public, anon, authenticated;
alter default privileges in schema public revoke execute on functions from public;

do $$ declare t record; begin
 for t in select tablename from pg_tables where schemaname='public'
 and tablename not in ('categorie_empreinte','question_bilan','carbone_equivalent','actions','limite_actions_freq','streak_steps') loop
  execute format('create policy active_account on public.%I as restrictive for all to authenticated using ((select private.company_id()) is not null) with check ((select private.company_id()) is not null)', t.tablename);
 end loop;
end $$;

grant update(domaine_email) on entreprise to authenticated;
alter table entreprise add constraint valid_email_domain check(domaine_email = lower(domaine_email) and domaine_email ~ '^[a-z0-9][a-z0-9.-]*\.[a-z]{2,}$');
create unique index entreprise_email_domain_unique on entreprise(lower(domaine_email));
create unique index utilisateur_pseudo_unique on utilisateur(lower(pseudo));

create function private.stamp_action_date() returns trigger language plpgsql security definer set search_path='' as $$
begin new.date_realisation := now(); return new; end $$;
create trigger a0_stamp_action_date before insert on realisation_actions for each row execute function private.stamp_action_date();

create function private.guard_collective_creation() returns trigger language plpgsql security definer set search_path='' as $$
begin
 perform pg_advisory_xact_lock(hashtextextended(new.entreprise_id||new.action_id::text,0));
 if new.date_fin<=now() or new.date_fin>now()+interval '31 days' then raise exception 'Durée invalide'; end if;
 if exists(select 1 from public.action_communautaire where entreprise_id=new.entreprise_id and action_id=new.action_id and date_fin>now()) then
  raise exception 'Action collective déjà en cours' using errcode='23505';
 end if;
 new.date_debut:=now(); return new;
end $$;
create trigger guard_collective_creation before insert on action_communautaire for each row execute function private.guard_collective_creation();

alter table defis_communautes add column date_debut timestamptz;
create function private.start_duel() returns trigger language plpgsql set search_path='' as $$
begin
 if new.statut='ACTIF' and old.statut is distinct from new.statut then new.date_debut:=now(); end if;
 return new;
end $$;
create trigger start_duel before update on defis_communautes for each row execute function private.start_duel();

-- Daily validation is the existing duel rule. Values supplied by a client are ignored.
create function private.guard_duel_validation() returns trigger language plpgsql security definer set search_path='' as $$
begin
 perform pg_advisory_xact_lock(hashtextextended(new.user_id::text||new.defi_id::text,0));
 if exists(select 1 from public.validations_defis where user_id=new.user_id and defi_id=new.defi_id and created_at>=date_trunc('day',now())) then
  raise exception 'Défi déjà validé aujourd’hui' using errcode='23505';
 end if;
 select xp_gain into new.xp_gain from public.defis where id=new.defi_id;
 new.created_at:=now(); return new;
end $$;
create trigger guard_duel_validation before insert on validations_defis for each row execute function private.guard_duel_validation();

-- A duel is created atomically from a catalog action. Members cannot invent rewards.
revoke insert on defis from authenticated;
create function private.propose_random_duel(target_community text,category text,duration_days int) returns uuid
language plpgsql security definer set search_path='' as $$
declare profile public.utilisateur; chosen public.actions; challenge uuid; duel uuid;
begin
 select * into profile from public.utilisateur where id=auth.uid() and entreprise_id=private.company_id();
 if profile.id is null or profile.code_communaute=target_community or not exists(select 1 from public.communaute where code=target_community and entreprise_id=profile.entreprise_id) then raise exception 'Communauté invalide'; end if;
 if duration_days not in (3,7,14,30) or category not in ('Toutes','Énergie','Transport','Alimentation') then raise exception 'Paramètres invalides'; end if;
 perform pg_advisory_xact_lock(hashtextextended(least(profile.code_communaute,target_community)||greatest(profile.code_communaute,target_community),0));
 if exists(select 1 from public.defis_communautes where date_expiration>now() and statut in ('VOTE_LANCEMENT','EN_ATTENTE_CIBLE','ACTIF')
 and least(communaute_demandeur_code,communaute_cible_code)=least(profile.code_communaute,target_community)
 and greatest(communaute_demandeur_code,communaute_cible_code)=greatest(profile.code_communaute,target_community)) then raise exception 'Un duel est déjà en cours'; end if;
 select * into chosen from public.actions where category='Toutes' or categorie_nom=category
 or (category='Énergie' and categorie_nom in ('Eau','Consommation & Dechets','Numerique','Logement')) order by random() limit 1;
 if chosen.id is null then raise exception 'Aucune action disponible'; end if;
 insert into public.defis(entreprise_id,titre,description,xp_gain,categorie_nom,frequence)
 values(profile.entreprise_id,chosen.titre,chosen.description,chosen.impact_score,chosen.categorie_nom,chosen.frequence) returning id into challenge;
 insert into public.defis_communautes(defi_id,entreprise_id,communaute_demandeur_code,communaute_cible_code,is_global,statut,date_expiration)
 values(challenge,profile.entreprise_id,profile.code_communaute,target_community,false,'VOTE_LANCEMENT',now()+make_interval(days=>duration_days)) returning id into duel;
 return duel;
end $$;
create function public.propose_random_duel(target_community text,category text,duration_days int) returns uuid
language sql security invoker set search_path='' as $$select private.propose_random_duel(target_community,category,duration_days);$$;
revoke all on function private.propose_random_duel(text,text,int),public.propose_random_duel(text,text,int) from public;
grant execute on function private.propose_random_duel(text,text,int),public.propose_random_duel(text,text,int) to authenticated;

create or replace function private.anonymize_profile(target_user_id uuid) returns void language plpgsql security definer set search_path='' as $$
declare target_company uuid; masked_email text;
begin
 select entreprise_id into target_company from public.utilisateur where id=target_user_id for update;
 if private.company_id() is null or (auth.uid()<>target_user_id and not private.is_admin(target_company)) then raise exception 'Accès refusé' using errcode='42501'; end if;
 masked_email:=target_user_id||'@anonymous.invalid';
 delete from auth.sessions where user_id=target_user_id;
 delete from auth.identities where user_id=target_user_id;
 update auth.users set email=masked_email,encrypted_password='',raw_user_meta_data='{}',phone=null,banned_until=now()+interval '100 years',email_change='',phone_change='' where id=target_user_id;
 update public.utilisateur set pseudo='Anonyme-'||id,email=masked_email,avatar_url=null,
 etat_compte='ANONYMISE',est_compte_valide=false,est_actif=false where id=target_user_id;
end $$;

create index realisation_user_action_date_idx on realisation_actions(utilisateur_id,action_id,date_realisation desc);
create index collective_company_action_idx on action_communautaire(entreprise_id,action_id,date_fin);
create index participation_user_idx on action_communautaire_participation(user_id);
create index duel_validation_user_idx on validations_defis(user_id,defi_id,created_at desc);
create index duel_company_status_idx on defis_communautes(entreprise_id,statut,date_expiration);
create index defi_company_idx on defis(entreprise_id);
create index notification_user_idx on notifications(user_id);
revoke execute on all functions in schema private from public;
