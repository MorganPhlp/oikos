import 'package:oikos/features/streak/domain/repositories/streak_repository.dart';

class MarkStreakAsSeenUseCase {
  final StreakRepository repository;

  MarkStreakAsSeenUseCase(this.repository);

  Future<void> call(String userId, int lastSeenStreak) async {
    await repository.markStreakAsSeen(userId, lastSeenStreak);
  }
}
