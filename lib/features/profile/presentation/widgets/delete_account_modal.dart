import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';

class DeleteAccountModal extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAccountModal({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Icône d'avertissement
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.alertTriangle,
              size: 32,
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Supprimer mon compte ?',
            style: AppTypography.h2.copyWith(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          Text(
            'Cette action est irréversible. Toutes tes données personnelles seront anonymisées conformément au RGPD.',
            style: AppTypography.body.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          AuthPrimaryButton(
            text: 'Confirmer la suppression',
            onPressed: () {
              Navigator.pop(context); // Fermer la modale
              onConfirm(); // Exécuter l'action
            },
            // On peut styliser le bouton en rouge si AuthPrimaryButton le permet, sinon standard
          ),

          const SizedBox(height: 12),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
