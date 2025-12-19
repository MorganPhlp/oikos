import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

/// Service gérant le moteur Publicodes dans un Isolate persistant
class PublicodesService implements SimulationRepository {
  Isolate? _isolate;
  SendPort? _sendPort;
  bool _initialized = false;
  final Map<String, dynamic> _accumulatedSituation = {};

  @override
  Future<void> init() async {
    if (_initialized) return;

    final receivePort = ReceivePort();

    // 1. Lancement de l'Isolate persistant
    _isolate = await Isolate.spawn(
      _publicodesIsolateEntry,
      receivePort.sendPort,
    );

    // 2. Récupération du port de communication
    _sendPort = await receivePort.first as SendPort;

    // 3. Chargement des assets (doit être fait côté Main Isolate)
    final bundle = await rootBundle.loadString(
      'assets/js/publicodes_bundle.js',
    );
    final rules = await rootBundle.loadString('assets/data/rules.json');

    // 4. Initialisation du moteur JS dans l'Isolate
    final success = await _send('init', {'bundle': bundle, 'rules': rules});

    if (success == true) {
      _initialized = true;
      print("✅ Publicodes Isolate prêt et persistant");
    } else {
      print("❌ Échec de l'initialisation de l'Isolate Publicodes");
    }
  }

  @override
  void updateSituation(Map<String, dynamic> nouvelleReponse) {
    _accumulatedSituation.addAll(nouvelleReponse);
    // On met à jour l'isolate de manière asynchrone
    _send('update', Map.from(_accumulatedSituation));
  }

  @override
  Map<String, dynamic> getAccumulatedSituation() =>
      Map.unmodifiable(_accumulatedSituation);

  @override
  Future<double> getScore({String objective = "bilan"}) async {
    final result = await _send('score', {'objective': objective});
    return (result as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<bool> isQuestionApplicable(String questionSlug) async {
    final result = await _send('applicability', {'slug': questionSlug});
    return (result as bool?) ?? true;
  }

  /// Helper de communication avec l'Isolate incluant une sécurité Timeout
  Future<dynamic> _send(String type, Map<String, dynamic> payload) async {
    if (_sendPort == null) return null;

    final responsePort = ReceivePort();
    _sendPort!.send({
      'type': type,
      'payload': payload,
      'replyTo': responsePort.sendPort,
    });

    // On attend la réponse avec un timeout pour éviter le chargement infini
    return await responsePort.first.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        print("⚠️ Timeout sur la commande : $type");
        responsePort.close();
        return null;
      },
    );
  }

  @override
  Future<void> dispose() async {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _sendPort = null;
    _initialized = false;
  }
}

// -----------------------------------------------------------------------------
// SECTION ISOLATE (Point d'entrée séparé)
// -----------------------------------------------------------------------------

/// Cette fonction s'exécute sur un thread totalement séparé
void _publicodesIsolateEntry(SendPort mainSendPort) {
  final receivePort = ReceivePort();
  mainSendPort.send(receivePort.sendPort);

  JavascriptRuntime? js;

  receivePort.listen((message) {
    final String type = message['type'];
    final Map<String, dynamic> payload = message['payload'];
    final SendPort replyTo = message['replyTo'];

    try {
      switch (type) {
        case 'init':
          // xhr: false évite l'appel à rootBundle dans l'Isolate
          js = getJavascriptRuntime(xhr: false);
          js!.evaluate(payload['bundle']);
          js!.evaluate('initEngine(${jsonEncode(payload['rules'])})');
          replyTo.send(true);
          break;

        case 'update':
          if (js == null) {
            replyTo.send(false);
            return;
          }
          final jsonSituation = jsonEncode(payload);
          final safeJson = jsonSituation.replaceAll('"', '\\"');
          js!.evaluate('globalThis.updateSituation("$safeJson")');
          replyTo.send(true);
          break;

        case 'score':
          if (js == null) {
            replyTo.send(0.0);
            return;
          }
          final result = js!.evaluate(
            "getBilan(${jsonEncode(payload['objective'])})",
          );
          final score =
              double.tryParse(result.stringResult.replaceAll('"', '')) ?? 0.0;
          replyTo.send(score);
          break;

        case 'applicability':
          if (js == null) {
            replyTo.send(true);
            return;
          }
          final result = js!.evaluate('checkApplicability("bilan")');

          if (result.isError) {
            replyTo.send(true);
          } else {
            final missing = jsonDecode(result.stringResult) as List;
            final slug = payload['slug'];
            final isApplicable = missing.any(
              (v) => v.toString() == slug || v.toString().startsWith("$slug ."),
            );
            replyTo.send(isApplicable);
          }
          break;

        default:
          replyTo.send(null);
      }
    } catch (e) {
      print("❌ Erreur dans l'Isolate Publicodes: $e");
      replyTo.send(null);
    }
  });
}
