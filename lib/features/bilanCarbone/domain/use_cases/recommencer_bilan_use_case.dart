import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/question_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class RecommencerBilanUseCase {
  final BilanSessionRepository bilanSessionRepository;
  final QuestionRepository questionRepository;
  final SimulationRepository simulationRepository;

  RecommencerBilanUseCase({required this.bilanSessionRepository, required this.questionRepository, required this.simulationRepository});

  Future<List<QuestionBilanEntity>> call() async {
    await bilanSessionRepository.deleteBilan();
    await bilanSessionRepository.createNewBilanSession();
    await simulationRepository.init();
    return await questionRepository.getQuestions();
  }
}