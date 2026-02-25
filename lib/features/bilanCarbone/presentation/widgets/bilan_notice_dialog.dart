import 'package:flutter/material.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';


class BilanNoticeDialog extends StatelessWidget {
  final String title;
  final String description;
  final String buttonLabel;
  final String? secondaryButtonLabel;
  final IconData icon;
  final VoidCallback onConfirm;
  final VoidCallback? onSecondary;

  const BilanNoticeDialog({
    super.key,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.icon,
    required this.onConfirm,
    this.secondaryButtonLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.tertiary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: colorScheme.tertiary,
                size: isSmallScreen ? 40 : size.width * 0.12,
              ),
            ),
            SizedBox(height: size.height * 0.025),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.015),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            GradientButton(
              label: buttonLabel,
              isTertiary: true,
              onPressed: onConfirm,
            ),
            if (secondaryButtonLabel != null) ...[
              SizedBox(height: size.height * 0.015),
              TextButton(
                onPressed: onSecondary ?? () => Navigator.of(context).pop(),
                child: Text(
                  secondaryButtonLabel!,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- Static Helper pour la Notice d'approfondissement (Transition) ---
  static Future<void> showNotice({required BuildContext context, required VoidCallback onStart}) {
    return showDialog(
      context: context,
      barrierDismissible: false, // On force l'utilisateur à cliquer sur le bouton
      builder: (context) => BilanNoticeDialog(
        title: "C'est parti !",
        description: "Tu as terminé les questions de base. On approfondit pour plus de précision ?",
        buttonLabel: "C'est parti !",
        icon: Icons.add_chart,
        onConfirm: () {
          Navigator.of(context).pop(); // Ferme la popup
          onStart(); // Déclenche l'événement du Bloc
        },
      ),
    );
  }

  // --- Static Helper pour le dialogue de Skip (Popup) ---
  static Future<void> showSkip({required BuildContext context, required VoidCallback onSkip}) {
    return showDialog(
      context: context,
      builder: (context) => BilanNoticeDialog(
        title: "Passer l'approfondissement ?",
        description: "Tes réponses obligatoires sont enregistrées. Tu peux voir tes résultats dès maintenant.",
        buttonLabel: "Voir mes résultats",
        secondaryButtonLabel: "Continuer l'approfondissement",
        icon: Icons.analytics_outlined,
        onConfirm: () {
          Navigator.of(context).pop();
          onSkip();
        },
      ),
    );
  }
}