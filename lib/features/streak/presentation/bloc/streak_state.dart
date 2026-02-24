import 'package:equatable/equatable.dart';
import 'package:oikos/features/streak/domain/entities/streak_step_entity.dart';
import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';

enum StreakEvolution { increase, lost, reset, none }

sealed class StreakState extends Equatable {
  final UtilisateurStreakEntity streak;
  final List<String>? allStreakPaths;
  final int? actionsIndividuelles;
  final bool? hasCompletedActionCommunautaire;
  final List<StreakStepEntity>? streakSteps;

  const StreakState({
    required this.streak,
    this.allStreakPaths,
    this.actionsIndividuelles = 0,
    this.hasCompletedActionCommunautaire = false,
    this.streakSteps,
  });

  @override
  List<Object?> get props => [
    streak,
    allStreakPaths,
    actionsIndividuelles,
    hasCompletedActionCommunautaire,
    streakSteps,
  ];
}

class StreakUpdated extends StreakState {
  final StreakEvolution evolution;

  const StreakUpdated({
    required super.streak,
    required this.evolution,
    super.allStreakPaths,
    super.actionsIndividuelles,
    super.hasCompletedActionCommunautaire,
    super.streakSteps,
  });

  @override
  List<Object?> get props => [...super.props, evolution];
}

class StreakLoading extends StreakState {
  const StreakLoading() : super(streak: const UtilisateurStreakEntity.empty());

  @override
  List<Object?> get props => [];
}

class StreakSeasonFinished extends StreakState {
  const StreakSeasonFinished({required super.streak});
}

class StreakError extends StreakState {
  final String message;

  StreakError(this.message) : super(streak: UtilisateurStreakEntity.empty());
}
