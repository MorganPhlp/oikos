import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/habitude_entity.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/user_active_action_entity.dart';

import '../entities/action_entity.dart';

abstract interface class ActionRepository {
  Future<Either<Failure, List<ActionEntity>>> getActions(String userId);
  Future<Either<Failure, List<UserActiveActionEntity>>> getMyActiveActions(
    String userId,
  );
  Future<Either<Failure, void>> addToMyActions(String userId, String actionId);

  // Correction ici : On retire l'argument int xp
  Future<Either<Failure, void>> validateAction(String userId, String actionId);

  Future<Either<Failure, void>> removeFromMyActions(
    String userId,
    String actionId,
  );

  Future<Either<Failure, void>> addToHabitudes(String userId, String actionId);
  Future<Either<Failure, void>> removeFromHabitudes(
    String userId,
    String actionId,
  );
  Future<Either<Failure, List<HabitudeEntity>>> getMyHabitudes(String userId);
}
