import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';
import 'package:oikos/features/streak/domain/use_cases/get_streak_use_case.dart';
import 'package:oikos/features/streak/domain/use_cases/watch_streak_use_case.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_event.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final WatchStreakUseCase watchStreakUseCase;
  final GetStreakUseCase getStreakUseCase;

  StreakBloc(this.watchStreakUseCase, this.getStreakUseCase)
    : super(StreakIdle(streak: UtilisateurStreakEntity.empty())) {
    on<WatchStreakEvent>(_onWatchStreak);
    on<StreakUpdatedEvent>(_onStreakUpdated);
  }

  Future<void> _onWatchStreak(
    WatchStreakEvent event,
    Emitter<StreakState> emit,
  ) async {
    if (event.userId.isEmpty) return;

    // chargement initial du streak
    final currentStreak = await getStreakUseCase(event.userId);
    emit(StreakIdle(streak: currentStreak));
    await emit.forEach<UtilisateurStreakEntity>(
      watchStreakUseCase(event.userId),
      onData: (streakEntity) {
        return StreakUpdated(
          streak: streakEntity,
          evolution: _calculateEvolution(state.streak, streakEntity),
        );
      },
      onError: (error, stackTrace) {
        // En cas d'erreur, on garde l'état actuel (ou on émet une erreur)
        return state;
      },
    );
  }

  void _onStreakUpdated(StreakUpdatedEvent event, Emitter<StreakState> emit) {
    final evolution = _calculateEvolution(state.streak, event.currentStreak);

    emit(StreakUpdated(streak: event.currentStreak, evolution: evolution));
  }

  // Petite logique bonus pour déterminer ce qui s'est passé
  StreakEvolution _calculateEvolution(
    UtilisateurStreakEntity oldS,
    UtilisateurStreakEntity newS,
  ) {
    if (oldS.currentStreak == 0 && newS.currentStreak == 0) {
      return StreakEvolution.none;
    }
    if (newS.currentStreak > oldS.currentStreak) {
      return StreakEvolution.increase;
    }
    if (newS.currentStreak < oldS.currentStreak && newS.currentStreak != 0) {
      return StreakEvolution.reset;
    }
    if (newS.currentStreak == 0 && oldS.currentStreak > 0) {
      return StreakEvolution.lost;
    }
    return StreakEvolution.none;
  }
}
