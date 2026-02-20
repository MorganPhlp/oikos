// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_insights_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GlobalInsightsStats _$GlobalInsightsStatsFromJson(Map<String, dynamic> json) =>
    _GlobalInsightsStats(
      totalCo2Saved: (json['co2_total'] as num).toDouble(),
      activeChallenges: (json['defis_actifs'] as num).toInt(),
      retentionRate: (json['taux_retention'] as num).toInt(),
      activeUsers: (json['total_utilisateurs'] as num).toDouble(),
    );

Map<String, dynamic> _$GlobalInsightsStatsToJson(
  _GlobalInsightsStats instance,
) => <String, dynamic>{
  'co2_total': instance.totalCo2Saved,
  'defis_actifs': instance.activeChallenges,
  'taux_retention': instance.retentionRate,
  'total_utilisateurs': instance.activeUsers,
};
