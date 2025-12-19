import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class PublicodesService implements SimulationRepository {
  final Map<String, dynamic> _accumulatedSituation = {};
  String? _cachedBundle;
  String? _cachedRules;
  bool _isInitialized = false;

  @override
  Future<void> init() async {
    if (_isInitialized) return;

    // On charge les fichiers en mémoire une seule fois
    _cachedBundle = await rootBundle.loadString('assets/js/publicodes_bundle.js');
    _cachedRules = await rootBundle.loadString('assets/data/rules.json');

    _isInitialized = true;
    print("✅ PublicodesService prêt (Assets chargés)");
  }

  @override
  void updateSituation(Map<String, dynamic> nouvelleReponse) {
    _accumulatedSituation.addAll(nouvelleReponse);
  }

  @override
  Map<String, dynamic> getAccumulatedSituation() => _accumulatedSituation;

  @override
  Future<double> getScore({String objective = "bilan"}) async {
    if (!_isInitialized) return 0.0;

    // On lance le calcul dans un thread séparé
    return await Isolate.run(() => _computeScore(
          bundle: _cachedBundle!,
          rules: _cachedRules!,
          situation: Map.from(_accumulatedSituation), // Copie pour thread-safety
          objective: objective,
        ));
  }

  @override
  Future<bool> isQuestionApplicable(String questionSlug) async {
    if (!_isInitialized) return true;

    // On lance la vérification dans un thread séparé
    return await Isolate.run(() => _computeApplicability(
          bundle: _cachedBundle!,
          rules: _cachedRules!,
          situation: Map.from(_accumulatedSituation),
          questionSlug: questionSlug,
        ));
  }

  // --- FONCTIONS DE CALCUL (S'exécutent dans l'Isolate) ---

  static double _computeScore({
    required String bundle,
    required String rules,
    required Map<String, dynamic> situation,
    required String objective,
  }) {
    final js = getJavascriptRuntime();
    try {
      _setupEngine(js, bundle, rules, situation);
      
      final result = js.evaluate("getBilan(${jsonEncode(objective)})");
      if (result.isError) return 0.0;

      final cleanValue = result.stringResult.replaceAll('"', '');
      return double.tryParse(cleanValue) ?? 0.0;
    } finally {
      js.dispose(); // Libère la mémoire de l'Isolate
    }
  }

  static bool _computeApplicability({
    required String bundle,
    required String rules,
    required Map<String, dynamic> situation,
    required String questionSlug,
  }) {
    final js = getJavascriptRuntime();
    try {
      _setupEngine(js, bundle, rules, situation);

      final result = js.evaluate('checkApplicability("bilan")');
      if (result.isError) return true;

      List<dynamic> missing = jsonDecode(result.stringResult);
      return missing.any((v) => 
        v.toString() == questionSlug || v.toString().startsWith("$questionSlug .")
      );
    } finally {
      js.dispose();
    }
  }

  /// Helper interne pour initialiser le moteur dans chaque Isolate
  static void _setupEngine(JavascriptRuntime js, String bundle, String rules, Map situation) {
    js.evaluate(bundle);
    js.evaluate('initEngine(${jsonEncode(rules)})');
    
    if (situation.isNotEmpty) {
      String jsonSituation = jsonEncode(situation);
      String safeJson = jsonSituation.replaceAll('"', '\\"');
      js.evaluate('globalThis.updateSituation("$safeJson")');
    }
  }
}