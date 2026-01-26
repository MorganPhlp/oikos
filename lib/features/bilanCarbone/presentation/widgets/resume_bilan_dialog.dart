import 'package:flutter/material.dart';
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
                // Bouton "Oui, reprendre"
                _buildActionButton(
                  context: context,
                  label: "Oui, reprendre",
                  isPrimary: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onResume();
                  },
                  size: size,
                ),
                SizedBox(height: size.height * 0.015),

                // Bouton "Non, recommencer"
                _buildActionButton(
                  context: context,
                  label: "Non, recommencer",
                  isPrimary: false,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRestart();
                  },
                  size: size,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
    required Size size,
  }) {
    final isSmallScreen = size.width < 360;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isPrimary
            ? const LinearGradient(
                colors: [
                  AppColors.gradientGreenStart,
                  AppColors.gradientGreenEnd,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        border: isPrimary
            ? null
            : Border.all(color: AppColors.gradientGreenEnd, width: 2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.gradientGreenEnd.withValues(alpha: 0.3),
                  spreadRadius: -2,
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, isSmallScreen ? 48 : 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: isPrimary ? Colors.transparent : Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary
                ? AppColors.lightTextPrimary
                : AppColors.gradientGreenEnd,
            fontWeight: FontWeight.w600,
            fontSize: isSmallScreen ? 14 : 16,
          ),
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
