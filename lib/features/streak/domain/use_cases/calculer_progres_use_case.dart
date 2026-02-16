import 'package:oikos/features/streak/domain/repositories/streak_repository.dart';

class CalculerProgresUseCase {
  final StreakRepository repository;

  CalculerProgresUseCase(this.repository);

  Future<(int individuel, bool collectif)> call(
    String userId,
    int currentStreakPhase,
  ) async {
    final saisonDebut = await repository.getDebutSaison(userId);
    if (saisonDebut == null) {
      return (0, false);
    }

    var individuelBrut = await repository
        .getNombreActionsQuotidiennesValidesDepuis(userId, saisonDebut);
    final collectif = await repository.hasCompletedActionCommunautaire(userId);

    final steps = await repository.getStreakSteps();

    for (var step in steps) {
      if (currentStreakPhase > step.from) {
        individuelBrut -= step.requiredActionsQuotidiennes;
      } else {
        break;
      }
    }
    return (individuelBrut.clamp(0, 999), collectif);
  }
}
