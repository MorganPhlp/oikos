import "dotenv/config";
import { createClient } from "@supabase/supabase-js";

// On utilise la Service Role Key pour bypasser les RLS et gérer l'auth admin
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY,
);

const PASSWORD = "Password123!";

const USERS = [
  { prenom: "Lucas", nom: "Martin", community: "VIV123" },
  { prenom: "Emma", nom: "Bernard", community: "VIV123" },
  { prenom: "Hugo", nom: "Petit", community: "DEMO001" },
  { prenom: "Chloe", nom: "Robert", community: "VIV123" },
  { prenom: "Nathan", nom: "Richard", community: "DEMO001" },
  { prenom: "Lea", nom: "Durand", community: "VIV123" },
  { prenom: "Enzo", nom: "Moreau", community: "VIV123" },
  { prenom: "Manon", nom: "Simon", community: "DEMO001" },
  { prenom: "Louis", nom: "Laurent", community: "VIV123" },
  { prenom: "Camille", nom: "Lefebvre", community: "DEMO001" },
];

const COMMUNITY_ACTIONS = [
  {
    id: "2f0ba52e-4ee5-410f-aa86-16f36d773253",
    action_id: "f7a714a1-1eb5-4413-b7a1-82a16f03b38d", // Boîte Zen
    titre: "Défi : Boîte Zen Collective",
  },
  {
    id: "41378662-5b22-4d53-bb79-223e0681629a",
    action_id: "055358f1-39eb-46d5-9864-8b8bf67ee908", // Visio > Avion
    titre: "Défi : Moins d'avion, plus de visio",
  },
  {
    id: "7c1fa315-d9dc-4245-a02d-50cd9a33ffaf",
    action_id: "fd3b15b8-5b8f-4943-a267-a3d2634dc4a6", // Team étendoir
    titre: "Défi : Team Étendoir Oîkos",
  },
  {
    id: "f6de68a3-5497-48dc-b37d-bf625687d7ee",
    action_id: "71fc785b-ddc7-453f-98d6-0a19d74168e7", // Végé-Week
    titre: "Défi : Semaine Végé chez Viveris",
  },
];

function buildEmail(prenom, nom) {
  return `${prenom.toLowerCase()}.${nom.toLowerCase()}@viveris.fr`;
}

function buildPseudo(prenom, nom) {
  return `${prenom}${nom}`;
}

async function createFakeBilan(utilisateurId) {
  console.log(
    `🌍 Création d'un faux bilan carbone pour l'ID: ${utilisateurId}`,
  );

  const { data: bilan, error: bilanError } = await supabase
    .from("bilan_carbone")
    .insert({
      utilisateur_id: utilisateurId,
      scoretotalco2ean: 7.8,
      complet: true,
    })
    .select()
    .single();

  if (bilanError) {
    console.error("❌ Erreur création bilan :", bilanError.message);
    return;
  }

  const { error: detailError } = await supabase.from("detail_bilan").insert({
    id: bilan.id,
    transport: 2.5,
    alimentation: 1.8,
    logement: 2.0,
    divers: 0.7,
    services_societaux: 0.8,
  });

  if (detailError) {
    console.error("❌ Erreur detail bilan :", detailError.message);
    return;
  }

  const { error: updateError } = await supabase
    .from("utilisateur")
    .update({ a_complete_bilan: true })
    .eq("id", utilisateurId);

  if (updateError) {
    console.error("❌ Erreur update utilisateur :", updateError.message);
  } else {
    console.log("✅ Bilan et utilisateur mis à jour !");
  }
}

async function createUser({ prenom, nom, community }, entrepriseId) {
  const email = buildEmail(prenom, nom);
  const pseudo = buildPseudo(prenom, nom);

  // 1. Auth Admin Creation
  const { data, error } = await supabase.auth.admin.createUser({
    email,
    password: PASSWORD,
    email_confirm: true,
    user_metadata: { pseudo, code_communaute: community },
  });

  if (error) {
    if (error.message.includes("already exists")) {
      // Si l'user existe déjà, on récupère son ID pour la suite du seed
      const { data: existing } = await supabase
        .from("utilisateur")
        .select("id")
        .eq("email", email)
        .single();
      return existing;
    }
    console.error(`❌ ${email}`, error.message);
    return null;
  }

  // 2. Upsert dans la table public.utilisateur (nécessaire si le trigger n'est pas activé)
  await supabase.from("utilisateur").upsert({
    id: data.user.id,
    email: email,
    pseudo: pseudo,
    entreprise_id: entrepriseId,
    code_communaute: community,
    etat_compte: "ACTIF",
    est_compte_valide: true,
  });

  console.log(`✅ ${email} | ${community}`);
  return data.user;
}

async function seed() {
  console.log("🚀 Initialisation du Seed...");

  // --- 1. Récupération dynamique de l'entreprise Viveris ---
  const { data: entreprise, error: entError } = await supabase
    .from("entreprise")
    .select("id")
    .eq("nom", "Viveris")
    .single();

  if (entError || !entreprise) {
    console.error("❌ Erreur : Entreprise 'Viveris' introuvable en base.");
    return;
  }
  const VIVERIS_ID = entreprise.id;
  console.log(`🏢 ID Entreprise Viveris : ${VIVERIS_ID}`);

  // --- 2. Création des utilisateurs ---
  console.log(`\n👥 Creating ${USERS.length} users...`);
  const createdUsers = [];

  for (const user of USERS) {
    const userRes = await createUser(user, VIVERIS_ID);
    if (userRes) {
      createdUsers.push({
        ...userRes,
        prenom: user.prenom,
        nom: user.nom,
        community: user.community,
      });
    }
  }

  // --- 3. Bilan pour Lucas ---
  const lucas = createdUsers.find((u) => u.prenom === "Lucas");
  if (lucas) await createFakeBilan(lucas.id);

  // --- 4. Création des actions communautaires ---
  console.log("\n🌍 Création des actions communautaires...");
  for (const act of COMMUNITY_ACTIONS) {
    const { error: actError } = await supabase
      .from("action_communautaire")
      .upsert({
        id: act.id,
        entreprise_id: VIVERIS_ID,
        action_id: act.action_id,
        titre_personnalise: act.titre,
        date_debut: new Date().toISOString(),
        date_fin: new Date(Date.now() + 15 * 24 * 60 * 60 * 1000).toISOString(), // Fin dans 15 jours
        createur_id: createdUsers[0]?.id, // Lucas par défaut
      });

    if (actError)
      console.error(`❌ Erreur Action ${act.titre}:`, actError.message);
    else console.log(`✅ ${act.titre} créé.`);
  }

  // --- 5. Simulation des participations ---
  console.log("\n🤝 Simulation des participations...");
  // On prend les IDs des deux premiers utilisateurs créés (Lucas et Emma)
  if (createdUsers.length >= 2) {
    const participations = [
      {
        action_id: COMMUNITY_ACTIONS[0].id,
        user_id: createdUsers[0].id,
        code_communaute: createdUsers[0].community,
      },
      {
        action_id: COMMUNITY_ACTIONS[0].id,
        user_id: createdUsers[1].id,
        code_communaute: createdUsers[1].community,
      },
      {
        action_id: COMMUNITY_ACTIONS[2].id,
        user_id: createdUsers[0].id,
        code_communaute: createdUsers[0].community,
      },
    ];

    const { error: partError } = await supabase
      .from("action_communautaire_participation")
      .upsert(participations);

    if (partError)
      console.error("❌ Erreur participations :", partError.message);
  }

  console.log("\n🎉 Seeding finished successfully.");
}

seed();
