import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/action_entity.dart';
import '../../domain/repositories/action_repository.dart';

// EVENTS
abstract class ActionsEvent {}
class LoadAllDataEvent extends ActionsEvent {
  final String userId;
  LoadAllDataEvent(this.userId);
}

// STATES
abstract class ActionsState {}
class ActionsInitial extends ActionsState {}
class ActionsLoading extends ActionsState {}
class ActionsError extends ActionsState { final String message; ActionsError(this.message); }

class ActionsLoaded extends ActionsState {
  final List<ActionEntity> catalogue; // Onglet 1
  final List<ActionEntity> mesDefis;  // Onglet 2

  ActionsLoaded({required this.catalogue, required this.mesDefis});
}

// BLOC
class ActionsBloc extends Bloc<ActionsEvent, ActionsState> {
  final ActionRepository repository;

  ActionsBloc({required this.repository}) : super(ActionsInitial()) {

    on<LoadAllDataEvent>((event, emit) async {
      emit(ActionsLoading());
      try {
        // 1. On lance les deux requêtes en parallèle
        final results = await Future.wait([
          repository.getActions(event.userId),      // Index 0
          repository.getMyChallenges(event.userId), // Index 1
        ]);

        // 2. On émet le résultat
        emit(ActionsLoaded(
            catalogue: results[0],
            mesDefis: results[1]
        ));
      } catch (e) {
        emit(ActionsError("Erreur chargement : $e"));
      }
    });
  }
}