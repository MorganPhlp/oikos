// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carbon_foot_print_completion_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarbonFootPrintCompletionRateKPI _$CarbonFootPrintCompletionRateKPIFromJson(
  Map<String, dynamic> json,
) => _CarbonFootPrintCompletionRateKPI(
  carbonFootPrintMinimalCompletionRate:
      json['completion_bilan_carbone_minimale'] as num,
  carbonFootPrintDetailledCompletionRate:
      json['completion_bilan_carbone_detaille'] as num,
  carbonFootPrintMinimalCompletionRateObjective:
      json['objectif_completion_bilan_carbone_minimale'] as num,
  carbonFootPrintDetailledCompletionRateObjective:
      json['objectif_completion_bilan_carbone_detaille'] as num,
);

Map<String, dynamic> _$CarbonFootPrintCompletionRateKPIToJson(
  _CarbonFootPrintCompletionRateKPI instance,
) => <String, dynamic>{
  'completion_bilan_carbone_minimale':
      instance.carbonFootPrintMinimalCompletionRate,
  'completion_bilan_carbone_detaille':
      instance.carbonFootPrintDetailledCompletionRate,
  'objectif_completion_bilan_carbone_minimale':
      instance.carbonFootPrintMinimalCompletionRateObjective,
  'objectif_completion_bilan_carbone_detaille':
      instance.carbonFootPrintDetailledCompletionRateObjective,
};
