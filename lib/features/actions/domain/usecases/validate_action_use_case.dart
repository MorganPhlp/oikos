import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';

import '../repositories/action_repository.dart';

class ValidateActionParams {
  final String userId;
  final String actionId;
  // XP supprimé ici car calculé en base de données
  const ValidateActionParams({required this.userId, required this.actionId});
}

class ValidateActionUseCase {
  final ActionRepository repository;
  ValidateActionUseCase(this.repository);

  Future<Either<Failure, void>> call(ValidateActionParams params) {
    return repository.validateAction(params.userId, params.actionId);
  }
}
