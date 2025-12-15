import '../entities/question_entity.dart';

abstract class QuestionRepository {
  Future<List<QuestionBilanEntity>> getQuestions();
}