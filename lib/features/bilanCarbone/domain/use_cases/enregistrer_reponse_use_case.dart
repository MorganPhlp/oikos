// features/bilanCarbone/domain/usecases/enregistrer_et_simuler_reponse_usecase.dart

import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';


class EnregistrerReponseUseCase {
  final SimulationRepository simulationRepo;
  final ReponseRepository reponseRepo;
  final BilanSessionRepository bilanSessionRepo;
  List<ReponseUtilisateurEntity> reponses = [];

  EnregistrerReponseUseCase({
    required this.simulationRepo,
    required this.reponseRepo,
    required this.bilanSessionRepo,
  });

  Future<void> call({
    required QuestionBilanEntity question, 
    required dynamic valeur,
  }) async {
    // 1. Récupérer l'ID utilisateur
    final bilanId = await bilanSessionRepo.getBilanId();
    if (bilanId == null) {
      
      throw Exception("ID utilisateur manquant. Impossible d'enregistrer la réponse.");
    }
    
    // 2. Enregistrer la réponse dans la base de données (Persistance)
    await reponseRepo.saveReponse(
      ReponseUtilisateurEntity(
        bilanId: bilanId,
        questionId: question.id,
        valeur: valeur,
      )
    );
    // 3. Envoyer la réponse au moteur de simulation (État temporaire)
    simulationRepo.updateSituation({ question.slug: valeur });
  }
}