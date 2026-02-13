import { createClient } from '@supabase/supabase-js'
import Engine from 'publicodes'
import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'
import 'dotenv/config'


// --- CONFIGURATION ---
const SUPABASE_URL = process.env.SUPABASE_JS_URL
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY
const supabase = createClient(SUPABASE_URL, SUPABASE_KEY)

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)
const rulesPath = path.join(__dirname, '..', 'assets', 'data', 'rules.json')


const TARGET_QUESTIONS = [
    ["logement . type", '🏠','obligatoire'],
    ["logement . surface", '📏', 'obligatoire'],
    ["logement . propriétaire", '🔑', 'obligatoire'],
    ["logement . habitants", '👥','obligatoire'],
    ["logement . chauffage", '🔥','obligatoire'],
    ["logement . chauffage . précision consommation . ressenti", '🌡️','obligatoire'],
    ["transport . voiture . utilisateur", '🚗','obligatoire'],
    ["transport . voiture . km", '⛽','obligatoire'],
    ["transport . voiture . motorisation", '🔧','obligatoire'],
    ["transport . mobilité douce", '🚲','obligatoire'],
    ["transport . avion . usager", '✈️','obligatoire'],
    ["transport . avion . moyen courrier . heures de vol", '🕒','obligatoire'],
    ["alimentation . plats", '🍽️','obligatoire'],
    ["alimentation . boisson . eau en bouteille . consommateur", '💧','obligatoire'],
    ["divers . numérique . appareils", '💻','obligatoire'],
    ["divers . textile . volume", '🛍️','obligatoire'],
    ["logement . âge", '🏚️','optionnelle'],
    ["logement . vacances", '🏖️','optionnelle'],
    ["alimentation . petit déjeuner . type", '🥐','optionnelle'],
    ["alimentation . local . consommation", '🌍','optionnelle'],
    ["alimentation . de saison . consommation", '🍓','optionnelle'],
    ["alimentation . boisson . chaudes . consommation", '☕','optionnelle'],
    ["alimentation . boisson . sucrées . litres", '🥤','optionnelle'],
    ["alimentation . boisson . alcool . litres", '🍷','optionnelle'],
    ["alimentation . déchets . quantité jetée", '🗑️','optionnelle'],
    ["transport . voiture . gabarit", '🚙','optionnelle'],
    ["transport . voiture . thermique . carburant", '⛽','optionnelle'],
    ["divers . animaux domestiques . empreinte", '🐶','optionnelle'],
    ["divers . loisirs . culture", '🎭','optionnelle'],
    ["divers . loisirs . sports", '⚽','optionnelle'],
    ["divers . numérique . appareils . renouvellement téléphone", '📱','optionnelle'],
    ["divers . tabac . consommation par semaine", '🚬','optionnelle'],
];

const dependancies = {

    "transport . voiture . km": [
        {
            key: "transport . voiture . utilisateur",
            value: ["propriétaire", "régulier non propriétaire", "non régulier"],
            type: "IN",
        },
    ],

    "transport . voiture . motorisation": [
        {
            key: "transport . voiture . utilisateur",
            value: ["propriétaire", "régulier non propriétaire"],
            type: "IN",
        },
    ],

    "transport . avion . moyen courrier . heures de vol": [
        {
            key: "transport . avion . usager",
            value: "oui",
            type: "EQUAL",
        },
    ],

    "transport . voiture . thermique . carburant": [
        {
            key: "transport . voiture . motorisation",
            value: "thermique",
            type: "EQUAL",
        },
    ],

    "transport . voiture . gabarit": [
        {
            key: "transport . voiture . utilisateur",
            value: ["propriétaire", "régulier non propriétaire"],
            type: "IN",
        },
    ],
};

const limites = {
    "alimentation . plats": {"min": 0, "max": 14},
}

