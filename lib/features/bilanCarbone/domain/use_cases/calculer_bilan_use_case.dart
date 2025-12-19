import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class CalculerBilanUseCase {
  final SimulationRepository simulationRepository;

  CalculerBilanUseCase({
    required this.simulationRepository,
  });

  Future<double> call() async {
    final situation = await simulationRepository.getAccumulatedSituation();
    double totalEmissions = 0.0;
    simulationRepository.updateSituation(situation);
    final score = simulationRepository.getScore(objective: "bilan");
    totalEmissions += score;
    return totalEmissions;
    }
  }