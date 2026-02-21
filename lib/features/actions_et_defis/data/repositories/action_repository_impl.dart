import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/exceptions.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/habitude_entity.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/user_active_action_entity.dart';

import '../../domain/entities/action_entity.dart';
import '../../domain/repositories/action_repository.dart';
import '../datasources/action_remote_data_source.dart';

class ActionRepositoryImpl implements ActionRepository {
  final ActionRemoteDataSource remoteDataSource;
  ActionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> addToMyActions(
    String userId,
    String actionId,
  ) async {
    try {
      // Logique métier : Vérification du quota de 5 actions
      final currentActions = await remoteDataSource.fetchMyActiveActions(
        userId,
      );
      if (currentActions.length >= 5) {
        return left(Failure('Limite de 5 actions actives atteinte.'));
      }

      await remoteDataSource.addToMyActions(userId, actionId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> validateAction(
    String userId,
    String actionId,
  ) async {
    try {
      await remoteDataSource.validateAction(userId, actionId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ActionEntity>>> getActions(String userId) async {
    try {
      final actions = await remoteDataSource.fetchActions(userId);
      return right(actions);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<UserActiveActionEntity>>> getMyActiveActions(
    String userId,
  ) async {
    try {
      final actions = await remoteDataSource.fetchMyActiveActions(userId);
      return right(actions);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromMyActions(
    String userId,
    String actionId,
  ) async {
    try {
      await remoteDataSource.removeFromMyActions(userId, actionId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addToHabitudes(
    String userId,
    String actionId,
  ) async {
    try {
      await remoteDataSource.addToHabitudes(userId, actionId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromHabitudes(
    String userId,
    String actionId,
  ) async {
    try {
      await remoteDataSource.removeFromHabitudes(userId, actionId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<HabitudeEntity>>> getMyHabitudes(
    String userId,
  ) async {
    try {
      final habitudes = await remoteDataSource.fetchMyHabitudes(userId);
      return right(habitudes);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> promoteActionToHabitude(
    String userId,
    String actionId,
  ) async {
    try {
      await remoteDataSource.addToHabitudes(userId, actionId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
