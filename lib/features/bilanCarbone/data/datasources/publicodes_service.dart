import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class PublicodesService implements SimulationRepository {
  late JavascriptRuntime _flutterJs;
  bool _isInitialized = false;

  //  MÉMOIRE : On garde l'historique de toutes les réponses ici
  // Sinon Publicodes oublie les réponses précédentes à chaque update
  final Map<String, dynamic> _accumulatedSituation = {
  };

  // --- 1. INITIALISATION ---
  @override
  Future<void> init() async {
    if (_isInitialized) return;

    _flutterJs = getJavascriptRuntime();
    
    // 1. Charger le moteur JS (le bundle)
    // On suppose que ce fichier contient le code de index.js ci-dessous
    String bundle = await rootBundle.loadString('assets/js/publicodes_bundle.js');
    _flutterJs.evaluate(bundle);

    // 2. Charger les règles JSON
    String rules = await rootBundle.loadString('assets/data/rules.json');
    
    // On passe les règles au moteur. 
    // On utilise jsonEncode pour que le string Dart devienne un string JS valide.
    final result = _flutterJs.evaluate('initEngine(${jsonEncode(rules)})');
    
    if (result.isError) {
      print("❌ Erreur Init Publicodes: ${result.stringResult}");
    } else {
      print("✅ Moteur Publicodes initialisé.");
    }

    // 3. Initialiser la situation de départ
    _envoyerSituationAuMoteur();
    
    _isInitialized = true;
  }

  // --- 2. MISE À JOUR ---
  @override
  void updateSituation(Map<String, dynamic> nouvelleReponse) {
    // A. On fusionne la nouvelle réponse avec l'historique
    _accumulatedSituation.addAll(nouvelleReponse);

    // B. On envoie TOUT l'historique au moteur
    //_envoyerSituationAuMoteur();
  }

void _envoyerSituationAuMoteur() {
    // 1. On encode la Map en JSON 
    String jsonSituation = jsonEncode(_accumulatedSituation);
    
    // 2.  Échapper les guillemets (") pour que le JSON reste intact 
    // lorsqu'il est inséré dans les guillemets de la commande JS.
    String safeJson = jsonSituation.replaceAll('"', '\\"');

    // 3. 🎯 L'ENVOI CORRECT : On utilise la chaîne safeJson comme argument
    String command = 'globalThis.updateSituation("$safeJson")';
    
    // 4. Appel JS sécurisé
    final result = _flutterJs.evaluate(command);
    
    print("\n\nSituation envoyée (Raw JSON) : $jsonSituation\n\n");
    if (result.isError) {
      print("❌ Erreur JS : ${result.stringResult}");
    }
  }

  @override
  bool isQuestionApplicable(String questionSlug) {
    if (!_isInitialized) return true; // Par défaut on affiche si pas prêt

    // On demande les variables manquantes pour l'objectif "bilan"
    final result = _flutterJs.evaluate('checkApplicability("bilan")');
    
    if (result.isError) {
      print("Erreur JS checkApplicability: ${result.stringResult}");
      return true; 
    }

    // Récupération de la liste brute ["logement . chauffage", ...]
    List<dynamic> variablesManquantes = jsonDecode(result.stringResult);
    printlong(  "Variables manquantes pour 'bilan' : $variablesManquantes");
    return variablesManquantes.any((variable) {
      String v = variable.toString();
      
      // 1. Correspondance Exacte
      if (v == questionSlug) return true;

      // 2. Correspondance Mosaïque 
      if (v.startsWith("$questionSlug .")) return true;

      return false;
    });
  }

  void printlong(String text) {
    final pattern = RegExp('.{1,800}'); // 800 caractères par segment
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  @override
    Map<String, dynamic> getAccumulatedSituation() {
        // Retourne la Map Dart qui stocke toutes les réponses.
        return _accumulatedSituation; 
    }

  void dispose() {
    _flutterJs.dispose();
  }
}