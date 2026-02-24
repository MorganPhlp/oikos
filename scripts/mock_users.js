import "dotenv/config";
import { createClient } from "@supabase/supabase-js";

// Utilisation de la Service Role Key pour bypasser les RLS et gérer l'auth admin
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY, // Assure-toi d'utiliser la SERVICE_ROLE_KEY
);

// mot de passe pour tous les comptes
const PASSWORD = "Password123!";

const USERS = [
  { prenom: "Lucas", nom: "Martin", community: "VIV123" },
  { prenom: "Emma", nom: "Bernard", community: "VIV123" },
  { prenom: "Hugo", nom: "Petit", community: "VIV456" },
  { prenom: "Chloe", nom: "Robert", community: "VIV123" },
  { prenom: "Nathan", nom: "Richard", community: "VIV456" },
  { prenom: "Lea", nom: "Durand", community: "VIV123" },
  { prenom: "Enzo", nom: "Moreau", community: "VIV123" },
  { prenom: "Manon", nom: "Simon", community: "VIV789" },
  { prenom: "Louis", nom: "Laurent", community: "VIV123" },
  { prenom: "Camille", nom: "Lefebvre", community: "VIV123" },
  { prenom: "Mathis", nom: "Garcia", community: "VIV456" },
  { prenom: "Sarah", nom: "Garnier", community: "VIV123" },
  { prenom: "Maxime", nom: "Dupuis", community: "VIV123" },
  { prenom: "Julie", nom: "Lemoine", community: "VIV789" },
];

const GENERIC_DEFIS = [
  {
    id: "e44d715a-406c-4971-8e01-d707c65538e3",
    titre: "Challenge Veggie",
    description: "Toute la communauté passe au végétarien pendant 1 semaine.",
    categorie_nom: "Alimentation",
    difficulte: "Moyen",
    gain_co2: 15.5,
    xp_gain: 500,
    icon_name: "restaurant",
    frequence: "hebdomadaire",
    tips: [
      "Préparez vos lunch-box ensemble",
      "Partagez vos recettes sur le chat",
    ],
  },
  {
    id: "a11b22c3-44d5-55e6-66f7-778899aabbcc",
    titre: "Zéro Mail Inutile",
    description: "Nettoyez vos boîtes mail et évitez les 'Répondre à tous'.",
    categorie_nom: "Numérique",
    difficulte: "Facile",
    gain_co2: 5.2,
    xp_gain: 200,
    icon_name: "email",
    frequence: "mensuelle",
    tips: ["Utilisez le chat pour les messages courts"],
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

  if (bilanError) return console.error("❌ Erreur bilan :", bilanError.message);

  await supabase.from("detail_bilan").insert({
    id: bilan.id,
    transport: 2.5,
    alimentation: 1.8,
    logement: 2.0,
    divers: 0.7,
    services_societaux: 0.8,
  });

  await supabase
    .from("utilisateur")
    .update({ a_complete_bilan: true })
    .eq("id", utilisateurId);
  console.log("✅ Bilan créé !");
}

async function createUser({ prenom, nom, community }, entrepriseId) {
  const email = buildEmail(prenom, nom);
  const pseudo = buildPseudo(prenom, nom);

  const { data, error } = await supabase.auth.admin.createUser({
    email,
    password: PASSWORD,
    email_confirm: true,
    user_metadata: { pseudo, code_communaute: community },
  });

  if (error) {
    if (error.message.includes("already exists")) {
      const { data: existing } = await supabase
        .from("utilisateur")
        .select("id")
        .eq("email", email)
        .single();
      return existing;
    }
    return null;
  }

  await supabase.from("utilisateur").upsert({
    id: data.user.id,
    email,
    pseudo,
    entreprise_id: entrepriseId,
    code_communaute: community,
    etat_compte: "ACTIF",
    est_compte_valide: true,
  });

  return data.user;
}

async function seed() {
  console.log("🚀 Initialisation du Seed...");

  // 1. Entreprise
  const { data: entreprise } = await supabase
    .from("entreprise")
    .select("id")
    .eq("nom", "Viveris")
    .single();
  const VIVERIS_ID = entreprise.id;

  // 2. Bibliothèque de Défis Génériques
  console.log("📚 Création de la bibliothèque de défis...");
  await supabase
    .from("defis")
    .upsert(GENERIC_DEFIS.map((d) => ({ ...d, entreprise_id: VIVERIS_ID })));

  // 3. Utilisateurs
  console.log(`\n👥 Création des ${USERS.length} utilisateurs...`);
  const createdUsers = [];
  for (const user of USERS) {
    const userRes = await createUser(user, VIVERIS_ID);
    if (userRes) createdUsers.push({ ...userRes, ...user });
  }

  const lucas = createdUsers.find((u) => u.prenom === "Lucas");
  if (lucas) await createFakeBilan(lucas.id);

  // 4. Défis de Communauté (Table defis_communautes)
  console.log("\n⚔️ Lancement des défis communautaires...");

  // On lance le défi Challenge Veggie pour la commu de Lucas (VIV123)
  const { data: defiCommu } = await supabase
    .from("defis_communautes")
    .upsert({
      id: "999d715a-406c-4971-8e01-d707c65538e3",
      defi_id: GENERIC_DEFIS[0].id,
      entreprise_id: VIVERIS_ID,
      communaute_demandeur_code: "VIV123",
      communaute_cible_code: "DEMO001",
      is_global: false,
      date_expiration: new Date(
        Date.now() + 15 * 24 * 60 * 60 * 1000,
      ).toISOString(),
      statut: "ACTIF", // Directement actif pour Lucas
    })
    .select()
    .single();

  // 5. Votes de lancement (Simuler les 60% pour VIV123)
  console.log("🗳️ Simulation des votes de lancement pour VIV123...");
  const vivUsers = createdUsers
    .filter((u) => u.community === "VIV123")
    .slice(0, 4); // On fait voter 4 personnes
  const votes = vivUsers.map((u) => ({
    defi_communaute_id: defiCommu.id,
    user_id: u.id,
    code_communaute: "VIV123",
  }));
  await supabase.from("votes_lancement_defi").upsert(votes);

  // 6. Validations (Lucas valide le défi)
  console.log("🏆 Lucas valide le défi...");
  await supabase.from("validations_defis").insert({
    defi_id: GENERIC_DEFIS[0].id,
    user_id: lucas.id,
    code_communaute: "VIV123",
    xp_gain: GENERIC_DEFIS[0].xp_gain,
  });

  console.log("\n🎉 Seed terminé avec succès !");
}

seed();
