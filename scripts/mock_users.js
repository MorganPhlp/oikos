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

function buildEmail(prenom, nom) {
  return `${prenom.toLowerCase()}.${nom.toLowerCase()}@viveris.fr`;
}

function buildPseudo(prenom, nom) {
  return `${prenom}${nom}`;
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

  // 3. Utilisateurs
  console.log(`\n👥 Création des ${USERS.length} utilisateurs...`);
  const createdUsers = [];
  for (const user of USERS) {
    const userRes = await createUser(user, VIVERIS_ID);
    if (userRes) createdUsers.push({ ...userRes, ...user });
  }
}

seed();
