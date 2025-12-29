// features/bilanCarbone/domain/usecases/demarrer_bilan_usecase.dart

import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/question_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class DemarrerBilanUseCase {
  final SimulationRepository simulationRepo;
  final QuestionRepository questionRepo;
  final BilanSessionRepository bilanSessionRepo;

  DemarrerBilanUseCase({
    required this.simulationRepo,
    required this.questionRepo,
    required this.bilanSessionRepo,
  });

  // Retourne la liste complète des questions
  Future<List<QuestionBilanEntity>> call() async {
    // 1. Initialiser le moteur JS (Publicodes)
    await simulationRepo.init();
    await bilanSessionRepo.createNewBilanSession();
    // 2. Récupérer toutes les questions depuis la source de données (Supabase)
    final allQuestions = await questionRepo.getQuestions();
    
    return allQuestions;
  }
}