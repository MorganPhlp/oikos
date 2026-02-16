import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/usecase/usecase.dart';
import '../../domain/usecases/get_my_profile.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetMyPseudo _getMyPseudo;

  DashboardBloc({
    required GetMyPseudo getMyPseudo,
  })  : _getMyPseudo = getMyPseudo,
        super(DashboardInitial()) {
    on<DashboardLoadRequested>(_onDashboardLoadRequested);
  }

  Future<void> _onDashboardLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final res = await _getMyPseudo(NoParams());

    res.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (pseudo) => emit(DashboardLoaded(pseudo: pseudo)),
    );
  }
}
