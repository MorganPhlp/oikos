// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carbon_time_series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarbonTimeSeries _$CarbonTimeSeriesFromJson(Map<String, dynamic> json) =>
    _CarbonTimeSeries(
      period: DateTime.parse(json['period'] as String),
      averageCo2: (json['average_co2'] as num).toDouble(),
    );

Map<String, dynamic> _$CarbonTimeSeriesToJson(_CarbonTimeSeries instance) =>
    <String, dynamic>{
      'period': instance.period.toIso8601String(),
      'average_co2': instance.averageCo2,
    };
