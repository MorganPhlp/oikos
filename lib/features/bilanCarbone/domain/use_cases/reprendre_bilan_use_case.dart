import 'package:flutter/widgets.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';
import 'package:oikos/features/bilanCarbone/utils/util.dart';

class ReprendreBilanUseCase {
  final ReponseRepository reponseRepository;
  final BilanSessionRepository bilanRepository;
  final SimulationRepository simulationRepository;

  ReprendreBilanUseCase({
    required this.reponseRepository, 
    required this.bilanRepository, 
    required this.simulationRepository
  });

  Future<int> call(List<QuestionBilanEntity> allQuestions, Map<String, dynamic> situation) async {
    Map<String, dynamic> situationFormattee = {};

    for (var entry in situation.entries) {

      final question = allQuestions.firstWhere(
        (q) => q.slug == entry.key,
        orElse: () => throw Exception("Question introuvable pour le slug: ${entry.key}"),
      );
      
      // 2. ON FORMATE (On passe maintenant l'objet question, pas entry.key)
      situationFormattee.addAll(formaterPourSimulation(question, entry.value));
    }

    // 3. ON MET À JOUR LA SIMULATION UNE SEULE FOIS
    simulationRepository.updateSituation(situationFormattee);
    
    return situation.length;
  }
}