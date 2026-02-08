import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/profile/presentation/widgets/profile_action_button.dart';

class ProfileAccountSection extends StatelessWidget {
  const ProfileAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'Paramètres du compte',
            // MODIFICATION : Titre en H3 et en vert primaire
            style: AppTypography.h2.copyWith(
                color: colorScheme.primary,
                fontSize: 18
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.05), // Ombre très légère verte
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              ProfileActionButton(
                title: 'Modifier le pseudo',
                icon: LucideIcons.pencil,
                // L'icône sera verte par défaut grâce au widget ProfileActionButton
                onTap: () {}, // TODO : Implémenter la modification du pseudo
              ),
              // ... reste des boutons identiques ...
              ProfileActionButton(
                title: 'Email & Sécurité',
                icon: LucideIcons.lock,
                onTap: () {}, // TODO
              ),
              ProfileActionButton(
                title: 'Statut',
                subtitle: 'Actif', // À dynamiser
                icon: LucideIcons.power,
                iconColor: const Color(0xFF4CAF50), // Vert plus vif pour le statut
                onTap: () {}, // TODO
              ),
              ProfileActionButton(
                title: 'Notifications',
                icon: LucideIcons.bell,
                onTap: () {}, // TODO
              ),
              ProfileActionButton(
                title: 'Modifier l\'avatar',
                icon: LucideIcons.smile,
                onTap: () {}, // TODO
              ),
              ProfileActionButton(
                title: 'Centres d\'intérêt',
                icon: LucideIcons.tag,
                onTap: () {}, // TODO
                showBorder: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}