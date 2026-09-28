import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_typography.dart';

class ProfileTopBar extends StatelessWidget {
  const ProfileTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Bouton Retour avec une touche de vert
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => {
                if (context.canPop())
                  {context.pop()}
                else
                  {context.go('/home')},
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // MODIFICATION : Fond légèrement vert au lieu de blanc pur
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                // MODIFICATION : Icône verte
                child: Icon(
                  LucideIcons.chevronLeft,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Mon Profil',
            // MODIFICATION : Titre en vert
            style: AppTypography.h2.copyWith(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
