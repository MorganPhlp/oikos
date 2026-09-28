import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';
import 'package:oikos/features/streak/domain/repositories/streak_repository.dart';

class CalculerProgresUseCase {
  final StreakRepository repository;

  CalculerProgresUseCase(this.repository);

  Future<(int individuel, bool collectif)> call(
    String userId,
    UtilisateurStreakEntity streak,
  ) async {
    int quotidiennes = 0;
    bool collectif = false;

    if (streak.lastUpdated == null) {
      // Si lastUpdated est null, cela signifie que l'utilisateur n'a pas encore commencé sa streak
      // On considère donc qu'il n'a pas encore validé d'actions quotidiennes ni d'action communautaire
      quotidiennes = 0;
      collectif = false;
    } else {
      quotidiennes = await repository.getNombreActionsQuotidiennesValidesDepuis(
        userId,
        streak.lastUpdated!,
      );
      collectif = await repository.hasCompletedActionCommunautaireDepuis(
        userId,
        streak.lastUpdated!,
      );
    }

    return (quotidiennes, collectif);
  }
}
