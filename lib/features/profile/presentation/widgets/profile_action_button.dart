import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileActionButton extends StatelessWidget {
  // ... (constructeur identique) ...
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String? subtitle;
  final Widget? trailing;
  final Color? iconColor;
  final Color? textColor;
  final bool showBorder;

  const ProfileActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.iconColor,
    this.textColor,
    this.showBorder = true,
  });


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Par défaut, on utilise la couleur primaire (vert) si aucune couleur n'est spécifiée
    final effectiveIconColor = iconColor ?? colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: showBorder
            // MODIFICATION : Bordure de séparation légèrement verte
                ? Border(bottom: BorderSide(color: colorScheme.primary.withValues(alpha: 0.08)))
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  // Fond de l'icône basé sur la couleur de l'icône (donc vert par défaut)
                  color: effectiveIconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: effectiveIconColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.body.copyWith(
                        color: textColor ?? colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.body.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ?trailing,
              if (trailing == null)
                Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  // Flèche de droite légèrement verte
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
            ],
          ),
        ),
      ),
    );
  }
}