// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) =>
    _CategoryData(
      name: json['name'] as String,
      percentage: (json['percentage'] as num).toDouble(),
      co2: (json['co2'] as num).toDouble(),
      color: const ColorConverter().fromJson((json['color'] as num).toInt()),
    );

Map<String, dynamic> _$CategoryDataToJson(_CategoryData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'percentage': instance.percentage,
      'co2': instance.co2,
      'color': const ColorConverter().toJson(instance.color),
    };
