import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';

abstract class StreakRepository {
  Future<UtilisateurStreakEntity> getCurrentStreak(String userId);
  Stream<UtilisateurStreakEntity> watchStreak(String userId);
}
