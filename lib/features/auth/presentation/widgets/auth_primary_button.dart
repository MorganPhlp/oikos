import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_typography.dart';

import '../../../../core/theme/app_colors.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          AppColors.gradientGreenStart,
          AppColors.gradientGreenEnd,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15), // Bords arrondis de 8px

        boxShadow: [
          BoxShadow(
            color: AppColors.gradientGreenEnd.withValues(alpha: 0.4),
            spreadRadius: -2,
            blurRadius: 15,
            offset: const Offset(0, 8), // décalage de l'ombre
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          //fixedSize: Size(screenWidth * 0.93, 25), // Largeur 90% de l'écran, hauteur 55px
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Bords arrondis de 8px
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.lightTextPrimary),
              const SizedBox(width: 8),
            ],
            Text(text, style: AppTypography.body.copyWith(
              color: AppColors.lightTextPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            )),
          ],
        )
      ),
    );

    // TODO : Modifier le design clic du bouton
  }
}
