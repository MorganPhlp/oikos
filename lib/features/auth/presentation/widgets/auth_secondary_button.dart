import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';

class AuthSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AuthSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(screenWidth * 0.93, 25),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        text,
        style: AppTypography.body.copyWith(
          color: AppColors.lightTextGreen,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        )
      ),
    );

    // TODO : Modifier le design clic du bouton
  }
}
