import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_event.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';

class StreakBloc extends Bloc<StreakState, StreakEvent> {
  StreakBloc(super.initialState);
}
