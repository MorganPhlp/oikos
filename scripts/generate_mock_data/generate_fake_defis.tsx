import { SupabaseClient } from "@supabase/supabase-js";

const TARGET_USER_EMAIL = "chloe.robert@viveris.fr";

export async function generateFakeDefis(
  userIds: string[],
  supabase: SupabaseClient,
) {
  console.log("🏆 Génération des défis 'Seuil Critique' pour Chloé Robert...");

  const categories = [
    "Alimentation",
    "Transport",
    "Logement",
    "Numérique",
    "Divers",
  ];
  const communautes = ["VIV123", "VIV456", "VIV789"];

  // 1. Récupérer les infos de Chloé
  const { data: chloe } = await supabase
    .from("utilisateur")
    .select("id, code_communaute")
    .eq("email", TARGET_USER_EMAIL)
    .single();

  if (!chloe) {
    console.error("❌ Chloé Robert introuvable pour le seuil critique.");
    return;
  }

  // Exclure Chloé du pool de votes/participations automatiques
  const otherUserIds = userIds.filter((id) => id !== chloe.id);
  const { data: memberStats } = await supabase
    .from("vue_communaute_stats")
    .select("code, nb_membres");

  for (let i = 0; i < communautes.length; i++) {
    const c1 = communautes[i];
    const c2 = communautes[(i + 1) % communautes.length];
    const estDansCommu1 = chloe.code_communaute === c1;
    const estDansCommu2 = chloe.code_communaute === c2;

    // --- TYPE 1 : DÉFI EN ATTENTE DE VOTES (VOTE_LANCEMENT) ---
    // Le but : Chloé vote et le défi devient ACTIF
    const { data: defiVote } = await supabase
      .from("defi")
      .insert({
        titre_personnalise: `Vote Décisif ${c1} vs ${c2}`,
        createur_id: otherUserIds[0],
        communaute_demandeur_code: c1,
        communaute_cible_code: c2,
        categorie_nom: categories[i % categories.length],
        status: "VOTE_LANCEMENT",
        date_fin: new Date(Date.now() + 7 * 24 * 3600 * 1000).toISOString(),
      })
      .select()
      .single();

    if (defiVote) {
      const quorum1 = Math.ceil(
        (memberStats?.find((m) => m.code === c1)?.nb_membres || 0) * 0.6,
      );
      const quorum2 = Math.ceil(
        (memberStats?.find((m) => m.code === c2)?.nb_membres || 0) * 0.6,
      );

      // On remplit à Quorum - 1 si Chloé est dans la commu, sinon on remplit le Quorum
      const n1 = estDansCommu1 ? quorum1 - 1 : quorum1;
      const n2 = estDansCommu2 ? quorum2 - 1 : quorum2;

      await fillVotes(defiVote.id, otherUserIds, c1, n1, c2, n2, supabase);
      console.log(
        `  🗳️ Défi Vote créé : ${c1}(${n1}/${quorum1}) vs ${c2}(${n2}/${quorum2})`,
      );
    }

    // --- TYPE 2 : DÉFI ACTIF EN ATTENTE DE PARTICIPATION (ACTIF) ---
    // Le but : Chloé participe et le défi se termine (ou progresse)
    if (estDansCommu1 || estDansCommu2) {
      const { data: action } = await supabase
        .from("actions")
        .select("id")
        .limit(1)
        .single();

      const { data: defiActif } = await supabase
        .from("defi")
        .insert({
          titre_personnalise: ``,
          createur_id: otherUserIds[1],
          communaute_demandeur_code: c1,
          communaute_cible_code: c2,
          categorie_nom: categories[(i + 1) % categories.length],
          action_id: action?.id,
          status: "ACTIF",
          date_fin: new Date(Date.now() + 14 * 24 * 3600 * 1000).toISOString(),
        })
        .select()
        .single();

      if (defiActif) {
        const targetCommu = estDansCommu1 ? c1 : c2;
        const membersCount =
          memberStats?.find((m) => m.code === targetCommu)?.nb_membres || 0;
        const threshold = Math.ceil(membersCount * 0.6);
        const nParticipation = threshold - 1;

        await fillParticipation(
          defiActif.id,
          otherUserIds,
          targetCommu,
          nParticipation,
          supabase,
        );
        console.log(
          `  🔥 Défi Actif créé : Chloé doit être la ${threshold}ème personne de ${targetCommu}`,
        );
      }
    }
  }
}

async function fillVotes(
  defiId: string,
  userIds: string[],
  c1: string,
  n1: number,
  c2: string,
  n2: number,
  supabase: SupabaseClient,
) {
  const { data: users } = await supabase
    .from("utilisateur")
    .select("id, code_communaute")
    .in("id", userIds);
  if (!users) return;

  const votes = [];
  const participantsC1 = users
    .filter((u) => u.code_communaute === c1)
    .slice(0, n1);
  const participantsC2 = users
    .filter((u) => u.code_communaute === c2)
    .slice(0, n2);

  for (const u of [...participantsC1, ...participantsC2]) {
    votes.push({ defi_id: defiId, user_id: u.id, est_favorable: true });
  }
  if (votes.length > 0)
    await supabase.from("votes_lancement_defi").insert(votes);
}

async function fillParticipation(
  defiId: string,
  userIds: string[],
  commu: string,
  n: number,
  supabase: SupabaseClient,
) {
  const { data: users } = await supabase
    .from("utilisateur")
    .select("id")
    .eq("code_communaute", commu)
    .in("id", userIds);
  if (!users) return;

  const participations = users.slice(0, n).map((u) => ({
    defi_id: defiId,
    user_id: u.id,
  }));
  if (participations.length > 0)
    await supabase.from("defi_participation").insert(participations);
}
