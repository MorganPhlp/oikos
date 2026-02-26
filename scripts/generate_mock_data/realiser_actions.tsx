import { SupabaseClient } from "@supabase/supabase-js";

const NOMBRE_ACTIONS_QUOTIDIENNES = 5;
const NOMBRE_ACTIONS_HEBDOMADAIRES = 3;
const NOMBRE_ACTIONS_MENSUELLES = 3;
const NOMBRE_ACTIONS_BONUS = 1;

const NOMBRE_REALISATIONS_QUOTIDIENNES = [6, 5, 6, 3, 2];
const NOMBRE_REALISATIONS_HEBDOMADAIRES = [5, 4, 3];
const NOMBRE_REALISATIONS_MENSUELLES = [3, 1, 0];

enum RealiserActionType {
    QUOTIDIENNE = 'quotidienne',
    HEBDOMADAIRE = 'hebdomadaire',
    MENSUELLE = 'mensuelle',
    BONUS = 'bonus'
}

async function realiserAction(userId: string, actionId: string, type: RealiserActionType, quantity: number, supabase: SupabaseClient) {
    const now = Date.now();
    for (let i = 1; i <= quantity; i++) {
        let gap = 0;
        if (type === RealiserActionType.QUOTIDIENNE) gap = i * 24 * 3600 * 1000;
        else if (type === RealiserActionType.HEBDOMADAIRE) gap = i * 7 * 24 * 3600 * 1000;
        else if (type === RealiserActionType.MENSUELLE) gap = i * 30 * 24 * 3600 * 1000;

        await supabase.from('realisation_actions').insert({
            utilisateur_id: userId,
            action_id: actionId,
            date_realisation: new Date(now - gap).toISOString(),
        });
    }
}

export async function setMockRealiserActions(userId: string, supabase: SupabaseClient) {
    const { data: actions } = await supabase.from('actions').select('*');
    if (!actions) return;

    const filter = (t: string) => actions.filter(a => a.frequence === t);

    const process = async (list: any[], counts: number[], type: RealiserActionType) => {
        for (let i = 0; i < Math.min(list.length, counts.length); i++) {
            await supabase.from('actions_en_cours').insert({ utilisateur_id: userId, action_id: list[i].id });
            await realiserAction(userId, list[i].id, type, counts[i], supabase);
        }
    };

    await process(filter('quotidienne'), NOMBRE_REALISATIONS_QUOTIDIENNES, RealiserActionType.QUOTIDIENNE);
    await process(filter('hebdomadaire'), NOMBRE_REALISATIONS_HEBDOMADAIRES, RealiserActionType.HEBDOMADAIRE);
    await process(filter('mensuelle'), NOMBRE_REALISATIONS_MENSUELLES, RealiserActionType.MENSUELLE);

    const bonus = filter('bonus');
    if (bonus.length > 0) {
        await supabase.from('actions_en_cours').insert({ utilisateur_id: userId, action_id: bonus[0].id });
        await realiserAction(userId, bonus[0].id, RealiserActionType.BONUS, 1, supabase);
    }

    await supabase.from('actions_en_cours').update({ date_dernier_reset: '-infinity' }).eq('utilisateur_id', userId);
}