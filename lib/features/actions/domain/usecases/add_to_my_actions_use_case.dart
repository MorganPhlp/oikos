import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';

import '../repositories/action_repository.dart';

class AddToMyActionsParams {
  final String userId;
  final String actionId;

  const AddToMyActionsParams({required this.userId, required this.actionId});
}

class AddToMyActionsUseCase {
  final ActionRepository repository;

  AddToMyActionsUseCase(this.repository);

  Future<Either<Failure, void>> call(AddToMyActionsParams params) {
    return repository.addToMyActions(params.userId, params.actionId);
  }
}
