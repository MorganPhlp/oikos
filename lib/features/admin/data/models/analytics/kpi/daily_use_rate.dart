import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_use_rate.freezed.dart';
part 'daily_use_rate.g.dart';

@freezed
sealed class DailyUseRateKPI with _$DailyUseRateKPI {
  const factory DailyUseRateKPI({
    @JsonKey(name: 'taux_utilisation_jour') required num dailyUseRate,
    @JsonKey(name: 'objectif_taux_utilisation_jour') required num dailyUseRateObjective,
  }) = _DailyUseRateKPI;
  
  factory DailyUseRateKPI.fromJson(Map<String, dynamic> json) =>
      _$DailyUseRateKPIFromJson(json);
}