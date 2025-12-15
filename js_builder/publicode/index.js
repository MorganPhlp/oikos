import Engine from 'publicodes'

let engine = null;

// --- 1. INITIALISATION ---
globalThis.initEngine = (rulesJsonString) => {
  try {
    console.log("JS: Initialisation du moteur...");
    const rules = JSON.parse(rulesJsonString);
    
    // 👇 LA CORRECTION POUR LES LOGS EST ICI
    engine = new Engine(rules, {
      logger: {
        log: (_) => {},  // Ignorer les logs
        warn: (_) => {}, // Ignorer les avertissements (Cycles, etc.)
        error: (s) => console.error(s), // Garder les vraies erreurs
      }
    });
    
    return JSON.stringify({ status: "success" });
  } catch (e) {
    return JSON.stringify({ status: "error", message: e.message });
  }
};

// --- 2. METTRE À JOUR LA SITUATION ---
globalThis.updateSituation = (situationJsonString) => {
  if (!engine) return JSON.stringify({ status: "error", message: "Engine not initialized" });
  
  try {
    // Le Dart nous envoie TOUTE la situation accumulée
    const situation = JSON.parse(situationJsonString);
    
    // Nettoyage basique (optionnel si Dart gère bien les nulls)
    const cleanSituation = {};
    Object.keys(situation).forEach(key => {
        if (situation[key] !== null && situation[key] !== undefined) {
            cleanSituation[key] = situation[key];
        }
    });
    
    engine.setSituation(cleanSituation);
    return JSON.stringify({ status: "updated" });
  } catch (e) {
    return JSON.stringify({ status: "error", message: e.message });
  }
};


// --- 3. CHECK APPLICABILITY (Ta logique) ---
globalThis.checkApplicability = (target) => {
    if (!engine) return "[]";
    try {
        // On évalue la cible (ex: "bilan")
        const result = engine.evaluate(target);
        // On renvoie les clés des variables manquantes
        return JSON.stringify(Object.keys(result.missingVariables || {}));
    } catch (e) {
        console.error("JS Error checkApplicability: " + e.message);
        return "[]";
    }
}

// --- 4. CALCUL ---
globalThis.getBilan = (targetObjective) => {
    if (!engine) return "0";
    try {
        const result = engine.evaluate(targetObjective);
        return JSON.stringify(result.nodeValue);
    } catch (e) {
        return "0";
    }
}