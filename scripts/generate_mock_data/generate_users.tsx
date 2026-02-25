// Mot de passe par défaut
const PASSWORD = "Password123!";

const USERS_INPUT: UserInput[] = [
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

type UserInput = {
  prenom: string;
  nom: string;
  community: string;
};

// Structure de l'objet final
interface GeneratedUser {
  email: string;
  pseudo: string;
  password: string;
  code_communaute: string;
}

function buildEmail(prenom: string, nom: string): string {
  return `${prenom.toLowerCase()}.${nom.toLowerCase()}@viveris.fr`;
}

function buildPseudo(prenom: string, nom: string): string {
  return `${prenom}.${nom}`;
}

/**
 * Transforme un UserInput en objet User complet
 */
function generateUserData(user: UserInput): GeneratedUser {
  return {
    email: buildEmail(user.prenom, user.nom),
    pseudo: buildPseudo(user.prenom, user.nom),
    password: PASSWORD,
    code_communaute: user.community,
  };
}

export function getGeneratedUsers(): GeneratedUser[] {
  console.log(`🛠️ Génération de ${USERS_INPUT.length} utilisateurs...`);

  const userList = USERS_INPUT.map((user) => generateUserData(user));

  console.log("✨ Liste générée avec succès.");
  return userList;
}

console.log(getGeneratedUsers());
