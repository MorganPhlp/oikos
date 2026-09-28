import 'package:freezed_annotation/freezed_annotation.dart';

part 'carbon_time_series.freezed.dart';
part 'carbon_time_series.g.dart';

@freezed
sealed class CarbonTimeSeries with _$CarbonTimeSeries {
  const factory CarbonTimeSeries({
    required DateTime period,
    @JsonKey(name: 'average_co2') required double averageCo2,
  }) = _CarbonTimeSeries;

  factory CarbonTimeSeries.fromJson(Map<String, dynamic> json) =>
      _$CarbonTimeSeriesFromJson(json);
}
