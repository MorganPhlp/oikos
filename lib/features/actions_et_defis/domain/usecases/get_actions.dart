import '../entities/action_entity.dart';
import '../repositories/action_repository.dart';

// récupérer la liste des actions du catalogue
class GetActions {
  final ActionRepository repository;

  GetActions(this.repository);

  // La méthode 'call' permet d'appeler la classe comme une fonction
  // On passe l'ID de l'utilisateur pour filtrer les actions déjà possédées
  Future<List<ActionEntity>> call(String userId) async {
    return await repository.getActions(userId);
  }
}