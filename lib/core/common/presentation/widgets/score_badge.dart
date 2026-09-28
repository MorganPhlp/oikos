import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ScoreBadge extends StatefulWidget {
  final int score;

  const ScoreBadge({super.key, required this.score});

  @override
  State<ScoreBadge> createState() => _ScoreBadgeState();
}

class _ScoreBadgeState extends State<ScoreBadge> {
  int _oldScore = 0;

  @override
  void didUpdateWidget(covariant ScoreBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _oldScore = oldWidget.score;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.zap, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          TweenAnimationBuilder(
            tween: Tween<double>(
              begin: _oldScore.toDouble(),
              end: double.tryParse(widget.score.toString()) ?? 0,
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Text(
              value.toInt().toString(),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
