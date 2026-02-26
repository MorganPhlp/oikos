import 'package:flutter/material.dart';

class AppColors {
  // Empêcher l'instanciation de cette classe utilitaire
  const AppColors._();

  // --- Light Mode Palette ---
  static const Color lightBackground = Color(0xFFF9FDF0);
  static const Color lightForeground = Color(0xFF252525);

  static const Color lightPrimary = Color(0xFF65BA74);
  static const Color lightPrimaryForeground = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFDCFCE7); // fond vert très clair (ex-actionGreenLight)

  static const Color gradientGreenStart = Color(0xFFBDEE63);
  static const Color gradientGreenEnd = Color(0xFF65BA74);

  static const Color lightSecondary = Color(0xFFF2F2F2);
  static const Color lightSecondaryForeground = Color(0xFF030213);

  static const Color orange = Colors.orange;

  static const Color lightMuted = Color(0xFFECECF0);
  static const Color lightMutedForeground = Color(0xFF717182);

  static const Color lightDestructive = Color(0xFFD4183D);
  static const Color lightDestructiveError = Color(0xFFFFFFFF);

  static const Color lightBorder = Color(0x1A000000);

  static const Color lightInput = Color(0xFFF9FBF9);
  static const Color lightInputBorder = Color(0xFFD4EBD8);
  static const Color lightInputBorderFocused = Color(0xFF66BA73);

  static const Color lightIconPrimary = Color(0xFF65BA74);

  static const Color lightTextPrimary = Color(0xFF37401C);
  static const Color lightTextGreen = Color(0xFF337841);

  // --- Dark Mode Palette ---
  static const Color darkBackground = Color(0xFF1A1C19);
  static const Color darkForeground = Color(0xFFE2E2E2);

  static const Color darkPrimary = Color(0xFF65BA74);
  static const Color darkPrimaryForeground = Color(0xFF1A1C19);

  static const Color darkSecondary = Color(0xFF2C2F2B);
  static const Color darkSecondaryForeground = Color(0xFFE2E2E2);

  static const Color darkMuted = Color(0xFF2F2F2F);
  static const Color darkMutedForeground = Color(0xFFA0A0A0);

  static const Color darkDestructive = Color(0xFFCF6679); // Approx pour oklch
  static const Color darkDestructiveForeground = Color(0xFF1A1C19);

  static const Color darkBorder = Color(0xFF404040);

  static const Color darkInput = Color(0xFF252824);
  static const Color darkInputBorder = Color(0xFF404842);
  static const Color darkInputBorderFocused = Color(0xFF65BA74);
}