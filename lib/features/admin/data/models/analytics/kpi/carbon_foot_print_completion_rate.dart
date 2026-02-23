import 'package:freezed_annotation/freezed_annotation.dart';

part 'carbon_foot_print_completion_rate.freezed.dart';
part 'carbon_foot_print_completion_rate.g.dart';

@freezed
sealed class CarbonFootPrintCompletionRateKPI with _$CarbonFootPrintCompletionRateKPI {
  const factory CarbonFootPrintCompletionRateKPI({
    @JsonKey(name: 'completion_bilan_carbone_minimale') required num carbonFootPrintMinimalCompletionRate,
    @JsonKey(name: 'completion_bilan_carbone_detaille') required num carbonFootPrintDetailledCompletionRate,
    
    @JsonKey(name: 'objectif_completion_bilan_carbone_minimale') required num carbonFootPrintMinimalCompletionRateObjective,
    @JsonKey(name: 'objectif_completion_bilan_carbone_detaille') required num carbonFootPrintDetailledCompletionRateObjective,
  }) = _CarbonFootPrintCompletionRateKPI;

  factory CarbonFootPrintCompletionRateKPI.fromJson(Map<String, dynamic> json) =>
      _$CarbonFootPrintCompletionRateKPIFromJson(json);
}