import 'package:flutter/material.dart';

class MyActionsProgressCard extends StatelessWidget {
  final double progress;
  final int done;
  final int total;
  final bool isLifestyle;

  const MyActionsProgressCard({
    super.key,
    required this.progress,
    required this.done,
    required this.total,
    required this.isLifestyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isLifestyle ? 'Mes habitudes acquises' : 'Ma progression ',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                isLifestyle ? Icons.favorite : Icons.emoji_events,
                color: isLifestyle ? colorScheme.error : colorScheme.tertiary,
              ),
            ],
          ),
          if (!isLifestyle) ...[
            const SizedBox(height: 10),
            Text(
              '$done/$total actions avancées aujourd\'hui',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: progress),
              curve: Curves.easeInOut,
              duration: const Duration(seconds: 1),
              builder: (context, value, child) => LinearProgressIndicator(
                value: value,
                backgroundColor: colorScheme.onSurface.withValues(alpha: 0.05),
                color: isLifestyle ? colorScheme.primary : colorScheme.tertiary,
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
