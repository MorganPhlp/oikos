import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/question_repository.dart';

class RecupererQuestionsUseCase {
  final QuestionRepository questionRepository;

  RecupererQuestionsUseCase({required this.questionRepository});

  Future<List<QuestionBilanEntity>> call() async {
    return await (questionRepository.getQuestions());
  }
}

