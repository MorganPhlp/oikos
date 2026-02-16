import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/widgets/separator.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';
import 'streak_card_decoration.dart';
import 'streak_visual_header.dart';

// widget saison finie
class StreakFinishedView extends StatelessWidget {
  final StreakState state;
  const StreakFinishedView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return StreakCardDecoration(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            StreakVisualHeader(state: state),
            const SizedBox(height: 16),
            _StatusBadge(primaryColor: primaryColor),
            const SizedBox(height: 24),
            const DecorativeSeparator(),
            const SizedBox(height: 24),
            Text(
              "MERCI POUR TES EFFORTS !",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: primaryColor,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "La saison est clôturée. Tes actions ne comptent plus pour cette streak. Reviens vite pour la prochaine !",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Color primaryColor;
  const _StatusBadge({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.calendarX, size: 16, color: primaryColor),
          const SizedBox(width: 8),
          const Text(
            "Saison terminée",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
