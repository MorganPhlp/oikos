import { createClient } from "@supabase/supabase-js";
import { getGeneratedUsers } from "./generate_users";
import { setMockRealiserActions } from "./realiser_actions";
import { addFakeBilan } from "./add_fake_bilan";
import { generateFakeDefis } from "./generate_fake_defis";
import "dotenv/config";

const supabaseAdmin = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY! // TA SECRET KEY
);

export async function seed() {
  const users = getGeneratedUsers();
  const createdUserIds: string[] = [];

  for (const u of users) {
    console.log(`👤 Traitement : ${u.email}`);
    const { data: authData, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email: u.email, password: u.password, email_confirm: true,
      user_metadata: { pseudo: u.pseudo, code_communaute: u.code_communaute }
    });

    let userId = authData.user?.id;
    if (authError?.message.includes("already registered")) {
      const { data: existing } = await supabaseAdmin.from("utilisateur").select("id").eq("email", u.email).single();
      userId = existing?.id;
    }

    if (userId) {
      createdUserIds.push(userId);
      await supabaseAdmin.from("utilisateur").upsert({ id: userId, email: u.email, pseudo: u.pseudo, code_communaute: u.code_communaute });
      await addFakeBilan(userId, supabaseAdmin);
      await setMockRealiserActions(userId, supabaseAdmin);
    }
  }

  await generateFakeDefis(createdUserIds, supabaseAdmin);
  console.log("✨ Seed terminé !");
}

seed();