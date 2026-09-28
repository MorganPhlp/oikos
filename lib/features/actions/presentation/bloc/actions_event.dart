import 'package:equatable/equatable.dart';

sealed class ActionsEvent extends Equatable {
  const ActionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllActionsEvent extends ActionsEvent {
  final String userId;

  const LoadAllActionsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class PromoteActionToHabitudeEvent extends ActionsEvent {
  final String userId;
  final String actionId;

  const PromoteActionToHabitudeEvent({
    required this.userId,
    required this.actionId,
  });

  @override
  List<Object?> get props => [userId, actionId];
}

class AddToMyActionsEvent extends ActionsEvent {
  final String userId;
  final String actionId;

  const AddToMyActionsEvent({required this.userId, required this.actionId});

  @override
  List<Object?> get props => [userId, actionId];
}

class ValidateActionEvent extends ActionsEvent {
  final String userId;
  final String actionId;

  const ValidateActionEvent({required this.userId, required this.actionId});

  @override
  List<Object?> get props => [userId, actionId];
}

class RemoveFromMyActionsEvent extends ActionsEvent {
  final String userId;
  final String actionId;

  const RemoveFromMyActionsEvent({
    required this.userId,
    required this.actionId,
  });

  @override
  List<Object?> get props => [userId, actionId];
}

class OpenActionDetailsEvent extends ActionsEvent {
  final String actionId;

  const OpenActionDetailsEvent(this.actionId);

  @override
  List<Object?> get props => [actionId];
}

class EcarterActionEvent extends ActionsEvent {
  final String userId;
  final String actionId;

  const EcarterActionEvent({required this.userId, required this.actionId});

  @override
  List<Object?> get props => [userId, actionId];
}

class EcarterCategorieEvent extends ActionsEvent {
  final String userId;
  final String categorieNom;

  const EcarterCategorieEvent({
    required this.userId,
    required this.categorieNom,
  });

  @override
  List<Object?> get props => [userId, categorieNom];
}

class EcarterTagEvent extends ActionsEvent {
  final String userId;
  final String tagNom;

  const EcarterTagEvent({required this.userId, required this.tagNom});

  @override
  List<Object?> get props => [userId, tagNom];
}
