import 'package:flutter/material.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_info_button.dart';

class DashboardCommunityPositionGauge extends StatelessWidget {
  final double userPoints;
  final double teamAveragePoints;
  final double top10PercentPoints;

  const DashboardCommunityPositionGauge({
    super.key,
    required this.userPoints,
    required this.teamAveragePoints,
    required this.top10PercentPoints,
  });

  double _clampNonNegative(double v) => v.isNaN ? 0 : (v < 0 ? 0 : v);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final safeUser = _clampNonNegative(userPoints);
    final safeAvg = _clampNonNegative(teamAveragePoints);
    final safeTop10 = _clampNonNegative(top10PercentPoints);

    final maxValue = () {
      final maxRaw = [safeUser, safeAvg, safeTop10].reduce((a, b) => a > b ? a : b);
      if (maxRaw <= 0) return 1.0;
      return maxRaw * 1.15;
    }();

    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.error;
    final tertiary = theme.colorScheme.tertiary;
    final trackColor = theme.dividerColor.withValues(alpha: 0.4);

    Widget marker({
      required double value,
      required Color color,
      required String label,
      required double gaugeWidth,
      bool showLabel = true,
    }) {
      final t = (value / maxValue).clamp(0.0, 1.0);
      final x = t * gaugeWidth;

      return Positioned(
        left: x - 1,
        top: 0,
        bottom: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 2,
              height: 22,
              color: color,
            ),
            const SizedBox(height: 6),
            if (showLabel)
              Text(
                label,
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'Positionnement communautaire',
                style: theme.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 4),
            const DashboardInfoButton(
              title: 'Positionnement communautaire',
              message:
                  "Te situe par rapport à ta communauté : Vous, Moyenne et Top 10%. Un repère rapide pour savoir où tu te places.",
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final gaugeWidth = constraints.maxWidth;
            final gaugeHeight = 72.0;

            final xAvg = (safeAvg / maxValue).clamp(0.0, 1.0) * gaugeWidth;
            final xUser = (safeUser / maxValue).clamp(0.0, 1.0) * gaugeWidth;
            final hideAvgAndUserLabels = (xAvg - xUser).abs() < 34; // évite "MoyenneVous"

            return SizedBox(
              height: gaugeHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 10,
                      width: gaugeWidth,
                      decoration: BoxDecoration(
                        color: trackColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  marker(
                    value: safeAvg,
                    color: tertiary,
                    label: 'Moyenne',
                    gaugeWidth: gaugeWidth,
                    showLabel: !hideAvgAndUserLabels,
                  ),
                  marker(
                    value: safeTop10,
                    color: secondary,
                    label: 'Top 10%',
                    gaugeWidth: gaugeWidth,
                  ),
                  marker(
                    value: safeUser,
                    color: primary,
                    label: 'Vous',
                    gaugeWidth: gaugeWidth,
                    showLabel: !hideAvgAndUserLabels,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final baseStyle = theme.textTheme.bodySmall;
            final legendStyle = baseStyle?.copyWith(
              fontSize: (baseStyle?.fontSize ?? 12) - 1,
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: constraints.maxWidth,
                child: DefaultTextStyle.merge(
                  style: legendStyle,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _LegendDot(color: primary),
                        const SizedBox(width: 4),
                        Text('Vous: ${safeUser.toStringAsFixed(0)} pts'),
                        const SizedBox(width: 10),
                        _LegendDot(color: tertiary),
                        const SizedBox(width: 4),
                        Text('Moyenne: ${safeAvg.toStringAsFixed(0)} pts'),
                        const SizedBox(width: 10),
                        _LegendDot(color: secondary),
                        const SizedBox(width: 4),
                        Text('Top 10%: ${safeTop10.toStringAsFixed(0)} pts'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
