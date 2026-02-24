import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_xp_point.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_info_button.dart';

class DashboardXpGainedOverTimeChart extends StatelessWidget {
  final List<DashboardXpPoint> points;

  const DashboardXpGainedOverTimeChart({
    super.key,
    required this.points,
  });

  String _formatMonthYear(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    return '$mm/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (points.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'XP',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Aucune donnée disponible',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    final sorted = [...points]..sort((a, b) => a.date.compareTo(b.date));
    final start = DateTime(sorted.first.date.year, sorted.first.date.month, sorted.first.date.day);
    final end = DateTime(sorted.last.date.year, sorted.last.date.month, sorted.last.date.day);

    final spots = <FlSpot>[];
    var maxY = 0.0;
    for (final p in sorted) {
      final day = DateTime(p.date.year, p.date.month, p.date.day);
      final x = day.difference(start).inDays.toDouble();
      final y = p.cumulativeXp;
      if (y > maxY) maxY = y;
      spots.add(FlSpot(x, y));
    }

    final maxX = end.difference(start).inDays.toDouble();
    final safeMaxY = (maxY <= 0 ? 1.0 : maxY * 1.1);

    final lineColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'XP gagné',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 8),
            const DashboardInfoButton(
              title: 'XP gagné',
              message:
                  "Montre tes points gagnés dans le temps (cumul hebdomadaire sur les 5 derniers mois). Utile pour suivre ta progression.",
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: maxX == 0 ? 1 : maxX,
              minY: 0,
              maxY: safeMaxY,
              gridData: FlGridData(
                show: false,
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: theme.dividerColor),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: (value, meta) {
                      // Affiche seulement quelques ticks
                      if (value == 0 || value == meta.max) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: theme.textTheme.bodySmall,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: (maxX <= 0) ? 1 : (maxX / 4).clamp(1, 9999),
                    getTitlesWidget: (value, meta) {
                      final d = start.add(Duration(days: value.round()));
                      return SideTitleWidget(
                        meta: meta,
                        fitInside: SideTitleFitInsideData.fromTitleMeta(
                          meta,
                          distanceFromEdge: 0,
                        ),
                        child: Text(
                          _formatMonthYear(d),
                          style: theme.textTheme.bodySmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: lineColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: lineColor.withValues(alpha: 0.15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
