import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_active_action_entity.dart';

class PrommotionState {
  final List<UserActiveActionEntity> actions;
  final int currentIndex;

  PrommotionState({required this.actions, this.currentIndex = 0});

  PrommotionState copyWith({
    List<UserActiveActionEntity>? actions,
    int? currentIndex,
  }) {
    return PrommotionState(
      actions: actions ?? this.actions,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  bool get isDone => currentIndex >= actions.length;
}
