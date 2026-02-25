import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/actions/domain/usecases/get_my_habitudes_use_case.dart';
import 'package:oikos/features/actions/domain/usecases/remove_from_habitudes_use_case.dart';
import 'habitudes_state.dart';

class HabitudeCubit extends Cubit<HabitudeState> {
  final GetMyHabitudesUseCase _getMyHabitudesUseCase;
  final RemoveHabitudeUseCase _removeHabitudeUseCase;

  HabitudeCubit({
    required GetMyHabitudesUseCase getMyHabitudesUseCase,
    required RemoveHabitudeUseCase removeHabitudeUseCase,
  }) : _getMyHabitudesUseCase = getMyHabitudesUseCase,
       _removeHabitudeUseCase = removeHabitudeUseCase,
       super(HabitudeInitial());

  Future<void> loadHabitudes(String userId) async {
    emit(HabitudeLoading());

    final result = await _getMyHabitudesUseCase(userId);

    result.fold(
      (failure) => emit(HabitudeError(failure.message)),
      (habitudes) => emit(HabitudeLoaded(habitudes: habitudes)),
    );
  }

  Future<void> removeHabitude(String userId, String habitudeId) async {
    final result = await _removeHabitudeUseCase(userId, habitudeId);

    result.fold(
      (failure) => emit(HabitudeError(failure.message)),
      (_) => loadHabitudes(userId),
    );
  }
}
