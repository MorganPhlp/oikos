import 'dart:io';
import '../../domain/entities/action_entity.dart';
import '../../domain/repositories/action_repository.dart';
import '../datasources/action_remote_data_source.dart';

class ActionRepositoryImpl implements ActionRepository {
  final ActionRemoteDataSourceImpl
  remoteDataSource; // Assure-toi que le type est bon

  ActionRepositoryImpl(this.remoteDataSource);

  @override
  // 👇 Ajout de userId ici pour respecter le contrat qu'on a modifié à l'étape 1
  Future<List<ActionEntity>> getActions(String userId) async {
    return await remoteDataSource.fetchActions(userId);
  }

  @override
  Future<void> joinChallenge(
    String userId,
    String actionId,
    String frequency,
  ) async {
    await remoteDataSource.joinChallenge(userId, actionId, frequency);
  }

  @override
  Future<void> validateAction(
    String userId,
    String actionId,
    int xp,
    double co2,
  ) async {
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
}
