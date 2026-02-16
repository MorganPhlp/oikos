import '../entities/action_entity.dart';
import '../repositories/action_repository.dart';

class GetActions {
  final ActionRepository repository;

  GetActions(this.repository);

  // 👇 On ajoute l'argument userId ici pour le passer au repository
  Future<List<ActionEntity>> call(String userId) async {
    return await repository.getActions(userId);
  }
}