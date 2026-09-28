import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions/domain/repositories/action_repository.dart';

class EcarterCategorieUseCase {
  final ActionRepository repository;

  EcarterCategorieUseCase({required this.repository});

  Future<Either<Failure, void>> call(String userId, String categorieNom) async {
    return await repository.ecarterCategorie(userId, categorieNom);
  }
}
