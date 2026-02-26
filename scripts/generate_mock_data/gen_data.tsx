import { createClient } from "@supabase/supabase-js";
import { getGeneratedUsers } from "./generate_users";
import { setMockRealiserActions } from "./realiser_actions";
import { addFakeBilan } from "./add_fake_bilan";
import "dotenv/config";

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_ANON_KEY!,
);

export async function seed() {
  const usersToCreate = getGeneratedUsers();
  console.log(`🚀 Démarrage du seed (Client Public) pour ${usersToCreate.length} utilisateurs...`);

  for (const userData of usersToCreate) {
    try {
      console.log(`\n--- 👤 Inscription : ${userData.email} ---`);

      // 1. Inscription classique (signUp)
      // Note : Sans clé admin, c'est l'utilisateur lui-même qui s'inscrit
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: userData.email,
        password: userData.password,
        options: {
          data: {
            pseudo: userData.pseudo,
            code_communaute: userData.code_communaute,
          }
        }
      });

      if (authError) {
        console.error(`❌ Erreur SignUp (${userData.email}):`, authError.message);
        continue;
      }

      // Si l'utilisateur est déjà inscrit, Supabase peut retourner un user sans session 
      // ou une erreur selon tes réglages. On vérifie l'ID.
      const userId = authData.user?.id;

      if (!userId) {
        console.warn(`⚠️ Pas d'ID récupéré pour ${userData.email}, passage au suivant.`);
        continue;
      }

      // 2. Création du profil (table publique)
      // Si tu as un trigger SQL "handle_new_user", cette étape est peut-être déjà faite.
      // On utilise upsert pour éviter de bloquer si le profil existe déjà.
      const { error: profileError } = await supabase.from("utilisateur").upsert({
        id: userId,
        email: userData.email,
        pseudo: userData.pseudo,
        code_communaute: userData.code_communaute,
      }, { onConflict: 'id' });

      if (profileError) {
        console.error(`❌ Erreur Profil (${userData.email}):`, profileError.message);
        continue;
      }

      // 3. Génération des données métier
      await proceedToMockData(userId);

    } catch (err) {
      console.error(`💥 Erreur système pour ${userData.email}:`, err);
    }
  }

  console.log("\n✨ Seed terminé.");
}

async function proceedToMockData(userId: string) {
  console.log(`  📊 Bilan...`);
  await addFakeBilan(userId);

  console.log(`  🏃 Actions...`);
  await setMockRealiserActions(userId);

  console.log(`  ✅ Terminé pour ${userId}`);
}

seed();