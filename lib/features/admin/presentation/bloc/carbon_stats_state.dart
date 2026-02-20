import 'package:oikos/features/admin/domain/entities/co2_performance_data.dart';

abstract class CarbonStatsState {}

class Co2PerformanceInitial extends CarbonStatsState {}

class Co2PerformanceLoading extends CarbonStatsState {}

class Co2PerformanceLoaded extends CarbonStatsState {
  final Co2PerformanceData data;

  Co2PerformanceLoaded({required this.data});
}

class Co2PerformanceError extends CarbonStatsState {
  final String message;
  Co2PerformanceError({required this.message});
}
