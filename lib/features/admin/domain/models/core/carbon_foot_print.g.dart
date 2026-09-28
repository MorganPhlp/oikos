// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carbon_foot_print.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarbonFootPrint _$CarbonFootPrintFromJson(Map<String, dynamic> json) =>
    _CarbonFootPrint(
      userId: json['utilisateur_id'] as String,
      score: (json['scoretotalco2ean'] as num).toDouble(),
      dateBilan: json['date_bilan'] as String,
    );

Map<String, dynamic> _$CarbonFootPrintToJson(_CarbonFootPrint instance) =>
    <String, dynamic>{
      'utilisateur_id': instance.userId,
      'scoretotalco2ean': instance.score,
      'date_bilan': instance.dateBilan,
    };
