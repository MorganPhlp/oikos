import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/services/applicability_checker.dart';

class GetProchaineQuestionUseCase {
  final ApplicabilityChecker applicabilityChecker;
  final ReponseRepository reponseRepository;
  final BilanSessionRepository bilanSessionRepository;
  GetProchaineQuestionUseCase({
    required this.applicabilityChecker,
    required this.reponseRepository,
    required this.bilanSessionRepository,
  });

  Future<int> call({
    required List<QuestionBilanEntity> allQuestions,
    required int currentIndex,
    required String userId,
  }) async {
    int nextIndex = currentIndex + 1;

    while (nextIndex < allQuestions.length) {
      if (applicabilityChecker.isQuestionApplicable(allQuestions[nextIndex])) {
        return nextIndex; // On renvoie l'INDEX
      }

      // Si la question n'est pas applicable, on enregistre une réponse nulle pour cette question
      final int bilanId = await bilanSessionRepository.getBilanId(userId);
      final ReponseUtilisateurEntity reponse = ReponseUtilisateurEntity(
        questionId: allQuestions[nextIndex].id,
        valeur: null, bilanId: bilanId, // Valeur nulle pour les questions non applicables
      );
       await
      reponseRepository.saveReponse(reponse);
      nextIndex++;
    }
    return -1; // Fin du questionnaire
  }
}