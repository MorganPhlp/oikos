import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class InitialiserMoteurDeCalculUseCase {
  final SimulationRepository simulationRepository;

  InitialiserMoteurDeCalculUseCase({required this.simulationRepository});

  Future<void> call() async {
    // 1. Initialiser le moteur de calcul
    await simulationRepository.init();
  }
}