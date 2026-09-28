import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';

import '../repositories/action_repository.dart';

class RemoveFromMyActionsParams {
  final String userId;
  final String actionId;

  const RemoveFromMyActionsParams({
    required this.userId,
    required this.actionId,
  });
}

class RemoveFromMyActionsUseCase {
  final ActionRepository repository;

  RemoveFromMyActionsUseCase(this.repository);

  Future<Either<Failure, void>> call(RemoveFromMyActionsParams params) {
    return repository.removeFromMyActions(params.userId, params.actionId);
  }
}
