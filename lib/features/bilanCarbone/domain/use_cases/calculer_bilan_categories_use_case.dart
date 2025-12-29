
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class CalculerBilanCategoriesUseCase {
  final SimulationRepository simulationRepository;

  CalculerBilanCategoriesUseCase({required this.simulationRepository}); 

  Future<Map<String, double>> call() async {
    return await simulationRepository.getScoresByCategory();
  }
}
  