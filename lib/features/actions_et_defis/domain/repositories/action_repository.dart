import '../entities/action_entity.dart';

// Le contrat qui définit comment l'application doit gérer les actions
abstract class ActionRepository {

  // Récupère la liste des actions disponibles dans le catalogue pour un utilisateur
  Future<List<ActionEntity>> getActions(String userId);

  // Permet à l'utilisateur de s'inscrire à un nouveau défi
  Future<void> joinChallenge(String userId, String actionId, String frequency);

  // Enregistre une réussite, gagne de l'XP et économise du CO2
  Future<void> validateAction(
      String userId,
      String actionId,
      int xp,
      double co2,
      );

  // Récupère la liste des défis en cours (ceux acceptés par l'utilisateur)
  Future<List<ActionEntity>> getMyChallenges(String userId);

  // Supprime un défi de la liste de l'utilisateur
  Future<void> removeChallenge(String userId, String actionId);

  // Définit si une action est adoptée comme une habitude de vie durable
  Future<void> setLifestyle(String userId, String actionId, bool isLifestyle);
}