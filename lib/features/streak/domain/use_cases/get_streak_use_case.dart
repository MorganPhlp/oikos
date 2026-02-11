import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';
import 'package:oikos/features/streak/domain/repositories/streak_repository.dart';

class GetStreakUseCase {
  final StreakRepository streakRepository;

  GetStreakUseCase({required this.streakRepository});

  Future<UtilisateurStreakEntity> call(String userId) {
    return streakRepository.getCurrentStreak(userId);
  }
}
