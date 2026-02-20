import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/get_my_habitudes_use_case.dart';

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

  ActionsBloc({
    required GetActionsUseCase getActions,
    required GetMyActiveActionsUseCase getMyActiveActions,
    required AddToMyActionsUseCase addToMyActions,
    required ValidateActionUseCase validateAction,
    required RemoveFromMyActionsUseCase removeFromMyActions,
    required GetMyHabitudesUseCase getMyHabitudes,
  }) : _getActions = getActions,
       _getMyActiveActions = getMyActiveActions,
       _addToMyActions = addToMyActions,
       _validateAction = validateAction,
       _removeFromMyActions = removeFromMyActions,
       _getMyHabitudes = getMyHabitudes,
       super(const ActionsInitial()) {
    on<LoadAllActionsEvent>(_onLoadAllActions);
    on<AddToMyActionsEvent>(_onAddToMyActions);
    on<ValidateActionEvent>(_onValidateAction);
    on<RemoveFromMyActionsEvent>(_onRemoveFromMyActions);
  }

  Future<void> _onLoadAllActions(
    LoadAllActionsEvent event,
    Emitter<ActionsState> emit,
  ) async {
    emit(const ActionsLoading());

    final catalogueResult = await _getActions(event.userId);
    final activeActionsResult = await _getMyActiveActions(event.userId);
    final habitudes = await _getMyHabitudes(event.userId);

    if (catalogueResult.isLeft() ||
        activeActionsResult.isLeft() ||
        habitudes.isLeft()) {
      final errorMsg = catalogueResult.fold(
        (f) => f.message,
        (_) => activeActionsResult.fold(
          (f) => f.message,
          (h) => habitudes.fold((f) => f.message, (_) => ''),
        ),
      );
      emit(ActionsError(errorMsg));
      return;
    }

    emit(
      ActionsLoaded(
        catalogue: catalogueResult.getOrElse((_) => []),
        mesActions: activeActionsResult.getOrElse((_) => []),
        mesHabitudes: habitudes.getOrElse((_) => []),
      ),
    );
  }

  Future<void> _onAddToMyActions(
    AddToMyActionsEvent event,
    Emitter<ActionsState> emit,
  ) async {
    final result = await _addToMyActions(
      AddToMyActionsParams(userId: event.userId, actionId: event.actionId),
    );

    result.fold(
      (failure) => emit(ActionsError(failure.message)),
      (_) => add(LoadAllActionsEvent(event.userId)),
    );
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
}
