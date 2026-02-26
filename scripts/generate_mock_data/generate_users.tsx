const PASSWORD = "Password123!";

const USERS_INPUT: UserInput[] = [
  { prenom: "Samy", nom: "Scooby", community: "VIV123" },
  { prenom: "Marko", nom: "Polo", community: "VIV123" },
  { prenom: "Julie", nom: "Bernard", community: "VIV123" },
  { prenom: "Eliott", nom: "Martin", community: "VIV123" },
  { prenom: "Jacques", nom: "Bernard", community: "VIV123" },
  { prenom: "Morgan", nom: "Petit", community: "VIV123" },
  { prenom: "Chloe", nom: "Robert", community: "VIV123" },
  { prenom: "Nathan", nom: "Richard", community: "VIV456" },
  { prenom: "Lea", nom: "Durand", community: "VIV456" },
  { prenom: "Enzo", nom: "Moreau", community: "VIV456" },
  { prenom: "Manon", nom: "Simon", community: "VIV456" },
  { prenom: "Louis", nom: "Laurent", community: "VIV789" },
  { prenom: "Camille", nom: "Lefebvre", community: "VIV789" },
  { prenom: "Mathis", nom: "Garcia", community: "VIV789" },
  { prenom: "Sarah", nom: "Garnier", community: "VIV789" },
];

type UserInput = { prenom: string; nom: string; community: string };

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

export function generateUserData(user: UserInput): GeneratedUser {
  return {
    email: buildEmail(user.prenom, user.nom),
    pseudo: buildPseudo(user.prenom, user.nom),
    password: PASSWORD,
    code_communaute: user.community,
  };
}

export function getGeneratedUsers(): GeneratedUser[] {
  return USERS_INPUT.map((user) => generateUserData(user));
}