import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/action_ecartee_entity.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/categorie_ecartee_entity.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/tag_ecarte_entity.dart';
import '../entities/action_entity.dart';
import '../repositories/action_repository.dart';

class GetActionsUseCase {
  final ActionRepository repository;

  GetActionsUseCase(this.repository);

  Future<Either<Failure, List<ActionEntity>>> call(String userId) async {
    final results = await Future.wait([
      repository.getActions(userId),
      repository.getActionsEcartees(userId),
      repository.getCategoriesEcartees(userId),
      repository.getTagsEcartees(userId),
    ]);

    final actionsRes = results[0] as Either<Failure, List<ActionEntity>>;
    final ecarteesRes =
        results[1] as Either<Failure, List<ActionEcarteeEntity>>;
    final catsRes = results[2] as Either<Failure, List<CategorieEcarteeEntity>>;
    final tagsRes = results[3] as Either<Failure, List<TagEcarteEntity>>;

    return actionsRes.flatMap((actionsList) {
      final ecarteeIds = ecarteesRes
          .getOrElse((_) => [])
          .map((e) => e.id)
          .toSet();
      final ecarteeCats = catsRes
          .getOrElse((_) => [])
          .map((e) => e.nom.toLowerCase())
          .toSet();
      final ecarteeTags = tagsRes
          .getOrElse((_) => [])
          .map((e) => e.nom.toLowerCase())
          .toSet();

      final filtered = actionsList.where((action) {
        final isActionBlocked = ecarteeIds.contains(action.id);

        final isCatBlocked = ecarteeCats.contains(
          action.categoryName.toLowerCase(),
        );

        final isTagBlocked = action.tags.any(
          (tag) => ecarteeTags.contains(tag.toLowerCase()),
        );

        return !isActionBlocked && !isCatBlocked && !isTagBlocked;
      }).toList();

      return Right(filtered);
    });
  }
}
