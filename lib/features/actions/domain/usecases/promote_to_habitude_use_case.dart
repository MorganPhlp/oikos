import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions/domain/repositories/action_repository.dart';

class PromoteToHabitudeUseCase {
  final ActionRepository repository;

  PromoteToHabitudeUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId, String actionId) {
    return repository.promoteActionToHabitude(userId, actionId);
  }
}
