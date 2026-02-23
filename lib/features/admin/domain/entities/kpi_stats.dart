

import 'package:oikos/features/admin/data/models/analytics/kpi/carbon_foot_print_completion_rate.dart';
import 'package:oikos/features/admin/data/models/analytics/kpi/challenges_accepted.dart';
import 'package:oikos/features/admin/data/models/analytics/kpi/daily_use_rate.dart';
import 'package:oikos/features/admin/data/models/analytics/kpi/retention_rate.dart';

class KpiStats {
  CarbonFootPrintCompletionRateKPI carbonFootPrintCompletionRateKPI;
  ChallengesAcceptedKPI challengesAcceptedKPI;
  DailyUseRateKPI dailyUseRateKPI;
  RetentionRateKPI retentionRateKPI;

  KpiStats({
    required this.carbonFootPrintCompletionRateKPI,
    required this.challengesAcceptedKPI,
    required this.dailyUseRateKPI,
    required this.retentionRateKPI,
  });
}