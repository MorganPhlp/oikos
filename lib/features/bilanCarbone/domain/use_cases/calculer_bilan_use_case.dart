import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class CalculerBilanUseCase {
  final SimulationRepository simulationRepository;
  final BilanSessionRepository bilanRepository;

  CalculerBilanUseCase({
    required this.simulationRepository,
    required this.bilanRepository,
  });

  Future<double> call() async {
    final situation = simulationRepository.getAccumulatedSituation();
    
    simulationRepository.updateSituation(situation);

    final double score = await simulationRepository.getScore(objective: "bilan");
    // Enregistrer le score dans le bilanRepository
    await bilanRepository.setBilanScore(score);

    return score;
    }
  }