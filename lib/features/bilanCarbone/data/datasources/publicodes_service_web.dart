import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/services.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';
import 'publicodes_response.dart';

@JS('initEngine')
external JSString _initEngine(JSString rules);
@JS('updateSituation')
external JSString _updateSituation(JSString situation);
@JS('getBilan')
external JSString _getBilan(JSString objective);
@JS('checkApplicability')
external JSString _checkApplicability(JSString objective);

/// Uses the same bundled rules and engine as the mobile runtime.
class PublicodesService implements SimulationRepository {
  final Map<String, dynamic> _situation = {};
  Future<void>? _initialization;

  @override
  Future<void> init() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    try {
      final rules = await rootBundle.loadString('assets/data/rules.json');
      decodePublicodesResponse(_initEngine(rules.toJS).toDart);
    } catch (_) {
      _initialization = null;
      rethrow;
    }
  }

  @override
  void resetSituation() => _situation.clear();

  @override
  void updateSituation(Map<String, dynamic> reponses) =>
      _situation.addAll(reponses);

  @override
  Map<String, dynamic> getAccumulatedSituation() =>
      Map.unmodifiable(_situation);

  Future<void> _synchronize() async {
    await init();
    decodePublicodesResponse(
      _updateSituation(jsonEncode(_situation).toJS).toDart,
    );
  }

  @override
  Future<double> getScore({String objective = 'bilan'}) async {
    await _synchronize();
    return (decodePublicodesResponse(_getBilan(objective.toJS).toDart) as num)
        .toDouble();
  }

  @override
  Future<bool> isQuestionApplicable(String questionSlug) async {
    await _synchronize();
    final missing =
        decodePublicodesResponse(_checkApplicability('bilan'.toJS).toDart)
            as List;
    return missing.any(
      (v) => v == questionSlug || v.toString().startsWith('$questionSlug .'),
    );
  }

  @override
  Future<Map<String, double>> computeScoresByCategory() async => {
    for (final category in publicodesCategories)
      category: await getScore(objective: category),
  };

  Future<void> dispose() async {
    resetSituation();
  }
}
