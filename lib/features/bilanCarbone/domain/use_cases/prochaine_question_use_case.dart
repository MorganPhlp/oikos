import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/services/applicability_checker.dart';

class GetProchaineQuestionUseCase {
  final ApplicabilityChecker applicabilityChecker;
  GetProchaineQuestionUseCase({required this.applicabilityChecker});

  Future<int> call({
    required List<QuestionBilanEntity> allQuestions,
    required int currentIndex,
  }) async {
    int nextIndex = currentIndex + 1;

    while (nextIndex < allQuestions.length) {
      if (applicabilityChecker.isQuestionApplicable(allQuestions[nextIndex])) {
        return nextIndex; // On renvoie l'INDEX
      }
      nextIndex++;
    }
    return -1; // Fin du questionnaire
  }
}