import 'package:flutter/material.dart';

import '../../../../core/theme/oikos_button_theme.dart';

class ActionsHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int userPoints;

  const ActionsHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.userPoints = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final buttonTheme = theme.extension<OikosButtonTheme>();

    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
      decoration: BoxDecoration(
        gradient: buttonTheme?.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.onPrimary.withValues(alpha: 0.2),
              border: Border.all(color: colorScheme.onPrimary, width: 2),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.onPrimary,
              child: Icon(Icons.person, color: colorScheme.onSurface, size: 24),
            ),
          ),

          // Titres
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                subtitle.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.7),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
            ],
          ),

          // Points + Notif
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.onPrimary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt, color: colorScheme.tertiary, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$userPoints',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none,
                  color: colorScheme.onPrimary,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
