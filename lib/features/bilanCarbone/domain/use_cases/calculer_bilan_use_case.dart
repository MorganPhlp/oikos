import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/detail_bilan_entity.dart';
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

  Future<(double, DetailBilanEntity)> call() async {
    // 1. Récupérer l'ID de l'utilisateur
    final userId = await authRepository.getUserId();
    if (userId == null) throw Exception("Utilisateur non authentifié");

    // 2. Calculer le score global
    final situation = simulationRepository.getAccumulatedSituation();
    simulationRepository.updateSituation(situation);
    final double score = await simulationRepository.getScore(
      objective: "bilan",
    );
    // calcul des scores par catégorie
    final Map<String, double> detailScores = await simulationRepository
        .computeScoresByCategory();

    final int bilanId = (await bilanRepository.getBilanId(userId))!;
    DetailBilanEntity detailBilan = DetailBilanEntity(
      id: bilanId,
      transport: detailScores['transport'] ?? 0.0,
      alimentation: detailScores['alimentation'] ?? 0.0,
      logement: detailScores['logement'] ?? 0.0,
      divers: detailScores['divers'] ?? 0.0,
      servicesSocietaux: detailScores['services sociétaux'] ?? 0.0,
    );

    // 3. Enregistrer via le repository (en passant le userId)
    await bilanRepository.setBilanScore(userId, score);
    await bilanRepository.saveDetailBilan(detailBilan);

    return (score, detailBilan);
  }
}
