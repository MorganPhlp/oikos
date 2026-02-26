import { SupabaseClient } from "@supabase/supabase-js";

async function getOrCreateBilanId(userId: string, supabase: SupabaseClient): Promise<string | null> {
  const { data: existing } = await supabase
    .from("bilan_carbone")
    .select("id")
    .eq("utilisateur_id", userId)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (existing) return existing.id;

  const { data: created, error } = await supabase
    .from("bilan_carbone")
    .insert({
      utilisateur_id: userId,
      scoretotalco2ean: 0,
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

function checkDependencies(question: any, currentAnswers: Record<string, any>): boolean {
  const deps = question.config_json.dependances;
  if (!deps || !Array.isArray(deps) || deps.length === 0) return true;

  return deps.every((dep: any) => {
    const parentSlug = dep.question;
    const parentAnswer = currentAnswers[parentSlug];
    if (!parentAnswer) return false;

    if (dep.value !== undefined) {
      const requiredValue = String(dep.value).replace(/^'|'$/g, "");
      const actualValue = String(parentAnswer.value).replace(/^'|'$/g, "");
      return actualValue === requiredValue;
    }
    const val = parentAnswer.value;
    return val !== "non" && val !== 0 && val !== false && val !== "0";
  });
}

function generateAnswer(question: any): any {
  const config = question.config_json;
  if (config.min !== undefined && config.max !== undefined) {
    return { value: Math.floor(Math.random() * (config.max - config.min + 1)) + config.min, type: "scale" };
  }
  if (config.options && Array.isArray(config.options)) {
    const selected = config.options[Math.floor(Math.random() * config.options.length)];
    return {
      value: typeof selected === "object" ? selected.value : selected,
      label: typeof selected === "object" ? selected.label : selected,
      type: "choice",
    };
  }
  return { value: config.defaultValue !== undefined ? config.defaultValue : 0, type: "fallback" };
}

async function genFakeResults(bilanId: string, supabase: SupabaseClient) {
  const details = {
    id: bilanId,
    transport: parseFloat((Math.random() * 2000 + 500).toFixed(2)),
    alimentation: parseFloat((Math.random() * 2000 + 1000).toFixed(2)),
    logement: parseFloat((Math.random() * 1500 + 400).toFixed(2)),
    divers: parseFloat((Math.random() * 1000 + 200).toFixed(2)),
    services_societaux: 1450.9,
  };
  const total = Object.values(details).reduce((acc: number, val) => typeof val === "number" ? acc + val : acc, 0);
  await supabase.from("detail_bilan").insert(details);
  await supabase.from("bilan_carbone").update({ scoretotalco2ean: total, complet: true }).eq("id", bilanId);
  return total;
}

export async function addFakeBilan(userId: string, supabase: SupabaseClient) {
  const bilanId = await getOrCreateBilanId(userId, supabase);
  if (!bilanId) return;

  const { data: questions } = await supabase.from("question_bilan").select("id, slug, config_json").order("id", { ascending: true });
  if (!questions) return;

  const reponsesParSlug: Record<string, any> = {};
  const bilanData: any[] = [];

  for (const q of questions) {
    if (checkDependencies(q, reponsesParSlug)) {
      const answer = generateAnswer(q);
      reponsesParSlug[q.slug] = answer;
      bilanData.push({ bilan_id: bilanId, question_id: q.id, valeur: answer });
    }
  }

  await supabase.from("reponse_utilisateur").delete().eq("bilan_id", bilanId);
  await supabase.from("reponse_utilisateur").insert(bilanData);
  await genFakeResults(bilanId, supabase);
}