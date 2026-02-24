import '../../domain/entities/action_entity.dart';
import '../../domain/repositories/action_repository.dart';
import '../datasources/action_remote_data_source.dart';

class ActionRepositoryImpl implements ActionRepository {
  final ActionRemoteDataSourceImpl remoteDataSource;

  ActionRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ActionEntity>> getActions(String userId) async {
    return await remoteDataSource.fetchActions(userId);
  }

  @override
  Future<void> joinChallenge(String userId, String actionId, String frequency) async {
    await remoteDataSource.joinChallenge(userId, actionId, frequency);
  }

  @override
  Future<void> validateAction(String userId, String actionId, int xp, double co2) async {
    await remoteDataSource.validateAction(userId, actionId, xp, co2);
  }

  @override
  Future<List<ActionEntity>> getMyChallenges(String userId) async {
    return await remoteDataSource.fetchMyChallenges(userId);
  }

  @override
  Future<void> removeChallenge(String userId, String actionId) async {
    await remoteDataSource.removeChallenge(userId, actionId);
  }

  @override
  Future<void> setLifestyle(String userId, String actionId, bool isLifestyle) async {
    await remoteDataSource.setLifestyle(userId, actionId, isLifestyle);
  }
}