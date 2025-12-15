import '../entities/reponse_entity.dart';

abstract class ReponseRepository {
  /// Sauvegarde une réponse (ou la met à jour si elle existe déjà)
  Future<void> saveReponse(ReponseUtilisateurEntity reponse);

  /// Récupère toutes les réponses d'un bilan spécifique
  Future<List<ReponseUtilisateurEntity>> getReponses(int bilanId);

  /// Supprime toutes les réponses associées à un bilan spécifique
  Future<void> deleteReponsesForBilan(int bilanId);

  /// Récupère une réponse spécifique pour une question dans un bilan donné
  /// Retourne null si aucune réponse n'existe
  Future<ReponseUtilisateurEntity?> getReponse(int bilanId, int questionId);
}