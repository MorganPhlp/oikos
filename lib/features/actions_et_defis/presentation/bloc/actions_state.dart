import 'package:equatable/equatable.dart';

import '../../domain/entities/action_entity.dart';
import '../../domain/entities/user_active_action_entity.dart';

sealed class ActionsState extends Equatable {
  const ActionsState();

  @override
  List<Object?> get props => [];
}

class ActionsInitial extends ActionsState {
  const ActionsInitial();
}

class ActionsLoading extends ActionsState {
  const ActionsLoading();
}

class ActionsLoaded extends ActionsState {
  final List<ActionEntity> catalogue;
  final List<UserActiveActionEntity> mesActions;

  const ActionsLoaded({required this.catalogue, required this.mesActions});

  /// IDs des actions déjà dans "mes actions" — utile pour le catalogue.
  Set<String> get activeActionIds => mesActions.map((e) => e.action.id).toSet();

  @override
  List<Object?> get props => [catalogue, mesActions];
}

class ActionsError extends ActionsState {
  final String message;

  const ActionsError(this.message);

  @override
  List<Object?> get props => [message];
}
