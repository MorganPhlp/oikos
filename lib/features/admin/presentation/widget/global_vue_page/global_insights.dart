import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/entities/kpi_stats.dart';
import 'global_insights_card.dart';

class GlobalInsightsKPIs extends StatelessWidget {
  final KpiStats? stats;
  final bool isLoading;
  final KPITrend? usersTrend;
  final KPITrend? retentionTrend;
  final KPITrend? co2Trend;
  final KPITrend? challengesTrend;

  const GlobalInsightsKPIs({
    super.key,
    this.stats,
    this.isLoading = false,
    this.usersTrend,
    this.retentionTrend,
    this.co2Trend,
    this.challengesTrend,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0', 'fr_FR');
    // final decimalFormat = NumberFormat('#,##0.0', 'fr_FR');

 

    final RetentionRateKPI? retentionRateKPI = stats?.retentionRateKPI;
    final ChallengesAcceptedKPI? challengesAcceptedKPI =
        stats?.challengesAcceptedKPI;
    final CarbonFootPrintCompletionRateKPI? carbonFootPrintCompletionRateKPI =
        stats?.carbonFootPrintCompletionRateKPI;
    final DailyUseRateKPI? dailyUseRateKPI = stats?.dailyUseRateKPI;

    return KPICardsGrid(
      cards: [
        // CO₂ Total Économisé
        KPICard(
          title: 'Taux de Rétention',
          value: retentionRateKPI != null
              ? retentionRateKPI.j7.toStringAsFixed(1)
              : '0',
          unit: '%',
          icon: Icons.refresh,
          color: KPIColor.green,
          isLoading: isLoading,
          subMetrics: [
            KPISubMetric(
              label: 'J7',
              value: retentionRateKPI != null
                  ? retentionRateKPI.j7.toStringAsFixed(1)
                  : '0',
              unit: '%',
              target: retentionRateKPI != null
                  ? retentionRateKPI.j7Objective.toStringAsFixed(1)
                  : '0',
            ),
            KPISubMetric(
              label: 'J30',
              value: retentionRateKPI != null
                  ? retentionRateKPI.j30.toStringAsFixed(1)
                  : '0',
              unit: '%',
              target: retentionRateKPI != null
                  ? retentionRateKPI.j30Objective.toStringAsFixed(1)
                  : '0',
            ),
          ],
        ),

        // Utilisateurs Actifs
        KPICard(
          title: 'Taux d\'Usage Hebdomadaire (WAU)',
          value: dailyUseRateKPI != null
              ? dailyUseRateKPI.dailyUseRate.toStringAsFixed(1)
              : '0',
          unit: '%',
          icon: Icons.people,
          color: KPIColor.blue,
          isLoading: isLoading,
        ),

        // Défis Relevés
        KPICard(
          title: 'Défis Relevés',
          value: challengesAcceptedKPI != null
              ? numberFormat.format(challengesAcceptedKPI.nbChallenges)
              : '0',
          icon: Icons.flag,
          color: KPIColor.purple,
          isLoading: isLoading,
        ),

        // Taux de Rétention
        KPICard(
          title: 'Complétion du bilan carbone',
          icon: Icons.refresh,
          color: KPIColor.orange,
          isLoading: isLoading,
          subMetrics: [
            KPISubMetric(
              label: 'Minimal',
              value: carbonFootPrintCompletionRateKPI != null
                  ? carbonFootPrintCompletionRateKPI
                        .carbonFootPrintMinimalCompletionRate
                        .toStringAsFixed(1)
                  : '0',
              unit: '%',
              target: carbonFootPrintCompletionRateKPI != null
                  ? carbonFootPrintCompletionRateKPI
                        .carbonFootPrintMinimalCompletionRateObjective
                        .toStringAsFixed(1)
                  : '0',
            ),
            KPISubMetric(
              label: 'Detailled',
              value: carbonFootPrintCompletionRateKPI != null
                  ? carbonFootPrintCompletionRateKPI
                        .carbonFootPrintDetailledCompletionRate
                        .toStringAsFixed(1)
                  : '0',
              unit: '%',
              target: carbonFootPrintCompletionRateKPI != null
                  ? carbonFootPrintCompletionRateKPI
                        .carbonFootPrintDetailledCompletionRateObjective
                        .toStringAsFixed(1)
                  : '0',
            ),
          ],
        ),
      ],
    );
  }
}
