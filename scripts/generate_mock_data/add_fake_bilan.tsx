import { createClient } from "@supabase/supabase-js";
import "dotenv/config";

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_ANON_KEY!,
);

async function getOrCreateBilanId(userId: string): Promise<string | null> {
  // 1. On cherche un bilan existant (Correction typo: bilan_carbone)
  const { data: existing } = await supabase
    .from("bilan_carbone")
    .select("id")
    .eq("utilisateur_id", userId)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (existing) return existing.id;

  // 2. Sinon on le crée (Correction: on met un score par défaut à 0 pour la contrainte NOT NULL)
  const { data: created, error } = await supabase
    .from("bilan_carbone")
    .insert({
      utilisateur_id: userId,
      scoretotalco2ean: 0, // Respect de la contrainte NOT NULL
      complet: false,
    })
    .select("id")
    .single();

  if (error) {
    console.error("❌ Erreur création bilan_carbone:", error.message);
    return null;
  }
  return created.id;
}

/**
 * Vérifie si les dépendances d'une question sont satisfaites via les Slugs.
 * @param question L'objet question contenant le config_json
 * @param currentAnswers Le dictionnaire des réponses déjà générées { [slug]: { value: ... } }
 */
function checkDependencies(
  question: any,
  currentAnswers: Record<string, any>,
): boolean {
  const deps = question.config_json.dependances;

  // S'il n'y a pas de dépendances, la question est toujours affichée
  if (!deps || !Array.isArray(deps) || deps.length === 0) {
    return true;
  }

  // On vérifie que TOUTES les dépendances (every) sont satisfaites
  return deps.every((dep: any) => {
    // Dans le JSON, la clé de la dépendance est 'question' (qui contient le slug)
    const parentSlug = dep.question;
    const parentAnswer = currentAnswers[parentSlug];

    if (!parentAnswer) {
      return false;
    }

    if (dep.value !== undefined) {
      const requiredValue = String(dep.value).replace(/^'|'$/g, "");
      const actualValue = String(parentAnswer.value).replace(/^'|'$/g, "");

      return actualValue === requiredValue;
    }

    const val = parentAnswer.value;
    return val !== "non" && val !== 0 && val !== false && val !== "0";
  });
}
async function getQuestions() {
  const { data, error } = await supabase
    .from("question_bilan")
    .select("id, slug, config_json")
    .order("id", { ascending: true }); // Crucial pour l'ordre des dépendances

  if (error) {
    console.error(
      "❌ Erreur lors de la récupération des questions :",
      error.message,
    );
    return [];
  }

  return data;
}

async function genFakeAnswers(bilanId: string, nbToDrop: number) {
  const questions = await getQuestions();
  const reponsesParSlug: Record<string, any> = {};
  const bilanData: any[] = [];

  for (const q of questions) {
    if (checkDependencies(q, reponsesParSlug)) {
      const answer = generateAnswer(q);
      reponsesParSlug[q.slug] = answer;

      bilanData.push({
        bilan_id: bilanId,
        question_id: q.id,
        valeur: answer, // Nom de colonne corrigé
      });
    }
  }

  const maxDrop = Math.max(0, bilanData.length - 17);
  return bilanData.slice(0, bilanData.length - Math.min(nbToDrop, maxDrop));
}
/**
 * Génère une réponse aléatoire mais valide en fonction de la configuration de la question.
 * @param question L'objet question contenant le config_json
 */
function generateAnswer(question: any): any {
  const config = question.config_json;

  // 1. Cas : Échelle numérique (ex: Surface en m2, nombre d'habitants)
  if (config.min !== undefined && config.max !== undefined) {
    const min = config.min;
    const max = config.max;

    // Génération d'un entier entre min et max
    const val = Math.floor(Math.random() * (max - min + 1)) + min;

    return {
      value: val,
      type: "scale",
    };
  }

  // 2. Cas : Choix multiples (Options)
  if (config.options && Array.isArray(config.options)) {
    const randomIndex = Math.floor(Math.random() * config.options.length);
    const selected = config.options[randomIndex];

    // Certaines options sont des objets { value, label }, d'autres des strings directes
    return {
      value: typeof selected === "object" ? selected.value : selected,
      label: typeof selected === "object" ? selected.label : selected,
      type: "choice",
    };
  }

  // 3. Fallback : Valeur par défaut si la config est incomplète ou différente
  // On utilise la defaultValue de la config si elle existe, sinon 0
  return {
    value: config.defaultValue !== undefined ? config.defaultValue : 0,
    type: "fallback",
  };
}

/**
 * Calcule et insère les scores
 */
async function genFakeResults(bilanId: string) {
  const details = {
    id: bilanId,
    transport: parseFloat((Math.random() * 2000 + 500).toFixed(2)),
    alimentation: parseFloat((Math.random() * 2000 + 1000).toFixed(2)),
    logement: parseFloat((Math.random() * 1500 + 400).toFixed(2)),
    divers: parseFloat((Math.random() * 1000 + 200).toFixed(2)),
    services_societaux: 1450.9,
  };

  const total = Object.values(details).reduce((acc: number, val) => {
    return typeof val === "number" ? acc + val : acc;
  }, 0);

  // Insertion détails
  const { error: errD } = await supabase.from("detail_bilan").insert(details);
  if (errD) console.error("❌ Erreur detail_bilan:", errD.message);

  // Mise à jour score total (Correction nom colonne: scoretotalco2ean)
  await supabase
    .from("bilan_carbone")
    .update({ scoretotalco2ean: total, est_termine: true })
    .eq("id", bilanId);
  // maj du bilan
  await supabase
    .from("bilan_carbone")
    .update({ scoretotalco2ean: total, complet: true })
    .eq("id", bilanId);

  return total;
}

// --- MAIN ---

export async function addFakeBilan(userId: string) {
  console.log(`🚀 Début pour ${userId}`);

  const bilanId = await getOrCreateBilanId(userId);
  if (!bilanId) return;

  const answers = await genFakeAnswers(bilanId, 5);

  // Clean des anciennes réponses pour éviter les doublons lors des tests
  await supabase.from("reponse_utilisateur").delete().eq("bilan_id", bilanId);

  const { error: errIns } = await supabase
    .from("reponse_utilisateur")
    .insert(answers);

  if (errIns) {
    console.error("❌ Erreur insertion réponses:", errIns.message);
  } else {
    const total = await genFakeResults(bilanId);
    console.log(`✅ Succès ! `);
  }
}

addFakeBilan("04971e49-2ced-4dc7-bcba-03afc3055771");
