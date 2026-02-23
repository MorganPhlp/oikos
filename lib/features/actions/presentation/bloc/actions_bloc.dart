import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/actions/domain/entities/limite_action_freq_entity.dart';
import 'package:oikos/features/actions/domain/usecases/ecarter_action_use_case.dart';
import 'package:oikos/features/actions/domain/usecases/ecarter_categorie_use_case.dart';
import 'package:oikos/features/actions/domain/usecases/ecarter_tag_use_case.dart';
import 'package:oikos/features/actions/domain/usecases/get_limite_actions_freq_use_case.dart';
import 'package:oikos/features/actions/domain/usecases/get_my_habitudes_use_case.dart';
import 'package:oikos/features/actions/domain/usecases/promote_to_habitude_use_case.dart';

import '../../domain/usecases/get_actions.dart';
import '../../domain/usecases/get_my_active_actions_use_case.dart';
import '../../domain/usecases/add_to_my_actions_use_case.dart';
import '../../domain/usecases/remove_from_my_actions_use_case.dart';
import '../../domain/usecases/validate_action_use_case.dart';
import 'actions_event.dart';
import 'actions_state.dart';

class ActionsBloc extends Bloc<ActionsEvent, ActionsState> {
  final GetActionsUseCase _getActions;
  final GetMyActiveActionsUseCase _getMyActiveActions;
  final AddToMyActionsUseCase _addToMyActions;
  final ValidateActionUseCase _validateAction;
  final RemoveFromMyActionsUseCase _removeFromMyActions;
  final GetMyHabitudesUseCase _getMyHabitudes;
  final PromoteToHabitudeUseCase _promoteActionToHabitude;
  final GetLimiteActionsFreqUseCase _getLimiteActionsFreqUseCase;
  final EcarterActionUseCase _ecarterAction;
  final EcarterCategorieUseCase _ecarterCategorie;
  final EcarterTagUseCase _ecarterTag;

  ActionsBloc({
    required GetActionsUseCase getActions,
    required GetMyActiveActionsUseCase getMyActiveActions,
    required AddToMyActionsUseCase addToMyActions,
    required ValidateActionUseCase validateAction,
    required RemoveFromMyActionsUseCase removeFromMyActions,
    required GetMyHabitudesUseCase getMyHabitudes,
    required PromoteToHabitudeUseCase promoteActionToHabitude,
    required GetLimiteActionsFreqUseCase getLimiteActionsFreq,
    required EcarterActionUseCase ecarterAction,
    required EcarterCategorieUseCase ecarterCategorie,
    required EcarterTagUseCase ecarterTag,
  }) : _getActions = getActions,
       _getMyActiveActions = getMyActiveActions,
       _addToMyActions = addToMyActions,
       _validateAction = validateAction,
       _removeFromMyActions = removeFromMyActions,
       _ecarterAction = ecarterAction,
       _ecarterCategorie = ecarterCategorie,
       _ecarterTag = ecarterTag,
       _getMyHabitudes = getMyHabitudes,
       _promoteActionToHabitude = promoteActionToHabitude,
       _getLimiteActionsFreqUseCase = getLimiteActionsFreq,
       super(const ActionsInitial()) {
    on<LoadAllActionsEvent>(_onLoadAllActions);
    on<AddToMyActionsEvent>(_onAddToMyActions);
    on<ValidateActionEvent>(_onValidateAction);
    on<RemoveFromMyActionsEvent>(_onRemoveFromMyActions);
    on<PromoteActionToHabitudeEvent>(_onPromoteToHabitude);
    on<EcarterActionEvent>(_onEcarterAction);
    on<EcarterCategorieEvent>(_onEcarterCategorie);
    on<EcarterTagEvent>(_onEcarterTag);
  }

