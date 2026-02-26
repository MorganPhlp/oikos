import { createClient } from "@supabase/supabase-js";
import "dotenv/config";

const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_ANON_KEY!,
);

const NOMBRE_ACTIONS_QUOTIDIENNES = 5;
const NOMBRE_ACTIONS_HEBDOMADAIRES = 3;
const NOMBRE_ACTIONS_MENSUELLES = 3;
const NOMBRE_ACTIONS_BONUS = 1;

const NOMBRE_REALISATIONS_QUOTIDIENNES = [6, 5, 6, 3, 2];
const NOMBRE_REALISATIONS_HEBDOMADAIRES = [5, 4, 3];
const NOMBRE_REALISATIONS_MENSUELLES = [3, 1, 0];

const

    enum RealiserActionType {
    QUOTIDIENNE = 'quotidienne',
    HEBDOMADAIRE = 'hebdomadaire',
    MENSUELLE = 'mensuelle',
    BONUS = 'bonus'
}

interface Action {
    id: string;
    categorie_nom: string;
    titre: string;
    description: string;
    difficulte: string;
    impact_score: number;
    icon_name: string;
    tips: string[];
    frequence: RealiserActionType;
    tags: string[];
}

async function getActions(type: RealiserActionType) {
    const actions = await supabase.from('actions')
        .select('*')
        .eq('frequence', type)
        .then(({ data, error }) => {
            if (error) {
                console.error(`Erreur récupération actions ${type}:`, error.message);
                return [];
            }
            return data as Action[];
        });
    return actions;
}

async function ajouterActionToUserActionEnCours(userId: string, actionId: string) {
    await supabase.from('actions_en_cours')
        .insert({
            utilisateur_id: userId,
            action_id: actionId,
        })

}

async function setDernierResetToInfinity(userId: string) {
    await supabase.from('actions_en_cours')
        .update({ date_dernier_reset: '-infinity' })
        .eq('utilisateur_id', userId);

}

async function realiserAction(userId: string, action: Action, quantity: number) {
    const now = Date.now();

    for (let i = 1; i < quantity + 1; i++) {
        let gap = 0;
        if (action.frequence === RealiserActionType.QUOTIDIENNE) gap = i * 24 * 3600 * 1000;
        else if (action.frequence === RealiserActionType.HEBDOMADAIRE) gap = i * 7 * 24 * 3600 * 1000;
        else if (action.frequence === RealiserActionType.MENSUELLE) gap = i * 30 * 24 * 3600 * 1000;

        const dateISO = new Date(now - gap).toISOString();

        const { error } = await supabase.from('realisation_actions').insert({
            utilisateur_id: userId,
            action_id: action.id,
            date_realisation: dateISO,
        });

        if (error) {
            console.error(`❌ Erreur réalisation pour ${action.titre}:`, error.message);
        } else {
            console.log(`✅ Réalisation insérée pour ${action.titre} à la date ${dateISO}`);
        }
    }
}
export async function setMockRealiserActions(userId: string) {
    const actionsQuotidiennes = await getActions(RealiserActionType.QUOTIDIENNE);
    const actionsHebdomadaires = await getActions(RealiserActionType.HEBDOMADAIRE);
    const actionsMensuelles = await getActions(RealiserActionType.MENSUELLE);
    const actionsBonus = await getActions(RealiserActionType.BONUS);

    for (let i = 0; i < NOMBRE_ACTIONS_QUOTIDIENNES; i++) {
        await ajouterActionToUserActionEnCours(userId, actionsQuotidiennes[i].id);
        await realiserAction(userId, actionsQuotidiennes[i], NOMBRE_REALISATIONS_QUOTIDIENNES[i]);
    }

    for (let i = 0; i < NOMBRE_ACTIONS_HEBDOMADAIRES; i++) {
        await ajouterActionToUserActionEnCours(userId, actionsHebdomadaires[i].id);
        await realiserAction(userId, actionsHebdomadaires[i], NOMBRE_REALISATIONS_HEBDOMADAIRES[i]);
    }

    for (let i = 0; i < NOMBRE_ACTIONS_MENSUELLES; i++) {
        await ajouterActionToUserActionEnCours(userId, actionsMensuelles[i].id);
        await realiserAction(userId, actionsMensuelles[i], NOMBRE_REALISATIONS_MENSUELLES[i]);
    }

    for (let i = 0; i < NOMBRE_ACTIONS_BONUS; i++) {
        await ajouterActionToUserActionEnCours(userId, actionsBonus[i].id);
        await realiserAction(userId, actionsBonus[i], 1);
    }
    await setDernierResetToInfinity(userId);
}

