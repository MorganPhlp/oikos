import 'package:oikos/features/admin/domain/use_cases/get_co2_performance.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_event.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Co2PerformanceBloc extends Bloc<CarbonStatsEvent, CarbonStatsState> {
  final GetCo2Performance getCo2Performance;

  Co2PerformanceBloc(this.getCo2Performance) : super(Co2PerformanceInitial()) {
    on<Co2Performancefetched>((event, emit) async {
      emit(Co2PerformanceLoading());
      final result = await getCo2Performance.call();
      result.fold(
        (failure) => emit(Co2PerformanceError(message: failure.message)),
        (data) => emit(Co2PerformanceLoaded(data: data)),
      );
    });
    add(Co2Performancefetched());
  }
}
