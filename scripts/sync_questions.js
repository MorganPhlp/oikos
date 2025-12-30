import { createClient } from '@supabase/supabase-js'
import Engine from 'publicodes'
import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'


// --- CONFIGURATION ---
const SUPABASE_URL = 'https://oppmoxxtebmxbuwkjkgs.supabase.co'
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wcG1veHh0ZWJteGJ1d2tqa2dzIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MzMyOTM1NiwiZXhwIjoyMDc4OTA1MzU2fQ.yKIqMdVpSNG6h1CmlkZTuYRONlLUo68NSthckppgxuM'
const supabase = createClient(SUPABASE_URL, SUPABASE_KEY)

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)
const rulesPath = path.join(__dirname, '..', 'assets', 'data', 'rules.json')


const TARGET_QUESTIONS = [
    ["logement . type", '🏠'],
    ["logement . surface", '📏'],
    ["logement . propriétaire", '🔑'],
    ["logement . habitants", '👥'],
    ["logement . chauffage", '🔥'],
    ["logement . chauffage . précision consommation . ressenti", '🌡️'],
    ["transport . voiture . utilisateur", '🚗'],
    ["transport . voiture . km", '⛽'],
    ["transport . voiture . motorisation", '🔧'],
    ["transport . mobilité douce", '🚲'],
    ["transport . avion . usager", '✈️'],
    ["transport . avion . moyen courrier . heures de vol", '🕒'],
    ["alimentation . plats", '🍽️'],
    ["alimentation . boisson . eau en bouteille . consommateur", '💧'],
    ["divers . numérique . appareils", '💻'],
    ["divers . textile . volume", '🛍️'],
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
};

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
        const [slug, icon] = item
        const rule = parsedRules[slug]
        
        if (!rule) {
            console.warn(`⚠️ Règle introuvable : ${slug}`)
            continue
        }

        const widgetType = determineWidgetType(rule) 
        const category = slug.split(' . ')[0] 
        const raw = rule.rawNode

        records.push({
            id:index,
            slug: slug,
            categorie_empreinte: category,
            question: raw.question || raw.titre || slug,
            icone: icon || raw.icone || null,
            type_widget: widgetType,
            config_json: buildConfigJson(slug,rule, widgetType),
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