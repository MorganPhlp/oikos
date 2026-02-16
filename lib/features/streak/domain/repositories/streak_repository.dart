import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';
import 'package:oikos/features/streak/domain/entities/streak_step_entity.dart';

abstract class StreakRepository {
  Future<UtilisateurStreakEntity> getCurrentStreak(String userId);
  Stream<UtilisateurStreakEntity> watchStreak(
    String userId,
    String entrepriseId,
  );
  Future<int> getNombreActionsQuotidiennesValidesDepuis(
    String userId,
    DateTime date,
  );
  Future<bool> hasCompletedActionCommunautaire(String userId);
  Future<List<StreakStepEntity>> getStreakSteps();
  Future<UtilisateurStreakEntity> initStreak(String userId);
  Future<DateTime?> getDebutSaison(String userId);
}
