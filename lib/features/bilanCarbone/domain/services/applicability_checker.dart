// fichier: lib/features/bilanCarbone/domain/services/applicability_checker.dart

import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

/// Définit la règle métier complexe de vérification de pertinence.
class ApplicabilityChecker {
    
    // Le service a besoin d'accéder aux réponses de l'utilisateur pour vérifier les conditions.
    // L'injection de la SituationRepository est la clé pour obtenir cet état.
    final SimulationRepository _simulationRepo;

    ApplicabilityChecker(this._simulationRepo);

    /// Exécute la vérification de la pertinence de la question en pur Dart.
    bool isQuestionApplicable(QuestionBilanEntity candidate) {
        // 1. Récupérer l'état actuel de toutes les réponses (la "situation")
        final currentSituation = _simulationRepo.getAccumulatedSituation();
        print('Vérification de la pertinence pour la question: ${candidate.slug}');
        print('Situation actuelle: $currentSituation');
        // 2. Lire les conditions de dépendance depuis l'entité
        final config = candidate.config; 
        // On suppose que QuestionBilanEntity.configJson est un Map<String, dynamic>
        final conditions = config['dependances'] as List<dynamic>?;
        
        if (conditions == null || conditions.isEmpty) {
            return true; 
        }

        // 3. Appliquer la logique de vérification IN / EQUAL (votre code)
        for (final condition in conditions) {
            if (condition is! Map<String, dynamic>) continue; 
            
            final requiredKey = condition['key'] as String;
            final requiredValue = condition['value'];
            final type = condition['type'] as String;
            
            var currentValue = currentSituation[requiredKey];
            if (currentValue is String) {
                  currentValue = currentValue.replaceAll("'", "");
            }
            // Si la dépendance requise n'a pas encore de réponse, la question n'est pas applicable.
            if (currentValue == null) return false; 
            
            switch (type) {
                case 'EQUAL':
                    if (currentValue != requiredValue) return false;
                    break;
                case 'IN':
                    if (requiredValue is List && !requiredValue.contains(currentValue)) return false;
                    break;
                default:
                    return false; // Type de condition non supporté ou inconnu
            }
        }
        
        return true; 
    }
}