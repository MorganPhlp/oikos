import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_colors.dart';

class BilanHeroScore extends StatelessWidget {
  final double scoreKg;
  final String objectifLabel;

  const BilanHeroScore({
    super.key,
    required this.scoreKg,
    this.objectifLabel = 'Objectif 2050 : 2 t/an',
  });

  String _formatKgToTonnes(double kgValue, {int decimals = 1}) {
    final tonnes = kgValue / 1000;
    return tonnes.toStringAsFixed(decimals).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String scoreFormatted = _formatKgToTonnes(scoreKg, decimals: 1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.gradientGreenEnd.withValues(alpha: 0.1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Ton empreinte annuelle',
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          Text(
            scoreFormatted,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'tonnes CO₂e / an',
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.gradientGreenEnd.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.target, size: 18, color: AppColors.gradientGreenEnd),
                const SizedBox(width: 8),
                Text(
                  objectifLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.gradientGreenEnd,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
