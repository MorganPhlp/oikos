// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_use_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyUseRateKPI _$DailyUseRateKPIFromJson(Map<String, dynamic> json) =>
    _DailyUseRateKPI(
      dailyUseRate: json['taux_utilisation_jour'] as num,
      dailyUseRateObjective: json['objectif_taux_utilisation_jour'] as num,
    );

Map<String, dynamic> _$DailyUseRateKPIToJson(_DailyUseRateKPI instance) =>
    <String, dynamic>{
      'taux_utilisation_jour': instance.dailyUseRate,
      'objectif_taux_utilisation_jour': instance.dailyUseRateObjective,
    };
