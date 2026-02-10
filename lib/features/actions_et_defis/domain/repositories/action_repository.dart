import '../entities/action_entity.dart';

abstract class ActionRepository {
  // 👇 On précise qu'on a besoin de l'ID pour filtrer
  Future<List<ActionEntity>> getActions(String userId);

  Future<void> joinChallenge(String userId, String actionId, String frequency);

  Future<void> validateAction(String userId, String actionId, int xp, double co2);

  Future<List<ActionEntity>> getMyChallenges(String userId);

  Future<void> removeChallenge(String userId, String actionId);
}