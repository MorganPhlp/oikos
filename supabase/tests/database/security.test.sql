begin;
create extension if not exists pgtap with schema extensions;
select plan(4);
select is((select count(*)::int from pg_tables t join pg_class c on c.relname=t.tablename join pg_namespace n on n.oid=c.relnamespace and n.nspname=t.schemaname where t.schemaname='public' and not c.relrowsecurity),0,'RLS enabled on all public tables');
select ok(not has_column_privilege('authenticated','public.utilisateur','role','UPDATE'),'Members cannot write business role');
select ok(not has_column_privilege('authenticated','public.utilisateur','impact_score_xp','UPDATE'),'Clients cannot write XP');
select ok(not has_function_privilege('anon','public.add_xp_to_user(uuid,integer)','EXECUTE'),'Legacy arbitrary XP RPC is inaccessible');
select * from finish();
rollback;
