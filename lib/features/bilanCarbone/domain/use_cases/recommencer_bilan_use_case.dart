import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/question_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class RecommencerBilanUseCase {
  final BilanSessionRepository bilanSessionRepository;
  final QuestionRepository questionRepository;
  final SimulationRepository simulationRepository;
  final AuthRepository authRepository; // Ajouté

  RecommencerBilanUseCase({
    required this.bilanSessionRepository,
    required this.questionRepository,
    required this.simulationRepository,
    required this.authRepository,
  });

  Future<List<QuestionBilanEntity>> call() async {
    final userId = await authRepository.getUserId();
    if (userId == null) throw Exception("Action impossible sans connexion");

    // Orchestration
    await bilanSessionRepository.deleteBilan(userId);
    await bilanSessionRepository.createNewBilanSession(userId);
    await simulationRepository.init();

    return await questionRepository.getQuestions();
  }
}
