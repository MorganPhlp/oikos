import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_secondary_button.dart';

class ConfirmCommunityModal extends StatelessWidget {
  final String communityName;
  final String communityIcon;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmCommunityModal({
    super.key,
    required this.communityName,
    required this.communityIcon,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton fermer (X)
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: onCancel,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(
                      alpha: 0.1,
                    ), // Vert très clair adaptatif
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),

            // Icône Communauté (Cercle Dégradé - On garde les couleurs de marque)
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.gradientGreenStart,
                    AppColors.gradientGreenEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Image.network(
                  communityIcon,
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.group,
                      size: 50,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Confirmation de communauté",
              style: AppTypography.h2.copyWith(
                fontSize: 20,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Encadré Nom Communauté
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // Fond adaptatif : Vert primaire à 10% d'opacité
                // Ça rend bien sur fond blanc ET sur fond noir
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Vous êtes sur le point de rejoindre :",
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    communityName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text(
              "Cette communauté sera votre équipe pour les défis et le classement.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 25),

            // Boutons d'action (déjà adaptatifs)
            AuthPrimaryButton(
              text: "Oui, confirmer",
              icon: Icons.check,
              onPressed: onConfirm,
            ),

            const SizedBox(height: 10), // Ajout d'un petit espace

            AuthSecondaryButton(
              text: "Non, choisir une autre",
              onPressed: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
