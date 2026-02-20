// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carbon_footprint_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarbonFootprintData _$CarbonFootprintDataFromJson(Map<String, dynamic> json) =>
    _CarbonFootprintData(
      period: DateTime.parse(json['period'] as String),
      averageCo2: (json['average_co2'] as num).toDouble(),
    );

Map<String, dynamic> _$CarbonFootprintDataToJson(
  _CarbonFootprintData instance,
) => <String, dynamic>{
  'period': instance.period.toIso8601String(),
  'average_co2': instance.averageCo2,
};
