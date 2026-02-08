import 'package:flutter/material.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/theme/app_colors.dart';

class ResumeBilanDialog extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;

  const ResumeBilanDialog({
    super.key,
    required this.onResume,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gradientGreenEnd.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.eco_outlined,
                color: AppColors.gradientGreenEnd,
                size: isSmallScreen ? 40 : size.width * 0.12,
              ),
            ),
            SizedBox(height: size.height * 0.025),

            // Titre
            Text(
              "Tu as déjà commencé ton bilan",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: isSmallScreen ? 18 : size.width * 0.05,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            SizedBox(height: size.height * 0.015),

            // Sous-titre
            Text(
              "Souhaites-tu le reprendre ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: isSmallScreen ? 14 : size.width * 0.038,
                height: 1.3,
              ),
            ),
            SizedBox(height: size.height * 0.03),

            // Boutons
            Column(
              children: [
                GradientButton(
                  label: "Oui, reprendre",
                  onPressed: () {
                    Navigator.of(context).pop();
                    onResume();
                  },
                ),
                
                SizedBox(height: size.height * 0.015),

                // Bouton "Non, recommencer" (Passage en Orange/Tertiaire)
                GradientButton(
                  label: "Non, recommencer",
                  isSecondary: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRestart();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Méthode statique pour afficher le dialogue facilement
  static Future<void> show({
    required BuildContext context,
    required VoidCallback onResume,
    required VoidCallback onRestart,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          ResumeBilanDialog(onResume: onResume, onRestart: onRestart),
    );
  }
}
