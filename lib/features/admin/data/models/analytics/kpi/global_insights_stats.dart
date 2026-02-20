import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_insights_stats.freezed.dart';
part 'global_insights_stats.g.dart';

@freezed
sealed class GlobalInsightsStats with _$GlobalInsightsStats {
  const factory GlobalInsightsStats({
    @JsonKey(name: 'co2_total') required double totalCo2Saved,
    @JsonKey(name: 'defis_actifs') required int activeChallenges,
    @JsonKey(name: 'taux_retention') required int retentionRate,
    @JsonKey(name: 'total_utilisateurs') required double activeUsers,
  }) = _GlobalInsightsStats;

  factory GlobalInsightsStats.fromJson(Map<String, dynamic> json) =>
      _$GlobalInsightsStatsFromJson(json);
}
