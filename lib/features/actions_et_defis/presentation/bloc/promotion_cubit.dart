import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/user_active_action_entity.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/promotion_state.dart';

class PromoteActionsCubit extends Cubit<PrommotionState> {
  PromoteActionsCubit({required List<UserActiveActionEntity> actions})
    : super(PrommotionState(actions: actions));

  void promoteCurrentAction() {
    if (!state.isDone) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void discardCurrentAction() {
    if (!state.isDone) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  
}
