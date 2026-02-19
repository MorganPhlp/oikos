import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';

import '../entities/action_entity.dart';
import '../repositories/action_repository.dart';

class GetActionsUseCase {
  final ActionRepository repository;

  GetActionsUseCase(this.repository);

  Future<Either<Failure, List<ActionEntity>>> call(String userId) {
    return repository.getActions(userId);
  }
}
