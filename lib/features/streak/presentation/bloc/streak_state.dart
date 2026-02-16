import 'package:equatable/equatable.dart';
import 'package:oikos/features/streak/domain/entities/streak_step_entity.dart';
import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';

enum StreakEvolution { increase, lost, reset, none }

sealed class StreakState extends Equatable {
  final UtilisateurStreakEntity streak;
  final List<String>? allStreakPaths;
  final int? actionsQuotidiennes;
  final bool? hasCompletedActionCommunautaire;
  final List<StreakStepEntity>? streakSteps;

  const StreakState({
    required this.streak,
    this.allStreakPaths,
    this.actionsQuotidiennes = 0,
    this.hasCompletedActionCommunautaire = false,
    this.streakSteps,
  });

  @override
  List<Object?> get props => [
    streak,
    allStreakPaths,
    actionsQuotidiennes,
    hasCompletedActionCommunautaire,
    streakSteps,
  ];
}

class StreakIdle extends StreakState {
  const StreakIdle({
    required super.streak,
    super.allStreakPaths,
    super.actionsQuotidiennes,
    super.hasCompletedActionCommunautaire,
    super.streakSteps,
  });
}

class StreakUpdated extends StreakState {
  final StreakEvolution evolution;

  const StreakUpdated({
    required super.streak,
    required this.evolution,
    super.allStreakPaths,
    super.actionsQuotidiennes,
    super.hasCompletedActionCommunautaire,
    super.streakSteps,
  });

  @override
  List<Object?> get props => [...super.props, evolution];
}

class StreakLoading extends StreakState {
  StreakLoading() : super(streak: UtilisateurStreakEntity.empty());
}

class StreakSeasonFinished extends StreakState {
  const StreakSeasonFinished({required super.streak});
}

class StreakError extends StreakState {
  final String message;

  StreakError(this.message) : super(streak: UtilisateurStreakEntity.empty());
}
