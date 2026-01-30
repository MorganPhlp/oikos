import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/usecase/usecase.dart';
import '../../domain/usecases/get_my_profile.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMyPseudo _getMyPseudo;

  HomeBloc({
    required GetMyPseudo getMyPseudo,
  })  : _getMyPseudo = getMyPseudo,
        super(HomeInitial()) {
    on<HomeLoadRequested>(_onHomeLoadRequested);
  }

  Future<void> _onHomeLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    final res = await _getMyPseudo(NoParams());

    res.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (pseudo) => emit(HomeLoaded(pseudo: pseudo)),
    );
  }
}
