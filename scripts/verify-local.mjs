import assert from 'node:assert/strict';
import { createClient } from '@supabase/supabase-js';

const url = process.env.SUPABASE_URL;
if (!url || !['127.0.0.1', 'localhost'].includes(new URL(url).hostname)) throw new Error('Tests réservés à la base locale.');
const options = { auth: { persistSession: false, autoRefreshToken: false } };
const anonKey = process.env.SUPABASE_ANON_KEY;
const anonymous = createClient(url, anonKey, options);
const service = createClient(url, process.env.SUPABASE_SERVICE_ROLE_KEY, options);
const ids = { admin: '20000000-0000-0000-0000-000000000001', alice: '20000000-0000-0000-0000-000000000002', bob: '20000000-0000-0000-0000-000000000003', eve: '20000000-0000-0000-0000-000000000004' };
const company = '10000000-0000-0000-0000-000000000001';
const otherCompany = '10000000-0000-0000-0000-000000000002';
const collective = '30000000-0000-0000-0000-000000000001';
function ok(result, label) { assert.equal(result.error, null, `${label}: ${result.error?.message}`); return result.data; }
function denied(result, label) { assert.ok(result.error || result.data?.length === 0, label); }
let count = 0;
async function test(label, fn) { await fn(); console.log(`PASS ${++count} ${label}`); }
async function login(name) {
  const client = createClient(url, anonKey, options);
  ok(await client.auth.signInWithPassword({ email: `${name}@oikos.test`, password: 'OikosLocal123!' }), `login ${name}`);
  return client;
}
const alice = await login('alice');
const admin = await login('admin');
const bob = await login('bob');
const cleanupUsers = [];
const cleanupDuels = [];
const cleanupChallenges = [];
const originalAlice = ok(await service.from('utilisateur').select('impact_score_xp,actions_count').eq('id', ids.alice).single(),'snapshot');
const originalCommunity = ok(await service.from('communaute').select('plant_xp').eq('code','DEMO01').single(),'snapshot');
try {
 await test('32 questions publiques, aucun profil accessible anonymement', async () => {
  assert.equal(ok(await anonymous.from('question_bilan').select('slug'),'questions').length,32);
  denied(await anonymous.from('utilisateur').select('id,email'),'anonymous profile access');
  assert.equal(ok(await anonymous.rpc('lookup_company',{email_domain:'oikos.test'}),'onboarding').nom,'Oikos Démo');
 });
 await test('rôle administrateur et isolation des profils / classements', async () => {
  const users = ok(await admin.from('utilisateur').select('id,role'),'admin users');
  assert.ok(users.some(u=>u.id===ids.admin && u.role==='ADMINISTRATEUR'));
  assert.ok(!users.some(u=>u.id===ids.eve));
  assert.deepEqual(ok(await alice.from('utilisateur').select('id'),'member users').map(u=>u.id),[ids.alice]);
  const ranking=ok(await alice.from('vue_user_ranking').select('*'),'ranking');
  assert.ok(ranking.some(u=>u.user_id===ids.bob));
  assert.ok(ranking.every(u=>u.user_id!==ids.eve && !('email' in u)));
 });
 await test('interdiction d’élever son rôle, son XP ou de changer d’entreprise',async()=>{
  for(const patch of [{role:'ADMINISTRATEUR'},{impact_score_xp:999999},{entreprise_id:otherCompany},{code_communaute:'AUTRE1'}]) {
   assert.ok((await alice.from('utilisateur').update(patch).eq('id',ids.alice)).error,JSON.stringify(patch));
  }
  denied(await admin.from('utilisateur').update({pseudo:'intrusion'}).eq('id',ids.eve).select('id'),'cross company update');
 });
 await test('bilan privé et indicateurs administrateur calculés',async()=>{
  assert.ok(ok(await alice.from('bilan_carbone').select('utilisateur_id'),'own balances').every(b=>b.utilisateur_id===ids.alice));
  denied(await alice.from('bilan_carbone').insert({utilisateur_id:ids.eve,complet:false}),'foreign balance');
  const kpi=ok(await admin.rpc('get_admin_kpis',{company_id:company}),'kpis');
  assert.ok(Math.abs(kpi.completed-200/3)<0.01);
  const distribution=ok(await admin.rpc('get_carbon_distribution',{company_id:company}),'distribution');
  assert.equal(distribution.length,5);
  assert.ok(Math.abs(distribution.reduce((n,c)=>n+c.percentage,0)-100)<0.01);
  assert.deepEqual(ok(await admin.rpc('get_carbon_distribution',{company_id:otherCompany}),'foreign distribution'),[]);
  assert.deepEqual(ok(await alice.rpc('get_carbon_distribution',{company_id:company}),'non admin distribution'),[]);
 });
 await test('participation collective atomique, une seule récompense même en concurrence',async()=>{
  ok(await service.from('action_communautaire_participation').delete().eq('action_id',collective).eq('user_id',ids.alice),'cleanup participation');
  const attempts=await Promise.all([1,2].map(()=>alice.rpc('validate_collective_action',{instance_id:collective})));
  assert.equal(attempts.filter(r=>!r.error).length,1,JSON.stringify(attempts.map(r=>r.error)));
  const after=ok(await alice.from('utilisateur').select('impact_score_xp,actions_count').single(),'reward');
  assert.ok(after.impact_score_xp>originalAlice.impact_score_xp);
  assert.equal(after.actions_count,originalAlice.actions_count+1);
 });
 await test('validation individuelle : date et XP contrôlés par la base',async()=>{
  const action=ok(await anonymous.from('actions').select('id,impact_score').eq('frequence','quotidienne').limit(1).single(),'action');
  ok(await service.from('realisation_actions').delete().eq('utilisateur_id',ids.alice).eq('action_id',action.id),'cleanup action');
  const result=ok(await alice.from('realisation_actions').insert({utilisateur_id:ids.alice,action_id:action.id,xp_gagne:999999,date_realisation:'2000-01-01T00:00:00Z'}).select().single(),'validate action');
  assert.ok(result.xp_gagne<999999);
  assert.ok(Date.parse(result.date_realisation)>Date.now()-60000);
  assert.ok((await alice.from('realisation_actions').insert({utilisateur_id:ids.alice,action_id:action.id})).error);
  ok(await service.from('realisation_actions').delete().eq('id',result.id),'cleanup action');
 });
 await test('duel : tirage, votes, acceptation, validation et protection contre les doublons',async()=>{
  const duelId=ok(await alice.rpc('propose_random_duel',{target_community:'DEMO02',category:'Transport',duration_days:7}),'propose duel');
  cleanupDuels.push(duelId);
  const duel=ok(await alice.from('defis_communautes').select('*').eq('id',duelId).single(),'duel');
  cleanupChallenges.push(duel.defi_id);
  assert.ok((await alice.rpc('propose_random_duel',{target_community:'AUTRE1',category:'Transport',duration_days:7})).error);
  assert.ok((await alice.rpc('propose_random_duel',{target_community:'DEMO02',category:'Transport',duration_days:7})).error);
  ok(await alice.from('votes_lancement_defi').insert({defi_communaute_id:duelId,user_id:ids.alice,code_communaute:'DEMO01'}),'vote');
  ok(await alice.rpc('check_defi_launch_threshold',{defi_id_param:duelId,community_code_param:'DEMO01'}),'threshold');
  // DEMO01 contains Alice and the new member: seed a second member vote via its real session.
  const newcomer=await login('nouveau');
  const profile=ok(await newcomer.from('utilisateur').select('id,code_communaute').single(),'new member');
  if(profile.code_communaute==='DEMO01') {
   ok(await newcomer.from('votes_lancement_defi').insert({defi_communaute_id:duelId,user_id:profile.id,code_communaute:'DEMO01'}),'second vote');
   ok(await newcomer.rpc('check_defi_launch_threshold',{defi_id_param:duelId,community_code_param:'DEMO01'}),'threshold');
  }
  await newcomer.auth.signOut();
  ok(await bob.from('defis_communautes').update({statut:'ACTIF'}).eq('id',duelId).select().single(),'accept');
  const validation=ok(await alice.from('validations_defis').insert({defi_id:duel.defi_id,user_id:ids.alice,code_communaute:'DEMO01',xp_gain:999999}).select().single(),'duel validation');
  assert.ok(validation.xp_gain<999999);
  assert.ok((await alice.from('validations_defis').insert({defi_id:duel.defi_id,user_id:ids.alice,code_communaute:'DEMO01',xp_gain:10})).error);
 });
 await test('préférences privées : exclusion et restauration',async()=>{
  const action=ok(await anonymous.from('actions').select('id').limit(1).single(),'catalog');
  ok(await alice.from('actions_ecartees').upsert({utilisateur_id:ids.alice,action_id:action.id}),'exclude');
  const rows=ok(await alice.from('actions_ecartees').select('action_id,actions(titre)').eq('utilisateur_id',ids.alice),'labels');
  assert.ok(rows.some(r=>r.action_id===action.id && r.actions.titre));
  denied(await bob.from('actions_ecartees').delete().eq('utilisateur_id',ids.alice).select(),'foreign restore');
  ok(await alice.from('actions_ecartees').delete().eq('utilisateur_id',ids.alice).eq('action_id',action.id),'restore');
 });
 await test('administration : retrait, renommage et conservation de l’historique',async()=>{
  ok(await admin.from('utilisateur').update({code_communaute:null}).eq('id',ids.bob),'remove member');
  ok(await admin.from('utilisateur').update({code_communaute:'DEMO02'}).eq('id',ids.bob),'restore member');
  ok(await admin.from('communaute').update({code:'RENAMED'}).eq('code','DEMO01'),'rename');
  const profile=ok(await alice.from('utilisateur').select('code_communaute').single(),'profile cascade');
  assert.equal(profile.code_communaute,'RENAMED');
  const history=ok(await alice.from('action_communautaire_participation').select('code_communaute').eq('action_id',collective),'history cascade');
  assert.equal(history[0].code_communaute,'RENAMED');
  assert.ok((await admin.from('communaute').delete().eq('code','RENAMED')).error);
  ok(await admin.from('communaute').update({code:'DEMO01'}).eq('code','RENAMED'),'restore code');
 });
 await test('inscription : refus interentreprise, rôle imposé et révocation après anonymisation',async()=>{
  const suffix=Date.now();
  const invalid=await service.auth.admin.createUser({email:`invalid-${suffix}@oikos.test`,password:'OikosLocal123!',email_confirm:true,user_metadata:{pseudo:`Invalid-${suffix}`,code_communaute:'AUTRE1'}});
  assert.ok(invalid.error);
  const response=ok(await service.auth.admin.createUser({email:`test-${suffix}@oikos.test`,password:'OikosLocal123!',email_confirm:true,user_metadata:{pseudo:`Test-${suffix}`,code_communaute:'DEMO01',role:'ADMINISTRATEUR',entreprise_id:otherCompany}}),'signup');
  cleanupUsers.push(response.user.id);
  const temp=await login(`test-${suffix}`);
  const profile=ok(await temp.from('utilisateur').select('*').single(),'signup profile');
  assert.equal(profile.role,'UTILISATEUR');assert.equal(profile.entreprise_id,company);
  const token=temp.auth.getSession();
  await token;
  ok(await temp.rpc('anonymize_user',{target_user_id:response.user.id}),'anonymize');
  assert.deepEqual(ok(await temp.from('bilan_carbone').select('id'),'revoked read'),[]);
  assert.ok((await temp.from('bilan_carbone').insert({utilisateur_id:response.user.id,complet:false})).error);
  const authUser=ok(await service.auth.admin.getUserById(response.user.id),'anonymized auth');
  assert.ok(authUser.user.email.endsWith('@anonymous.invalid'));
 });
 await test('bilan : réponses privées, détail et progression de l’inscription',async()=>{
  const newcomer=await login('nouveau');
  const userId='20000000-0000-0000-0000-000000000005';
  let bilan;
  try {
   bilan=ok(await newcomer.from('bilan_carbone').insert({utilisateur_id:userId,scoretotalco2ean:0,complet:false}).select('id').single(),'new balance');
   const question=ok(await anonymous.from('question_bilan').select('id').limit(1).single(),'question');
   ok(await newcomer.from('reponse_utilisateur').upsert({bilan_id:bilan.id,question_id:question.id,valeur:'2'},{onConflict:'bilan_id,question_id'}),'answer');
   denied(await alice.from('reponse_utilisateur').select().eq('bilan_id',bilan.id),'private answer');
   ok(await newcomer.from('detail_bilan').upsert({id:bilan.id,transport:1000,alimentation:1000,logement:1000,divers:500,services_societaux:500}),'detail');
   ok(await newcomer.from('bilan_carbone').update({scoretotalco2ean:4000,complet:true}).eq('id',bilan.id),'complete');
   assert.equal(ok(await newcomer.from('utilisateur').select('a_complete_bilan').single(),'onboarding').a_complete_bilan,true);
  } finally {
   if(bilan) await service.from('bilan_carbone').delete().eq('id',bilan.id);
   await service.from('utilisateur').update({a_complete_bilan:false}).eq('id',userId);
   await newcomer.auth.signOut();
  }
 });
 console.log(`${count} scénarios d’intégration réussis.`);
} finally {
 await service.from('communaute').update({code:'DEMO01'}).eq('code','RENAMED');
 await service.from('utilisateur').update({code_communaute:'DEMO02'}).eq('id',ids.bob);
 await service.from('actions_ecartees').delete().eq('utilisateur_id',ids.alice);
 for(const duel of cleanupDuels) {
  await service.from('votes_lancement_defi').delete().eq('defi_communaute_id',duel);
  await service.from('defis_communautes').delete().eq('id',duel);
 }
 for(const challenge of cleanupChallenges) await service.from('defis').delete().eq('id',challenge);
 for(const id of cleanupUsers) { await service.from('utilisateur').delete().eq('id',id); await service.auth.admin.deleteUser(id); }
 await service.from('action_communautaire_participation').delete().eq('action_id',collective).eq('user_id',ids.alice);
 await service.from('utilisateur').update(originalAlice).eq('id',ids.alice);
 await service.from('communaute').update(originalCommunity).eq('code','DEMO01');
 await Promise.all([alice,admin,bob].map(c=>c.auth.signOut()));
}
