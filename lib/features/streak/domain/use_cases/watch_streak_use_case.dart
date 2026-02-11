import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';
import 'package:oikos/features/streak/domain/repositories/streak_repository.dart';

class WatchStreakUseCase {
  final StreakRepository repository;

  WatchStreakUseCase(this.repository);

  Stream<UtilisateurStreakEntity> call(String userId) {
    return repository.watchStreak(userId);
  }
}
