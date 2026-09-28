import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Widget affichant un badge lorsque le streak a atteint son niveau maximum, avec une animation de célébration
class StreakMaxLevelBadge extends StatelessWidget {
  const StreakMaxLevelBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final successColor = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            successColor.withValues(alpha: 0.15),
            successColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: successColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.partyPopper,
                  color: successColor,
                  size: 32,
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 3.seconds)
              .shake(hz: 2),
          const SizedBox(height: 16),
          Text(
            "FLEUR ÉPANOUIE",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: successColor,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tu es un vrai jardinier, ta fleur est désormais complètement épanouie !",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}
