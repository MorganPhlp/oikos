import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions/domain/repositories/action_repository.dart';

class EcarterTagUseCase {
  final ActionRepository repository;

  EcarterTagUseCase({required this.repository});

  Future<Either<Failure, void>> call(String userId, String tagNom) async {
    return await repository.ecarterTag(userId, tagNom);
  }
}
