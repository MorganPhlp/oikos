import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/actions_et_defis/domain/usecases/get_my_habitudes_use_case.dart';
import 'habitudes_state.dart';

class HabitudeCubit extends Cubit<HabitudeState> {
  final GetMyHabitudesUseCase _getMyHabitudesUseCase;

  HabitudeCubit({required GetMyHabitudesUseCase getMyHabitudesUseCase})
    : _getMyHabitudesUseCase = getMyHabitudesUseCase,
      super(HabitudeInitial());

  Future<void> loadHabitudes(String userId) async {
    emit(HabitudeLoading());

    final result = await _getMyHabitudesUseCase(userId);

    result.fold(
      (failure) => emit(HabitudeError(failure.message)),
      (habitudes) => emit(HabitudeLoaded(habitudes: habitudes)),
    );
  }
}
