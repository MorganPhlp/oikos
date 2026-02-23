import 'package:freezed_annotation/freezed_annotation.dart';

part 'retention_rate.freezed.dart';
part 'retention_rate.g.dart';

@freezed
sealed class RetentionRateKPI with _$RetentionRateKPI {
  const factory RetentionRateKPI({
    @JsonKey(name: 'j7') required num j7,
    @JsonKey(name: 'j7_objective') required num j7Objective,
    @JsonKey(name: 'j30') required num j30,
    @JsonKey(name: 'j30_objective') required num j30Objective,
    @JsonKey(name: 'current_retention_rate') required num currentRetentionRate,
  }) = _RetentionRateKPI;

  factory RetentionRateKPI.fromJson(Map<String, dynamic> json) =>
      _$RetentionRateKPIFromJson(json);
}

