import 'package:oikos/features/streak/domain/entities/streak_step_entity.dart';
import 'package:oikos/features/streak/domain/repositories/streak_repository.dart';

class RecupererStreakStepsUseCase {
  final StreakRepository repository;

  RecupererStreakStepsUseCase(this.repository);

  Future<List<StreakStepEntity>> call() async {
    return await repository.getStreakSteps();
  }
}
