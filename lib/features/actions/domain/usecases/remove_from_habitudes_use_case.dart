import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions/domain/repositories/action_repository.dart';

class RemoveHabitudeUseCase {
  final ActionRepository _repository;

  RemoveHabitudeUseCase(this._repository);

  Future<Either<Failure, void>> call(String userId, String habitudeId) async {
    return await _repository.removeHabitude(userId, habitudeId);
  }
}
