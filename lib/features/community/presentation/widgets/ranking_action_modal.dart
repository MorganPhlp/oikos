import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart'; // Import ajouté

class RankingActionModal extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final bool isCommunity;
  final VoidCallback onSeeProfile;
  final VoidCallback onDuel;

  const RankingActionModal({
    Key? key,
    required this.name,
    required this.avatarUrl,
    required this.isCommunity,
    required this.onSeeProfile,
    required this.onDuel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ... (Partie Avatar et Titre identique) ...
            Container(
              padding: const EdgeInsets.all(4),
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
              child: OikosAvatar(avatarUrl: avatarUrl, label: name, radius: 32),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCommunity ? Icons.groups_outlined : Icons.person_outline,
                  size: 16,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 4),
                Text(
                  isCommunity ? "Communauté" : "Utilisateur",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- NOUVEAUX BOUTONS ---
            SizedBox(
              width: double.infinity,
              height: 55, // Même hauteur que GradientButton
              child: OutlinedButton(
                onPressed: onSeeProfile,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary, // Texte Vert
                  side: BorderSide(
                    color: colorScheme.primary,
                    width: 2,
                  ), // Bordure Verte
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0, // Zéro ombre garantie
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  "Voir le profil",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GradientButton(
              label: "Lancer un duel",
              icon: const Icon(Icons.flash_on, color: Colors.white, size: 20),
              onPressed: onDuel,
            ),

            const SizedBox(height: 16),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Annuler",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
