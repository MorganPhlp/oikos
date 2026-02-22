import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oikos/features/actions/domain/entities/user_active_action_entity.dart';

class AnimatedProgressBar extends StatelessWidget {
  final UserActiveActionEntity activeAction;
  final bool start;
  final VoidCallback? onComplete;
  final Color? backgroundColor;
  final Color? valueColor;

  const AnimatedProgressBar({
    super.key,
    required this.activeAction,
    required this.start,
    this.onComplete,
    this.backgroundColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final double targetProgress = activeAction.maxCount > 0
        ? (activeAction.streakCount / activeAction.maxCount).clamp(0.0, 1.0)
        : 0.0;

    final double previousProgress = activeAction.maxCount > 0
        ? ((activeAction.streakCount - 1) / activeAction.maxCount).clamp(
            0.0,
            1.0,
          )
        : 0.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: start ? previousProgress : previousProgress,
        end: start ? targetProgress : previousProgress,
      ),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutQuart,
      onEnd: start ? onComplete : null,
      builder: (context, value, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor:
                backgroundColor ?? colorScheme.primary.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation(
              valueColor ?? colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}
