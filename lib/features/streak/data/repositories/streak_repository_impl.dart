import 'package:oikos/features/streak/data/datasources/streak_remote_datasource.dart';
import 'package:oikos/features/streak/domain/repositories/streak_repository.dart';

class StreakRepositoryImpl implements StreakRepository {
  StreakRemoteDatasource remoteDatasource;

  StreakRepositoryImpl(this.remoteDatasource);

  @override
  Future<int> getCurrentStreak() {
    // TODO: implement getCurrentStreak
    throw UnimplementedError();
  }

  @override
  Future<void> incrementStreak() {
    // TODO: implement incrementStreak
    throw UnimplementedError();
  }

  @override
  Future<void> resetStreak() {
    // TODO: implement resetStreak
    throw UnimplementedError();
  }
}