// --- 1. DÉTECTION STRUCTURELLE (SANS REGEX) ---
function determineWidgetType(rule) {
    const raw = rule.rawNode

    // A. MOSAÏQUES
    if (raw.mosaique) {
        if (raw.mosaique.type === 'selection') return 'CHOIX_MULTIPLE'
        return 'COMPTEUR' // type: 'nombre' par défaut dans les mosaïques NGC
    }

    // B. LISTES DE CHOIX
    if (raw['une possibilité']) {
        // Petite sécu : si la liste est explicitement ['oui', 'non'], on le marque en booléen
        // pour avoir des switchs UI au lieu de radio buttons, mais ce n'est pas obligatoire.
        const options = raw['une possibilité']
        if (options.includes('oui') && options.includes('non')) return 'BOOLEEN'
        
        return 'CHOIX_UNIQUE'
    }

    // C. NOMBRES (Détection par contraintes mathématiques)
    // Si une variable a un min (plancher), un max (plafond) OU une unité, c'est FORCÉMENT un nombre.
    if (raw.plancher !== undefined || raw.plafond !== undefined || raw.unité !== undefined) {
        return 'NOMBRE'
    }


    // D. BOOLEEN (Par élimination)
    // Une question qui n'est ni une liste, ni un nombre borné/unité, est une variable d'activation.
    // Ex: "transport . avion . usager" n'a pas d'unité (pas de km, pas de kg), c'est juste un état.
    return 'BOOLEEN'
}

// --- 2. CONSTRUCTION CONFIG ---
function buildConfigJson(slug,rule, widgetType) {
    const raw = rule.rawNode
    const config = {}

    // Options standards
    if (raw['une possibilité']) config.options = raw['une possibilité']
    if (raw.mosaique && raw.mosaique.options) config.options = raw.mosaique.options

    // Si on a déduit que c'est un booléen (par élimination) mais qu'il n'y a pas d'options,
    // on injecte les valeurs attendues par Publicodes.
    if (widgetType === 'BOOLEEN' && !config.options) {
        config.options = ['oui', 'non']
    }

    // Contraintes numériques
    if (raw.plancher !== undefined) config.min = raw.plancher
    if (raw.plafond !== undefined) config.max = raw.plafond
    if (raw['par défaut']) config.defaultValue = raw['par défaut']
    if (raw.unité) config.unit = raw.unité
    
    // Textes
    if (raw.description) config.description = raw.description
    if (raw.note) config.note = raw.note

    //dependances
    if (dependancies[slug]) {
        console.log("   -> with dependancies")
        config.dependances = dependancies[slug]
    }

    //limites
    if (limites[slug]) {
        console.log("   -> with limites")
        config.min = limites[slug].min
        config.max = limites[slug].max
    }
    //chargement suggestions
    if (raw.mosaique && raw.mosaique.suggestions) {
        config.suggestions = raw.mosaique.suggestions
    }
    else{
        if (raw.suggestions) {
            config.suggestions = raw.suggestions
        }
    }


    return config
}

async function run() {
    console.log("⏳ Chargement du modèle...")
    const jsonRules = fs.readFileSync(rulesPath, 'utf-8')
    const rules = JSON.parse(jsonRules)
    const engine = new Engine(rules)
    const parsedRules = engine.getParsedRules()

    console.log("🛠️ Transformation...")
    const records = []

    for (const [index,item] of TARGET_QUESTIONS.entries()) {
        const [slug, icon, obligatoire] = item
        const rule = parsedRules[slug]
        
        if (!rule) {
            console.warn(`⚠️ Règle introuvable : ${slug}`)
            continue
        }

        const widgetType = determineWidgetType(rule) 
        const category = slug.split(' . ')[0] 
        const raw = rule.rawNode

        records.push({
            slug: slug,
            categorie_empreinte: category,
            question: raw.question || raw.titre || slug,
            icone: icon || raw.icone || null,
            type_widget: widgetType,
            config_json: buildConfigJson(slug,rule, widgetType),
            ordre_affichage: index + 1,
            est_obligatoire: obligatoire === 'obligatoire',
        })
        
        // Affichage log
        console.log(`   🔹 ${slug.padEnd(40)} -> ${widgetType}`)
    }

    console.log(`📤 Upsert de ${records.length} questions...`)

    const { error } = await supabase
        .from('question_bilan')
        .upsert(records, { onConflict: 'slug' })

    if (error) console.error("❌ Erreur :", error)
    else console.log("✅ Succès !")
}

run()