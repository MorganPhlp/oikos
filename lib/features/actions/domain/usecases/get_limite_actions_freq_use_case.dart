import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions/domain/entities/limite_action_freq_entity.dart';
import 'package:oikos/features/actions/domain/repositories/action_repository.dart';

class GetLimiteActionsFreqUseCase {
  ActionRepository repository;

  GetLimiteActionsFreqUseCase({required this.repository});

  Future<Either<Failure, List<LimiteActionFreqEntity>>> call() {
    return repository.getLimiteActionsFreq();
  }
}
