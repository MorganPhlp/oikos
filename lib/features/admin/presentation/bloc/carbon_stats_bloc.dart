import 'package:oikos/features/admin/domain/entities/co2_performance_data.dart';
import 'package:oikos/features/admin/domain/use_cases/get_co2_performance.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_event.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Co2PerformanceBloc extends Bloc<CarbonStatsEvent, CarbonStatsState> {
  final GetCo2Performance useCase;

  Co2PerformanceBloc(this.useCase) : super(Co2PerformanceInitial()) {
    on<Co2Performancefetched>((event, emit) async {
      emit(Co2PerformanceLoading());
      try {
        final Co2PerformanceData data = await useCase.call();
        emit(Co2PerformanceLoaded(data: data));
      } catch (e) {
        emit(
          Co2PerformanceError(message: "erreur dans le chargement des données"),
        );
      }
    });
    add(Co2Performancefetched());
  }
}
