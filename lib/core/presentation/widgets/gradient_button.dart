import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_typography.dart';
import '../../../../../core/theme/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool isLoading;
  final Widget? icon;
  final double? width;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Le bouton est inactif si : désactivé manuellement, en chargement, ou pas de fonction fournie
    final bool effectivelyDisabled = disabled || isLoading || onPressed == null;

    return Container(
      width: width ?? screenWidth * 0.93,
      decoration: BoxDecoration(
        gradient: effectivelyDisabled
            ? null
            : const LinearGradient(
                colors: [
                  AppColors.gradientGreenStart,
                  AppColors.gradientGreenEnd,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        // Couleur de remplacement si désactivé
        color: effectivelyDisabled ? Colors.grey.shade300 : null,
        borderRadius: BorderRadius.circular(15),
        boxShadow: effectivelyDisabled
            ? []
            : [
                BoxShadow(
                  color: AppColors.gradientGreenEnd.withValues(alpha: 0.4),
                  spreadRadius: -2,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: effectivelyDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          // On garde la hauteur de 55px pour un look premium
          fixedSize: Size(width ?? screenWidth * 0.93, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: AppTypography.body.copyWith(
                      color: effectivelyDisabled 
                          ? Colors.grey.shade600 
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}