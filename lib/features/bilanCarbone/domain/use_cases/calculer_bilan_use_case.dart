import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class CalculerBilanUseCase {
  final SimulationRepository simulationRepository;
  final BilanSessionRepository bilanRepository;
  final AuthRepository authRepository;

  CalculerBilanUseCase({
    required this.simulationRepository,
    required this.bilanRepository,
    required this.authRepository,
  });

  Future<double> call() async {
    // 1. Récupérer l'ID de l'utilisateur
    final userId = await authRepository.getUserId();
    if (userId == null) throw Exception("Utilisateur non authentifié");

    // 2. Calculer le score
    final situation = simulationRepository.getAccumulatedSituation();
    simulationRepository.updateSituation(situation);
    final double score = await simulationRepository.getScore(
      objective: "bilan",
    );

    // 3. Enregistrer via le repository (en passant le userId)
    await bilanRepository.setBilanScore(userId, score);

    return score;
  }
}
