// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retention_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RetentionRateKPI _$RetentionRateKPIFromJson(Map<String, dynamic> json) =>
    _RetentionRateKPI(
      j7: json['j7'] as num,
      j7Objective: json['j7_objective'] as num,
      j30: json['j30'] as num,
      j30Objective: json['j30_objective'] as num,
      currentRetentionRate: json['current_retention_rate'] as num,
    );

Map<String, dynamic> _$RetentionRateKPIToJson(_RetentionRateKPI instance) =>
    <String, dynamic>{
      'j7': instance.j7,
      'j7_objective': instance.j7Objective,
      'j30': instance.j30,
      'j30_objective': instance.j30Objective,
      'current_retention_rate': instance.currentRetentionRate,
    };
