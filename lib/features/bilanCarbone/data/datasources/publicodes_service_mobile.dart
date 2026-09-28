import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';
import 'publicodes_response.dart';

/// Runs the shared engine in a persistent isolate, with explicit failures.
class PublicodesService implements SimulationRepository {
  Isolate? _isolate;
  SendPort? _sendPort;
  Future<void>? _initialization;
  final Map<String, dynamic> _situation = {};

  @override
  Future<void> init() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    final receivePort = ReceivePort();
    try {
      final bundle = await rootBundle.loadString(
        'assets/js/publicodes_bundle.js',
      );
      final rules = await rootBundle.loadString('assets/data/rules.json');
      _isolate = await Isolate.spawn(
        _publicodesIsolateEntry,
        receivePort.sendPort,
      );
      _sendPort =
          await receivePort.first.timeout(const Duration(seconds: 15))
              as SendPort;
      await _send('init', {'bundle': bundle, 'rules': rules});
    } catch (_) {
      await dispose();
      rethrow;
    } finally {
      receivePort.close();
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
    await _send('update', Map<String, dynamic>.from(_situation));
  }

  @override
  Future<double> getScore({String objective = 'bilan'}) async {
    await _synchronize();
    return (await _send('score', {'objective': objective}) as num).toDouble();
  }

  @override
  Future<bool> isQuestionApplicable(String questionSlug) async {
    await _synchronize();
    final missing = await _send('applicability', {}) as List;
    return missing.any(
      (v) => v == questionSlug || v.toString().startsWith('$questionSlug .'),
    );
  }

  @override
  Future<Map<String, double>> computeScoresByCategory() async => {
    for (final category in publicodesCategories)
      category: await getScore(objective: category),
  };

  Future<dynamic> _send(String type, Map<String, dynamic> payload) async {
    if (_sendPort == null) throw StateError('Publicodes non initialisé');
    final responsePort = ReceivePort();
    try {
      _sendPort!.send({
        'type': type,
        'payload': payload,
        'replyTo': responsePort.sendPort,
      });
      final response = await responsePort.first.timeout(
        const Duration(seconds: 30),
      );
      return decodePublicodesResponse(response as String);
    } finally {
      responsePort.close();
    }
  }

  Future<void> dispose() async {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _sendPort = null;
    _initialization = null;
    resetSituation();
  }
}

void _publicodesIsolateEntry(SendPort mainSendPort) {
  final receivePort = ReceivePort();
  mainSendPort.send(receivePort.sendPort);
  JavascriptRuntime? js;
  String evaluate(String source) {
    if (js == null) throw StateError('Publicodes non initialisé');
    final result = js!.evaluate(source);
    if (result.isError) throw StateError(result.stringResult);
    return result.stringResult;
  }

  receivePort.listen((dynamic message) {
    final String type = message['type'];
    final Map<String, dynamic> payload = message['payload'];
    final SendPort replyTo = message['replyTo'];
    try {
      final String response;
      switch (type) {
        case 'init':
          js = getJavascriptRuntime(xhr: false);
          evaluate(payload['bundle'] as String);
          response = evaluate('initEngine(${jsonEncode(payload['rules'])})');
        case 'update':
          response = evaluate(
            'updateSituation(${jsonEncode(jsonEncode(payload))})',
          );
        case 'score':
          response = evaluate('getBilan(${jsonEncode(payload['objective'])})');
        case 'applicability':
          response = evaluate('checkApplicability("bilan")');
        default:
          throw StateError('Opération Publicodes inconnue');
      }
      replyTo.send(response);
    } catch (error) {
      replyTo.send(jsonEncode({'error': error.toString()}));
    }
  });
}
