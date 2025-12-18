import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/services/applicability_checker.dart';

class GetPreviousQuestionUseCase {
  final ApplicabilityChecker applicabilityChecker;
  GetPreviousQuestionUseCase({required this.applicabilityChecker});

  Future<int> call({
    required List<QuestionBilanEntity> allQuestions,
    required int currentIndex,
  }) async {
    int prevIndex = currentIndex - 1;
    while (prevIndex >= 0) {
      if (applicabilityChecker.isQuestionApplicable(allQuestions[prevIndex])) {
        return prevIndex;
      }
      prevIndex--;
    }
    return 0; // On reste sur la première si on ne peut pas reculer plus
  }
}