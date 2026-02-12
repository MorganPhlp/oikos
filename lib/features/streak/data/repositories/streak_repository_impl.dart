import 'package:oikos/features/streak/data/datasources/streak_remote_datasource.dart';
import 'package:oikos/features/streak/data/models/streak_model.dart';
import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';
import 'package:oikos/features/streak/domain/repositories/streak_repository.dart';
import 'package:rxdart/rxdart.dart';

class StreakRepositoryImpl implements StreakRepository {
  final StreakRemoteDatasource remoteDatasource;

  StreakRepositoryImpl(this.remoteDatasource);

  UtilisateurStreakEntity _mapToEntity(Map<String, dynamic> map) {
    if (map.isEmpty) return UtilisateurStreakEntity.empty();

    final model = StreakModel.fromJson(map);

    final String generatedLogoUrl = remoteDatasource.supabaseClient.storage
        .from('streak')
        .getPublicUrl('${model.entrepriseName}/${model.streakThemePath}/${model.currentStreak}.png');

    return UtilisateurStreakEntity(
      utilisateurId: model.utilisateurId,
      currentStreak: model.currentStreak,
      lastUpdated: model.lastUpdated,
      saisonNom: model.saisonNom,
      saisonDebut: model.saisonDebut,
      saisonFin: model.saisonFin,
      logoUrl: generatedLogoUrl,
    );
  }

  @override
  Future<UtilisateurStreakEntity> getCurrentStreak(String userId) async {
    final map = await remoteDatasource.getRawStreak(userId);
    return _mapToEntity(map);
  }

  @override
  Stream<UtilisateurStreakEntity> watchStreak(String userId, String entrepriseId) {
    final streakStream = remoteDatasource.getRawStreakStream(userId);
    final saisonStream = remoteDatasource.getSaisonStream(entrepriseId);

    return Rx.combineLatest2(
      streakStream,
      saisonStream,
      (streakData, saisonData) => remoteDatasource.getRawStreak(userId),
    ).switchMap((future) => Stream.fromFuture(future)).map((map) {
      if (map.isEmpty) return UtilisateurStreakEntity.empty();
      return _mapToEntity(map);
    }).asBroadcastStream();
  }
}
