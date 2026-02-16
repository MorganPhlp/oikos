import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StreakLoadingWidget extends StatelessWidget {
  final ThemeData theme;

  const StreakLoadingWidget({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          height: 480,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(28),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1200.ms,
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        )
        .fade(duration: 400.ms);
  }
}
