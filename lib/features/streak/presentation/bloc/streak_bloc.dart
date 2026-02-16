import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/streak/domain/entities/utilisateur_streak_entity.dart';
import 'package:oikos/features/streak/domain/use_cases/calculer_progres_use_case.dart';
import 'package:oikos/features/streak/domain/use_cases/get_streak_use_case.dart';
import 'package:oikos/features/streak/domain/use_cases/recuperer_streak_steps_use_case.dart';
import 'package:oikos/features/streak/domain/use_cases/watch_streak_use_case.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_event.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final WatchStreakUseCase watchStreakUseCase;
  final GetStreakUseCase getStreakUseCase;
  final CalculerProgresUseCase calculerActionsRealiseesUseCase;
  final RecupererStreakStepsUseCase recupererStreakStepsUseCase;

  StreakBloc(
    this.watchStreakUseCase,
    this.getStreakUseCase,
    this.calculerActionsRealiseesUseCase,
    this.recupererStreakStepsUseCase,
  ) : super(StreakIdle(streak: UtilisateurStreakEntity.empty())) {
    on<WatchStreakEvent>(_onWatchStreak);
    on<SeasonFinishedEvent>((event, emit) {
      emit(StreakSeasonFinished(streak: state.streak));
    });
  }

  Future<void> _onWatchStreak(
    WatchStreakEvent event,
    Emitter<StreakState> emit,
  ) async {
    emit(StreakLoading());
    if (event.userId.isEmpty) return;

    // chargement initial du streak
    final currentStreak = await getStreakUseCase(event.userId);
    // Vérification de la fin de saison
    final bool isFinished =
        currentStreak.saisonFin?.isBefore(DateTime.now()) ?? false;
    if (isFinished) {
      emit(StreakSeasonFinished(streak: currentStreak));
      return;
    }

    final streakSteps = await recupererStreakStepsUseCase();

    // calcul des actions réalisées pour la barre de progression
    await emit.onEach<UtilisateurStreakEntity>(
      watchStreakUseCase(event.userId, event.entrepriseId),
      onData: (streakEntity) async {
        final streamSaisonDebut = streakEntity.saisonDebut;
        if (streamSaisonDebut == null) {
          emit(StreakError("Aucune saison en cours, reviens plus tard !"));
          return;
        }

        final (
          actionsQuotidiennes,
          hasCompletedActionCommunautaire,
        ) = await calculerActionsRealiseesUseCase(
          event.userId,
          streakEntity.currentStreak,
        );

        emit(
          StreakUpdated(
            streak: streakEntity,
            evolution: _calculateEvolution(state.streak, streakEntity),
            actionsQuotidiennes: actionsQuotidiennes,
            hasCompletedActionCommunautaire: hasCompletedActionCommunautaire,
            streakSteps: streakSteps,
          ),
        );
      },
      onError: (error, stackTrace) {},
    );
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
