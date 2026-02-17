import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_colors.dart';

class QuickAccessWidget extends StatelessWidget {
  const QuickAccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tu veux en savoir plus sur :",
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.lightTextPrimary.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),

        _QuickAccessButton(
          title: "Mon Bilan Carbone",
          subtitle: "Découvre ton empreinte et tes progrès",
          borderColor: AppColors.lightPrimary,
          icon: LucideIcons.barChart3,
          routeName: '/dashboard',
        ),

        const SizedBox(height: 12),

        // Bouton : Mes Actions en cours
        _QuickAccessButton(
          title: "Mes Actions en cours",
          subtitle: "Valide tes actions et progresse",
          borderColor: AppColors.gradientGreenStart, // Bordure Lime
          icon: LucideIcons.target,
          routeName: '/my_actions',
        ),
      ],
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color borderColor;
  final IconData icon;
  final String routeName;

  const _QuickAccessButton({
    required this.title,
    required this.subtitle,
    required this.borderColor,
    required this.icon,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context.go(routeName),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            // Contenu texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondary.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Flèche de navigation
            Icon(
              LucideIcons.chevronRight,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
