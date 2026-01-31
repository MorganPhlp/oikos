import 'dart:math';

import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';
import 'package:oikos/features/bilanCarbone/utils/util.dart';

class ReprendreBilanUseCase {
  final ReponseRepository reponseRepository;
  final BilanSessionRepository bilanRepository;
  final SimulationRepository simulationRepository;
  final AuthRepository authRepository;

  ReprendreBilanUseCase({
    required this.reponseRepository,
    required this.bilanRepository,
    required this.simulationRepository,
    required this.authRepository,
  });

  Future<int> call(
    List<QuestionBilanEntity> allQuestions,
    Map<String, dynamic> situation,
  ) async {
    // initialiser moteur
    await simulationRepository.init();
    Map<String, dynamic> situationFormattee = {};

    for (var entry in situation.entries) {
      final question = allQuestions.firstWhere(
        (q) => q.slug == entry.key,
        orElse: () =>
            throw Exception("Question introuvable pour le slug: ${entry.key}"),
      );

      // 2. ON FORMATE (On passe maintenant l'objet question, pas entry.key)
      situationFormattee.addAll(formaterPourSimulation(question, entry.value));
    }

    // 3. ON MET À JOUR LA SIMULATION UNE SEULE FOIS
    simulationRepository.updateSituation(situationFormattee);

    //4. on recupere l'index de la derniere question repondu
    final userId = await authRepository.getUserId();
    if (userId == null) {
      throw Exception("Action impossible sans connexion");
    }
    final int? bilanId = await bilanRepository.getBilanId(userId);
    if (bilanId == null) {
      throw Exception("Aucun bilan en cours pour reprendre les réponses.");
    }
    final List<ReponseUtilisateurEntity> reponses = await reponseRepository
        .getReponses(bilanId);
    //on retourne l'index de la derniere question repondue
    int id = reponses.fold<int>(0, (prev, e) => max(prev, e.questionId));
    int index = allQuestions.indexWhere((q) => q.id == id);
    return index > 0
        ? index < allQuestions.length
              ? index
              : 0
        : 0;
  }
}
