import 'package:freezed_annotation/freezed_annotation.dart';

part 'carbon_footprint_data.freezed.dart';
part 'carbon_footprint_data.g.dart';

@freezed
sealed class CarbonFootprintData with _$CarbonFootprintData {
  const factory CarbonFootprintData({
    required DateTime period,
    @JsonKey(name: 'average_co2') required double averageCo2,
  }) = _CarbonFootprintData;

  factory CarbonFootprintData.fromJson(Map<String, dynamic> json) =>
      _$CarbonFootprintDataFromJson(json);
}
