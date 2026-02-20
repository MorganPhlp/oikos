import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

/// Stub web pour PublicodesService.
/// flutter_js utilise dart:ffi qui n'est pas disponible sur le web.
/// Cette implémentation permet à l'app de compiler sur Chrome
/// même si le moteur Publicodes n'est pas fonctionnel.
class PublicodesService implements SimulationRepository {
  @override
  Future<void> init() async {
    throw UnsupportedError(
      'PublicodesService n\'est pas supporté sur le web.',
    );
  }

  @override
  void updateSituation(Map<String, dynamic> reponses) {}

  @override
  Map<String, dynamic> getAccumulatedSituation() => {};

  @override
  Future<bool> isQuestionApplicable(String questionSlug) async => true;

  @override
  Future<double> getScore({String objective = "bilan"}) async => 0.0;

  @override
  Future<Map<String, double>> computeScoresByCategory() async => {};
}
