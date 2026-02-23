import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions/domain/entities/action_ecartee_entity.dart';
import 'package:oikos/features/actions/domain/entities/categorie_ecartee_entity.dart';
import 'package:oikos/features/actions/domain/entities/habitude_entity.dart';
import 'package:oikos/features/actions/domain/entities/limite_action_freq_entity.dart';
import 'package:oikos/features/actions/domain/entities/tag_ecarte_entity.dart';
import 'package:oikos/features/actions/domain/entities/user_active_action_entity.dart';

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
  Future<Either<Failure, void>> promoteActionToHabitude(
    String userId,
    String actionId,
  );

  Future<Either<Failure, List<LimiteActionFreqEntity>>> getLimiteActionsFreq();

  Future<Either<Failure, void>> ecarterAction(String userId, String actionId);
  Future<Either<Failure, void>> ecarterCategorie(
    String userId,
    String categorieNom,
  );
  Future<Either<Failure, void>> ecarterTag(String userId, String tagNom);

  Future<Either<Failure, List<ActionEcarteeEntity>>> getActionsEcartees(
    String userId,
  );
  Future<Either<Failure, List<CategorieEcarteeEntity>>> getCategoriesEcartees(
    String userId,
  );
  Future<Either<Failure, List<TagEcarteEntity>>> getTagsEcartees(String userId);
}
