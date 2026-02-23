import 'package:flutter/material.dart';
import 'package:radar_chart_plus/radar_chart_plus.dart';

class DashboardBilanVsActionsRadar extends StatelessWidget {
  final Map<String, double> bilanScoresKg;

  const DashboardBilanVsActionsRadar({
    super.key,
    required this.bilanScoresKg,
  });

  List<double> _normalizeToPercent(List<double> values) {
    final total = values.fold<double>(0, (sum, v) => sum + v);
    if (total <= 0) return List<double>.filled(values.length, 0);
    return values.map((v) => (v / total) * 100).toList(growable: false);
  }

  double _maxOf(List<double> values) {
    if (values.isEmpty) return 0;
    var maxValue = values.first;
    for (final v in values.skip(1)) {
      if (v > maxValue) maxValue = v;
    }
    return maxValue;
  }

  List<int> _buildTicks(int axisMax) {
    final safeMax = axisMax <= 0 ? 1 : axisMax;

    // Si max très petit, on préfère 1..max pour éviter des ticks dupliqués.
    if (safeMax <= 5) {
      return List<int>.generate(safeMax, (i) => i + 1, growable: false);
    }

    final ticks = <int>[];
    for (var i = 1; i <= 5; i++) {
      var tick = (safeMax * i / 5).ceil();
      if (ticks.isNotEmpty && tick <= ticks.last) {
        tick = ticks.last + 1;
      }
      ticks.add(tick);
    }

    // Assure que le dernier tick corresponde exactement au max.
    ticks[ticks.length - 1] = safeMax;
    return ticks;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final labels = bilanScoresKg.keys.toList(growable: false);
    final bilanValues = labels.map((k) => (bilanScoresKg[k] ?? 0).toDouble()).toList(growable: false);
    final bilanPercents = _normalizeToPercent(bilanValues);

    // Fake data "actions" : répartition par catégorie (en nombre d'actions)
    // Alignée avec les labels de DetailBilanEntity.toMap().
    final fakeActionCountsByLabel = <String, double>{
      'Transport': 10,
      'Alimentation': 7,
      'Logement': 5,
      'Divers': 6,
      'Services Sociétaux': 3,
    };

    final actionCounts = labels.map((k) => (fakeActionCountsByLabel[k] ?? 0).toDouble()).toList(growable: false);
    final actionPercents = _normalizeToPercent(actionCounts);

    // On adapte automatiquement l'échelle du radar pour que la zone utile prenne de la place
    // (ex: si toutes les valeurs sont < 40%, on met max ~ 40 au lieu de 100).
    final maxPercent = _maxOf([...bilanPercents, ...actionPercents]);
    final axisMax = (maxPercent <= 0 ? 1 : maxPercent.ceil()).clamp(1, 100);
    final ticks = _buildTicks(axisMax);

    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.tertiary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Bilan carbone vs Actions',
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 360,
          child: RadarChartPlus(
            dotTapEnabled: true,
            tooltipStyle: RadarTooltipStyle(),
            labelSpacing: 0,
            maxWordsPerLine: 2,
            labelTextAlign: TextAlign.end,
            labelTextStyle: theme.textTheme.bodySmall?.copyWith(
              overflow: TextOverflow.ellipsis,
              color: theme.colorScheme.onSurface,
            ),
            horizontalLabels: false,
            chartBorderColor: theme.dividerColor,
            ticks: ticks,
            labels: labels,
            dataSets: [
              RadarDataSet(
                data: bilanPercents,
                borderColor: primary,
                fillColor: primary.withValues(alpha: 0.25),
                label: 'Bilan',
              ),
              RadarDataSet(
                data: actionPercents,
                borderColor: secondary,
                fillColor: secondary.withValues(alpha: 0.18),
                label: 'Actions',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: primary),
            const SizedBox(width: 8),
            Text('Bilan', style: theme.textTheme.bodyMedium),
            const SizedBox(width: 16),
            _LegendDot(color: secondary),
            const SizedBox(width: 8),
            Text('Actions', style: theme.textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;

  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
