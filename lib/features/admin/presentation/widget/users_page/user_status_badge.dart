import 'package:flutter/material.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/theme/app_theme.dart';

/// Badge coloré indiquant l'état du compte d'un utilisateur.
class UserStatusBadge extends StatelessWidget {
  final EtatCompte etatCompte;

  const UserStatusBadge({super.key, required this.etatCompte});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (etatCompte) {
      EtatCompte.actif => (
          AppTheme.actionGreenLight,
          AppTheme.actionGreen,
          'Actif',
        ),
      EtatCompte.anonymise => (
          const Color(0xFFFEE2E2),
          AppTheme.errorForeground,
          'Anonymisé',
        ),
      EtatCompte.supprime => (
          const Color(0xFFF3F4F6),
          AppTheme.mutedForeground,
          'Supprimé',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusXxl),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg),
      ),
    );
  }
}
