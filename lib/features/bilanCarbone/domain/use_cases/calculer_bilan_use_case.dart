import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';

class CalculerBilanUseCase {
  final SimulationRepository simulationRepository;

  CalculerBilanUseCase({
    required this.simulationRepository,
  });

  Future<double> call() async {
    // 1. Si tu as besoin de rafraîchir ou vérifier la situation, fais-le, 
    // mais getAccumulatedSituation() est synchrone dans ton service.
    final situation = simulationRepository.getAccumulatedSituation();
    
    // Optionnel : updateSituation n'est utile ici que si tu as modifié la situation entre-temps
    simulationRepository.updateSituation(situation);

    // 2. ERREUR CORRIGÉE : Ajoute "await" devant getScore()
    // Car getScore() renvoie un Future<double> et non un double
    final double score = await simulationRepository.getScore(objective: "bilan");

    return score;
    }
  }