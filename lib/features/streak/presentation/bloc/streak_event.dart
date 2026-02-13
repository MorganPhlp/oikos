import 'package:equatable/equatable.dart';
import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';

class StreakEvent extends Equatable {
  const StreakEvent();

  @override
  List<Object?> get props => [];
}

class WatchStreakEvent extends StreakEvent {
  final String userId;
  final String entrepriseId;

  const WatchStreakEvent(this.userId, this.entrepriseId);

  @override
  List<Object?> get props => [userId];
}

class StreakUpdatedEvent extends StreakEvent {
  final UtilisateurStreakEntity currentStreak;

  const StreakUpdatedEvent(this.currentStreak);

  @override
  List<Object?> get props => [currentStreak];
}
