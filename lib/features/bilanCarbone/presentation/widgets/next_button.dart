import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart'; // Vérifie que ce chemin est bon

class OikosNextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool disabled;
  final Widget? icon;

  const OikosNextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientGreenEnd,
          disabledBackgroundColor: AppColors.gradientGreenEnd.withOpacity(0.5),
          disabledForegroundColor: Colors.white.withOpacity(0.8),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              icon!,
            ],
          ],
        ),
      ),
    );
  }
}