import 'package:flutter/material.dart';

class OikosActionStats extends StatelessWidget {
  final int impactScore;
  final String difficulty;
  final String frequencyLabel;
  final Color? primaryColor;

  const OikosActionStats({
    super.key,
    required this.impactScore,
    required this.difficulty,
    required this.frequencyLabel,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = primaryColor ?? colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(theme, Icons.bolt, '$impactScore pts', 'Gain', accentColor),
          _divider(colorScheme),
          _statItem(
            theme,
            Icons.speed,
            difficulty,
            'Niveau',
            colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          _divider(colorScheme),
          _statItem(
            theme,
            Icons.schedule,
            frequencyLabel,
            'Fréquence',
            colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }

  Widget _divider(ColorScheme cs) => Container(
    width: 1,
    height: 28,
    color: cs.onSurface.withValues(alpha: 0.1),
  );

  Widget _statItem(
    ThemeData theme,
    IconData icon,
    String val,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 3),
        Text(
          val,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
