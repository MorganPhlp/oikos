import 'package:equatable/equatable.dart';
import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';

enum StreakEvolution { increase, lost, reset, none }

sealed class StreakState extends Equatable {
  final UtilisateurStreakEntity streak;

  const StreakState({required this.streak});

  @override
  List<Object?> get props => [streak];
}

class StreakIdle extends StreakState {
  const StreakIdle({required super.streak});
}

class StreakUpdated extends StreakState {
  final StreakEvolution evolution;

  const StreakUpdated({required super.streak, required this.evolution});

  @override
  List<Object?> get props => [...super.props, evolution];
}
