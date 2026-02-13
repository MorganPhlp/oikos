import 'dart:async';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

/// Version WEB "Stub" du service Publicodes.
/// Ce service ne lance pas le moteur de calcul (incompatible Web à cause de dart:ffi/Isolates).
/// Il sert uniquement à permettre la compilation de l'app en version Web pour le Reset Password.
class PublicodesService implements SimulationRepository {
  final Map<String, dynamic> _accumulatedSituation = {};

  @override
  Future<void> init() async {
    // On ne charge rien.
    return;
  }

  @override
  void updateSituation(Map<String, dynamic> nouvelleReponse) {
    // On stocke juste la réponse en mémoire locale, sans calcul.
    _accumulatedSituation.addAll(nouvelleReponse);
  }

  @override
  Map<String, dynamic> getAccumulatedSituation() =>
      Map.unmodifiable(_accumulatedSituation);

  @override
  Future<double> getScore({String objective = "bilan"}) async {
    // Retourne 0 par défaut car le moteur n'est pas là
    return 0.0;
  }

  @override
  Future<bool> isQuestionApplicable(String questionSlug) async {
    // On considère tout applicable par défaut pour ne pas bloquer l'UI
    return true;
  }

  @override
  Future<Map<String, double>> computeScoresByCategory() async {
    // Retourne des zéros pour les catégories
    return {
      "alimentation": 0.0,
      "logement": 0.0,
      "transport": 0.0,
      "divers": 0.0,
      "services sociétaux": 0.0,
    };
  }

  Future<void> dispose() async {
    // Rien à nettoyer
  }
}