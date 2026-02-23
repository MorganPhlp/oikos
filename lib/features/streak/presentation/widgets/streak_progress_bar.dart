import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';

class StreakProgressSection extends StatelessWidget {
  final StreakState state;
  final int threshold;

  const StreakProgressSection({
    super.key,
    required this.state,
    required this.threshold,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: _ProgressBarBlock(
              icon: LucideIcons.userCheck,
              current: state.actionsQuotidiennes ?? 0,
              total: threshold == 0 ? 1 : threshold,
              label: "Quotidien",
            ),
          ),
          Container(
            height: 70,
            width: 1.5,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            color: primaryColor.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _ProgressBarBlock(
              icon: LucideIcons.users,
              current: (state.hasCompletedActionCommunautaire ?? false) ? 1 : 0,
              total: 1,
              label: "Collectif",
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBarBlock extends StatelessWidget {
  final IconData icon;
  final int current;
  final int total;
  final String label;

  const _ProgressBarBlock({
    required this.icon,
    required this.current,
    required this.total,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            Text(
              "$current/$total",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _GradientProgressBar(value: (current / total).clamp(0.0, 1.0)),
        const SizedBox(height: 12),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  final double value;
  const _GradientProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
            theme.colorScheme.error,
          ],
        ).createShader(bounds),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 4,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
