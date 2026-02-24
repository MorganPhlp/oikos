import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Fond flou subtil et discret
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        // Loader au centre - design épuré et moderne
        Center(
          child: Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSecondary.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.85),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

