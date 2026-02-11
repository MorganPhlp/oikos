abstract class StreakRepository {
  Future<int> getCurrentStreak();
  Future<void> incrementStreak();
  Future<void> resetStreak();
}
