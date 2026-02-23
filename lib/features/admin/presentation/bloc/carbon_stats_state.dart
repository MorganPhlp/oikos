import 'package:oikos/features/admin/domain/entities/carbon_foot_print.dart';

abstract class CarbonStatsState {}

class CarbonFootPrintInitial extends CarbonStatsState {}

class CarbonFootPrintLoading extends CarbonStatsState {}

class CarbonFootPrintLoaded extends CarbonStatsState {
  final CarbonFootPrintData data;

  CarbonFootPrintLoaded({required this.data});
}

class CarbonFootPrintError extends CarbonStatsState {
  final String message;
  CarbonFootPrintError({required this.message});
}
