import 'package:flutter_test/flutter_test.dart';
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/data/datasources/publicodes_response.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/detail_bilan_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/type_widget.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_use_case.dart';

class _Auth extends Fake implements AuthRepository {
  @override
  Future<String?> getUserId() async => 'member';
}

class _Simulation extends Fake implements SimulationRepository {
  final situation = <String, dynamic>{};
  double total = 5000;
  Map<String, double> categories = {
    for (final category in publicodesCategories) category: 1000,
  };
  @override
  Map<String, dynamic> getAccumulatedSituation() => Map.unmodifiable(situation);
  @override
  void updateSituation(Map<String, dynamic> reponses) =>
      situation.addAll(reponses);
  @override
  Future<double> getScore({String objective = 'bilan'}) async => total;
  @override
  Future<Map<String, double>> computeScoresByCategory() async => categories;
}

class _Bilans extends Fake implements BilanSessionRepository {
  final writes = <String>[];
  bool failDetails = false;
  @override
  Future<int> getBilanId(String userId) async => 1;
  @override
  Future<void> saveDetailBilan(DetailBilanEntity detail) async {
    if (failDetails) throw StateError('offline');
    writes.add('details');
  }

  @override
  Future<void> setBilanScore(String userId, double score) async {
    writes.add('complete');
  }
}

class _Answers extends Fake implements ReponseRepository {
  int writes = 0;
  @override
  Future<void> saveReponse(ReponseUtilisateurEntity reponse) async {
    writes++;
  }
}

void main() {
  late _Simulation simulation;
  late _Bilans bilans;
  late CalculerBilanUseCase calculate;
  setUp(() {
    simulation = _Simulation();
    bilans = _Bilans();
    calculate = CalculerBilanUseCase(
      simulationRepository: simulation,
      bilanRepository: bilans,
      authRepository: _Auth(),
    );
  });
  test('invalid scores cannot complete or persist a bilan', () async {
    for (final invalid in [0.0, -1.0, double.nan, double.infinity]) {
      simulation.total = invalid;
      await expectLater(calculate(), throwsStateError);
      expect(bilans.writes, isEmpty);
    }
  });
  test('missing category prevents an incomplete breakdown', () async {
    simulation.categories.remove('logement');
    await expectLater(calculate(), throwsStateError);
    expect(bilans.writes, isEmpty);
  });
  test('details are saved before marking the bilan complete', () async {
    expect((await calculate()).$1, 5000);
    expect(bilans.writes, ['details', 'complete']);
  });
  test('failed detail persistence does not complete the bilan', () async {
    bilans.failDetails = true;
    await expectLater(calculate(), throwsStateError);
    expect(bilans.writes, isEmpty);
  });
  test('engine errors remain errors on both platforms', () {
    expect(
      () => decodePublicodesResponse('{"error":"invalid rule"}'),
      throwsStateError,
    );
    expect(() => decodePublicodesResponse('{}'), throwsFormatException);
    expect(decodePublicodesResponse('{"data":1250.5}'), 1250.5);
  });
  test(
    'changed multiple choice clears old values and preserves other questions',
    () async {
      const question = QuestionBilanEntity(
        id: 1,
        slug: 'chauffage',
        question: 'Chauffage',
        categorieEmpreinte: 'logement',
        typeWidget: TypeWidget.choixMultiple,
        config: {
          'options': ['gaz', 'électricité'],
        },
        ordre: 1,
        estObligatoire: true,
      );
      final answers = _Answers();
      final save = EnregistrerReponseUseCase(
        simulationRepo: simulation,
        reponseRepo: answers,
        bilanSessionRepo: bilans,
        authRepository: _Auth(),
      );
      simulation.situation['surface'] = 75;
      await save(question: question, valeur: ['gaz']);
      await save(question: question, valeur: ['électricité']);
      expect(simulation.situation['chauffage . gaz'], "'non'");
      expect(simulation.situation['chauffage . électricité'], "'oui'");
      expect(simulation.situation['surface'], 75);
      expect(answers.writes, 2);
      await expectLater(
        save(question: question, valeur: 'malformed'),
        throwsFormatException,
      );
      expect(answers.writes, 2);
    },
  );
}
