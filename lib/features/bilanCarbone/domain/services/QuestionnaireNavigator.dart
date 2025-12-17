import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/services/applicability_checker.dart';

class QuestionnaireNavigator {
  final ApplicabilityChecker applicabilityChecker;
  List<QuestionBilanEntity> _questions = [];
  int _currentIndex = 0;

  QuestionnaireNavigator(this.applicabilityChecker);

  void setQuestions(List<QuestionBilanEntity> q) {
    _questions = q;
    _currentIndex = 0;
  }

  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;

  QuestionBilanEntity? get currentQuestion => 
      (_currentIndex >= 0 && _currentIndex < _questions.length) ? _questions[_currentIndex] : null;

  Future<QuestionBilanEntity?> moveNext() async {
    _currentIndex++;
    while (_currentIndex < _questions.length) {
      if (applicabilityChecker.isQuestionApplicable(_questions[_currentIndex])) {
        return _questions[_currentIndex];
      }
      _currentIndex++;
    }
    return null;
  }

  Future<QuestionBilanEntity?> movePrevious() async {
    if (_currentIndex <= 0) return null;
    _currentIndex--;
    while (_currentIndex >= 0) {
      if (applicabilityChecker.isQuestionApplicable(_questions[_currentIndex])) {
        return _questions[_currentIndex];
      }
      _currentIndex--;
    }
    return currentQuestion;
  }
}