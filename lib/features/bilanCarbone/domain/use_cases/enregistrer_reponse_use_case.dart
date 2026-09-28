import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';
import 'package:oikos/features/bilanCarbone/utils/util.dart';

class EnregistrerReponseUseCase {
  final SimulationRepository simulationRepo;
  final ReponseRepository reponseRepo;
  final BilanSessionRepository bilanSessionRepo;
  final AuthRepository authRepository;

  EnregistrerReponseUseCase({
    required this.simulationRepo,
    required this.reponseRepo,
    required this.bilanSessionRepo,
    required this.authRepository,
  });

  Future<void> call({
    required QuestionBilanEntity question,
    required dynamic valeur,
  }) async {
    final userId = await authRepository.getUserId();
    if (userId == null) throw StateError('Action impossible sans connexion');
    // Validate and use the same formatting as questionnaire restoration.
    final formatted = formaterPourSimulation(question, valeur);
    final bilanId = await bilanSessionRepo.getBilanId(userId);
    await reponseRepo.saveReponse(
      ReponseUtilisateurEntity(
        bilanId: bilanId,
        questionId: question.id,
        valeur: valeur,
      ),
    );
    // A changed multiple choice/counter must replace its previous children.
    final replacement = <String, dynamic>{
      for (final key in simulationRepo.getAccumulatedSituation().keys)
        if (key == question.slug || key.startsWith('${question.slug} .'))
          key: null,
      ...formatted,
    };
    simulationRepo.updateSituation(replacement);
  }
}