  Future<void> _onLoadAllActions(
    LoadAllActionsEvent event,
    Emitter<ActionsState> emit,
  ) async {
    if (state is! ActionsLoaded && state is! ActionOperationSuccess) {
      emit(const ActionsLoading());
    }

    final catalogueResult = await _getActions(event.userId);
    final activeActionsResult = await _getMyActiveActions(event.userId);
    final habitudes = await _getMyHabitudes(event.userId);
    final limitActionsFreq = await _getLimiteActionsFreqUseCase();

    if (catalogueResult.isLeft() ||
        activeActionsResult.isLeft() ||
        habitudes.isLeft() ||
        limitActionsFreq.isLeft()) {
      final errorMsg = catalogueResult.fold(
        (f) => f.message,
        (_) => activeActionsResult.fold(
          (f) => f.message,
          (_) => habitudes.fold(
            (f) => f.message,
            (_) => limitActionsFreq.fold(
              (f) => f.message,
              (_) => 'Erreur chargement des actions',
            ),
          ),
        ),
      );
      emit(ActionsError(errorMsg));
      return;
    }

    emit(
      ActionsLoaded(
        catalogue: catalogueResult.getOrElse((_) => []),
        mesActions: activeActionsResult.getOrElse((_) => []),
        limiteActionsFreq: limitActionsFreq.getOrElse((_) => []),
      ),
    );
  }

  Future<void> _onAddToMyActions(
    AddToMyActionsEvent event,
    Emitter<ActionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is ActionsLoaded) {
      final actionToAdd = currentState.catalogue.firstWhere(
        (a) => a.id == event.actionId,
      );

      final isLimitReached = currentState.mesActions.isLimitReached(
        currentState.limiteActionsFreq,
        actionToAdd,
      );

      if (isLimitReached) {
        emit(
          ActionsError(
            'Limite atteinte pour les actions ${actionToAdd.frequency}.',
          ),
        );
        emit(currentState);
        return;
      }

      final result = await _addToMyActions(
        AddToMyActionsParams(userId: event.userId, actionId: event.actionId),
      );

      result.fold((failure) => emit(ActionsError(failure.message)), (_) {
        emit(const ActionOperationSuccess('Action ajoutée !'));
        add(LoadAllActionsEvent(event.userId));
      });
    }
  }

  Future<void> _onValidateAction(
    ValidateActionEvent event,
    Emitter<ActionsState> emit,
  ) async {
    final result = await _validateAction(
      ValidateActionParams(userId: event.userId, actionId: event.actionId),
    );

    result.fold(
      (failure) => emit(ActionsError(failure.message)),
      (_) => add(LoadAllActionsEvent(event.userId)),
    );
  }

  Future<void> _onRemoveFromMyActions(
    RemoveFromMyActionsEvent event,
    Emitter<ActionsState> emit,
  ) async {
    final result = await _removeFromMyActions(
      RemoveFromMyActionsParams(userId: event.userId, actionId: event.actionId),
    );

    result.fold(
      (failure) => emit(ActionsError(failure.message)),
      (_) => add(LoadAllActionsEvent(event.userId)),
    );
  }

  Future<void> _onPromoteToHabitude(
    PromoteActionToHabitudeEvent event,
    Emitter<ActionsState> emit,
  ) async {
    final result = await _promoteActionToHabitude(event.userId, event.actionId);
    result.fold(
      (failure) => emit(ActionsError(failure.message)),
      (_) => add(LoadAllActionsEvent(event.userId)),
    );
  }

  Future<void> _onEcarterAction(
    EcarterActionEvent event,
    Emitter<ActionsState> emit,
  ) async {
    final result = await _ecarterAction(event.userId, event.actionId);
    result.fold(
      (failure) => emit(ActionsError(failure.message)),
      (_) => add(LoadAllActionsEvent(event.userId)),
    );
  }

  Future<void> _onEcarterCategorie(
    EcarterCategorieEvent event,
    Emitter<ActionsState> emit,
  ) async {
    final result = await _ecarterCategorie(event.userId, event.categorieNom);
    result.fold(
      (failure) => emit(ActionsError(failure.message)),
      (_) => add(LoadAllActionsEvent(event.userId)),
    );
  }

  Future<void> _onEcarterTag(
    EcarterTagEvent event,
    Emitter<ActionsState> emit,
  ) async {
    final result = await _ecarterTag(event.userId, event.tagNom);
    result.fold(
      (failure) => emit(ActionsError(failure.message)),
      (_) => add(LoadAllActionsEvent(event.userId)),
    );
  }
}
