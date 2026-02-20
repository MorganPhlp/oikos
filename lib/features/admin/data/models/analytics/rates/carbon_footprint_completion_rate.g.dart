// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carbon_footprint_completion_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarbonFootprintCompletionRate _$CarbonFootprintCompletionRateFromJson(
  Map<String, dynamic> json,
) => _CarbonFootprintCompletionRate(
  completionPourcentage: (json['completion_percentage'] as num).toDouble(),
  totalUsers: (json['total_utilisateurs'] as num).toInt(),
  usersWithCompletedBilan: (json['utilisateurs_bilan_termine'] as num).toInt(),
);

Map<String, dynamic> _$CarbonFootprintCompletionRateToJson(
  _CarbonFootprintCompletionRate instance,
) => <String, dynamic>{
  'completion_percentage': instance.completionPourcentage,
  'total_utilisateurs': instance.totalUsers,
  'utilisateurs_bilan_termine': instance.usersWithCompletedBilan,
};
