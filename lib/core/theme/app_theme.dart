import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  static OutlineInputBorder _border([Color color = AppColors.lightInputBorder]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: color,
        width: 2,
      ),
    );

  // --- Thème Clair ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Outfit', // Fallback si GoogleFonts ne charge pas
      textTheme: AppTypography.textTheme,

      // Configuration des couleurs sémantiques
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightPrimaryForeground,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightSecondaryForeground,
        error: AppColors.lightDestructive,
        onError: AppColors.lightDestructiveError,
        surface: AppColors.lightBackground, // ou AppColors.lightCard
        onSurface: AppColors.lightForeground,
        outline: AppColors.lightBorder,
      ),

      // Exemple d'adaptation des composants globaux (Scaffold, AppBar)
      scaffoldBackgroundColor: AppColors.lightBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightForeground,
        elevation: 0,
      ),

      // Stylisation des inputs (global)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInput,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // --radius: 0.625rem
          borderSide: BorderSide.none,
        ),
        enabledBorder: _border(),
        focusedBorder: _border(AppColors.lightInputBorderFocused),
        errorBorder: _border(AppColors.lightDestructive),
        hintStyle: TextStyle(color: AppColors.lightTextPrimary.withValues(alpha: 0.4)), // Texte d'indication avec opacité à 40%
      ),
    );
  }

  // --- Thème Sombre ---
  // TODO : Ajuster les couleurs sombres (pas fait pour l'instant on ne modifie que le style clair)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Outfit',
      textTheme: AppTypography.textTheme,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkPrimaryForeground,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkSecondaryForeground,
        error: AppColors.darkDestructive,
        onError: AppColors.darkDestructiveForeground,
        surface: AppColors.darkBackground,
        onSurface: AppColors.darkForeground,
        outline: AppColors.darkBorder,
      ),

      scaffoldBackgroundColor: AppColors.darkBackground,

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}