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
  }

  Future<void> _onWatchStreak(
    WatchStreakEvent event,
    Emitter<StreakState> emit,
  ) async {
    emit(StreakLoading());
    if (event.userId.isEmpty) return;

    // chargement initial du streak
    final currentStreak = await getStreakUseCase(event.userId);
    // si pas de saison active on emet StreakNoSeason, sinon on continue
    if (currentStreak.saisonNom == null) {
      emit(StreakError("Aucune saison en cours, reviens plus tard !"));
      return;
    }

    // calcul des actions réalisées pour afficher une barre de progression dès le départ
    final (
      actionsQuotidiennes,
      hasCompletedActionCommunautaire,
    ) = await calculerActionsRealiseesUseCase(
      event.userId,
      currentStreak.lastUpdated,
    );

    // On recupere les conditions de progression pour la streak
    final streakSteps = await recupererStreakStepsUseCase();

    emit(
      StreakIdle(
        streak: currentStreak,
        actionsQuotidiennes: actionsQuotidiennes,
        hasCompletedActionCommunautaire: hasCompletedActionCommunautaire,
        streakSteps: streakSteps,
      ),
    );

    await emit.onEach<UtilisateurStreakEntity>(
      watchStreakUseCase(event.userId, event.entrepriseId),
      onData: (streakEntity) async {
        final (
          actionsQuotidiennes,
          hasCompletedActionCommunautaire,
        ) = await calculerActionsRealiseesUseCase(
          event.userId,
          streakEntity.lastUpdated,
        );
        emit(
          StreakUpdated(
            streak: streakEntity,
            evolution: _calculateEvolution(state.streak, streakEntity),
            actionsQuotidiennes: actionsQuotidiennes,
            hasCompletedActionCommunautaire: hasCompletedActionCommunautaire,
            streakSteps: state.streakSteps,
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
