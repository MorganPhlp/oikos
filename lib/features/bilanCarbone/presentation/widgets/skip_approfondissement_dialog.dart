import 'package:flutter/material.dart';
import 'package:oikos/core/presentation/widgets/gradient_button.dart';

class SkipApprofondissementDialog extends StatelessWidget {
  final VoidCallback onSkip;

  const SkipApprofondissementDialog({
    super.key,
    required this.onSkip,
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
            // Icône
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.tertiary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.analytics_outlined,
                color: colorScheme.tertiary,
                size: isSmallScreen ? 40 : size.width * 0.12,
              ),
            ),
            SizedBox(height: size.height * 0.025),

            Text(
              "Passer l'approfondissement ?",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.015),

            Text(
              "Tes réponses obligatoires sont enregistrées. Tu peux voir tes résultats dès maintenant.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: size.height * 0.03),

            GradientButton(
              label: "Voir mes résultats",
              isTertiary: true, 
              onPressed: () {
                Navigator.of(context).pop();
                onSkip();
              },
            ),
            
            SizedBox(height: size.height * 0.015),

            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Continuer l'approfondissement",
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({required BuildContext context, required VoidCallback onSkip}) {
    return showDialog(
      context: context,
      builder: (context) => SkipApprofondissementDialog(onSkip: onSkip),
    );
  }
}