import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/user_active_action_entity.dart';
import '../repositories/action_repository.dart';

class GetMyActiveActionsUseCase {
  final ActionRepository repository;

  GetMyActiveActionsUseCase(this.repository);

  Future<Either<Failure, List<UserActiveActionEntity>>> call(String userId) {
    return repository.getMyActiveActions(userId);
  }
}
