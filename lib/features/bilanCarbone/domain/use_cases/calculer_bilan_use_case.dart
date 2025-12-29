import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class CalculerBilanUseCase {
  final SimulationRepository simulationRepository;

  CalculerBilanUseCase({
    required this.simulationRepository,
  });

  Future<double> call() async {
    final situation = simulationRepository.getAccumulatedSituation();
    
    simulationRepository.updateSituation(situation);

    final double score = await simulationRepository.getScore(objective: "bilan");

    return score;
    }
  }