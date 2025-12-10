import 'package:flutter/material.dart';

class AppColors {
  // Empêcher l'instanciation de cette classe utilitaire
  const AppColors._();

  // --- Light Mode Palette (Basé sur le :root du CSS) ---
  static const Color lightBackground = Color(0xFFF9FDF0);
  static const Color lightForeground = Color(0xFF252525); // oklch(0.145 0 0) approx

  static const Color lightPrimary = Color(0xFF030213);
  static const Color lightPrimaryForeground = Color(0xFFFFFFFF);

  static const Color gradientGreenStart = Color(0xFFBDEE63);
  static const Color gradientGreenEnd = Color(0xFF65BA74);

  static const Color lightSecondary = Color(0xFFF2F2F2); // oklch(0.95...) approx
  static const Color lightSecondaryForeground = Color(0xFF030213);

  static const Color lightMuted = Color(0xFFECECF0);
  static const Color lightMutedForeground = Color(0xFF717182);

  static const Color lightDestructive = Color(0xFFD4183D);
  static const Color lightDestructiveError = Color(0xFFFFFFFF);

  static const Color lightBorder = Color(0x1A000000);

  static const Color lightInput = Color(0xFFF9FBF9); // input-background
  static const Color lightInputBorder = Color(0xFFD4EBD8); // input-border
  static const Color lightInputBorderFocused = Color(0xFF66BA73); // input-border-focused

  static const Color lightIconPrimary = Color(0xFF65BA74);

  static const Color lightTextPrimary = Color(0xFF37401C);

  // --- Dark Mode Palette (Basé sur le .dark du CSS) ---
  // TODO : Ajuster les couleurs sombres (pas fait pour l'instant on ne modifie que le style clair)
  static const Color darkBackground = Color(0xFF252525); // oklch(0.145 0 0)
  static const Color darkForeground = Color(0xFFFAFAFA); // oklch(0.985 0 0)

  static const Color darkPrimary = Color(0xFFFAFAFA);
  static const Color darkPrimaryForeground = Color(0xFF353535);

  static const Color darkSecondary = Color(0xFF454545);
  static const Color darkSecondaryForeground = Color(0xFFFAFAFA);

  static const Color darkMuted = Color(0xFF454545);
  static const Color darkMutedForeground = Color(0xFFB4B4B4);

  static const Color darkDestructive = Color(0xFF8B2C2C); // Approx pour oklch
  static const Color darkDestructiveForeground = Color(0xFFFAFAFA);

  static const Color darkBorder = Color(0xFF454545);
  static const Color darkInput = Color(0xFF454545);
}