import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/habitude_entity.dart';
import 'package:oikos/features/actions_et_defis/domain/repositories/action_repository.dart';

class GetMyHabitudesUseCase {
  final ActionRepository repository;

  GetMyHabitudesUseCase(this.repository);

  Future<Either<Failure, List<HabitudeEntity>>> call(String userId) {
    return repository.getMyHabitudes(userId);
  }
}
