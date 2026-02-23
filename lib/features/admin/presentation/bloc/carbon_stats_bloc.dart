import 'package:oikos/features/admin/domain/use_cases/get_co2_performance.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_event.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarbonFootPrintBloc extends Bloc<CarbonStatsEvent, CarbonStatsState> {
  final GetCarbonFootPrint getCarbonFootPrint;

  CarbonFootPrintBloc(this.getCarbonFootPrint)
    : super(CarbonFootPrintInitial()) {
    on<CarbonFootPrintfetched>((event, emit) async {
      emit(CarbonFootPrintLoading());
      final result = await getCarbonFootPrint.call(event.companyId);
      result.fold(
        (failure) => emit(CarbonFootPrintError(message: failure.message)),
        (data) => emit(CarbonFootPrintLoaded(data: data)),
      );
    });
  }
}
