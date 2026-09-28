-- Renaming a code preserves history. Communities with history cannot be deleted.
alter table defis_communautes add constraint duel_requester_community_fk foreign key(communaute_demandeur_code) references communaute(code) on update cascade on delete restrict;
alter table defis_communautes add constraint duel_target_community_fk foreign key(communaute_cible_code) references communaute(code) on update cascade on delete restrict;
alter table votes_lancement_defi add constraint vote_community_fk foreign key(code_communaute) references communaute(code) on update cascade on delete restrict;
alter table validations_defis add constraint validation_community_fk foreign key(code_communaute) references communaute(code) on update cascade on delete restrict;
alter table action_communautaire_participation add constraint participation_community_fk foreign key(code_communaute) references communaute(code) on update cascade on delete restrict;
alter table defi_participation add constraint legacy_participation_community_fk foreign key(code_communaute) references communaute(code) on update cascade on delete restrict;
create index duel_requester_community_idx on defis_communautes(communaute_demandeur_code);
create index duel_target_community_idx on defis_communautes(communaute_cible_code);
create index vote_community_idx on votes_lancement_defi(code_communaute);
create index validation_community_idx on validations_defis(code_communaute);
create index participation_community_idx on action_communautaire_participation(code_communaute);
create index legacy_participation_community_idx on defi_participation(code_communaute);

drop policy profile_update on utilisateur;
create policy profile_update on utilisateur for update to authenticated
 using (id=(select auth.uid()) or private.is_admin(entreprise_id))
 with check ((id=(select auth.uid()) or private.is_admin(entreprise_id))
   and (code_communaute is null or exists(select 1 from communaute c where c.code=code_communaute and c.entreprise_id=utilisateur.entreprise_id)));

revoke all on function get_admin_kpis(uuid),get_co2_evolution(uuid,text),get_carbon_distribution(uuid) from public,anon;

drop policy participation_read on action_communautaire_participation;
create policy participation_read on action_communautaire_participation for select to authenticated
 using(exists(select 1 from action_communautaire a where a.id=action_communautaire_participation.action_id));

do $$ declare table_name text; begin
 foreach table_name in array array['utilisateur_streak','saison'] loop
  if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and tablename=table_name) then
   execute format('alter publication supabase_realtime add table public.%I',table_name);
  end if;
 end loop;
end $$;
