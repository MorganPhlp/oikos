// features/bilanCarbone/domain/usecases/get_prochaine_question_pertinente_usecase.dart

import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/services/applicability_checker.dart';

class GetProchaineQuestionUseCase {
  final ApplicabilityChecker applicabilityChecker;
  
  // État géré par le Use Case (pour maintenir la position dans la liste)
  List<QuestionBilanEntity> _allQuestions = [];
  int _currentIndex = 0;

  // Accesseurs pour le Cubit (pour l'affichage de la progression)
  int get currentIndex => _currentIndex;
  int get totalQuestions => _allQuestions.length;

  GetProchaineQuestionUseCase({
    required this.applicabilityChecker,
  });

  // Doit être appelé par le Cubit après l'initialisation pour donner la liste complète
  void setQuestions(List<QuestionBilanEntity> questions) {
    _allQuestions = questions;
    _currentIndex = 0;
  }

  // Retourne la prochaine question pertinente ou null si c'est terminé
  Future<QuestionBilanEntity?> call() async {
    
    while (_currentIndex < _allQuestions.length) {
      final candidate = _allQuestions[_currentIndex];
      
      // La vérification est déléguée au Service ApplicabilityChecker
      final isPertinente = applicabilityChecker.isQuestionApplicable(candidate);
      
      if (isPertinente) {
        // Trouvé! On retourne la question et on s'arrête.
        return candidate; 
      }

      // Si pas pertinente, on avance l'index et on continue la boucle
      _currentIndex++;
    }

    // Si on sort de la boucle, le questionnaire est terminé
    return null; 
  }

  // Méthode utilitaire pour avancer l'index après une réponse
  void avancerIndex() {
    if (_currentIndex < _allQuestions.length) {
      _currentIndex++;
    }
  }

  void reculerIndex() {
    if (_currentIndex > 0) {
      _currentIndex--;
    }
  }
}