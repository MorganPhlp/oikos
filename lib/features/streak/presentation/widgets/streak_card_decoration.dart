import 'package:flutter/material.dart';

// Widget de décoration pour les cartes de streak, avec un dégradé et une bordure
class StreakCardDecoration extends StatelessWidget {
  final Widget child;
  const StreakCardDecoration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.55),
            primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }
}
