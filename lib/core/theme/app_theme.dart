import 'package:flutter/material.dart';
import 'package:oikos/core/theme/oikos_button_theme.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  // Helper pour créer des bordures d'input personnalisées avec une couleur spécifique
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 2),
  );

  // --- Thème Clair ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Outfit', // Fallback si GoogleFonts ne charge pas
      textTheme: AppTypography.textTheme,

      extensions: <ThemeExtension<dynamic>>[
        OikosButtonTheme(
          primaryGradient: const LinearGradient(
            colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          secondaryGradient: Colors
              .transparent, // Pas de gradient pour les boutons secondaires, juste une couleur unie
          tertiaryGradient: const LinearGradient(
            colors: [Colors.orangeAccent, Colors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          shadowColor: AppColors.gradientGreenEnd.withValues(alpha: 0.4),
          tertiaryShadowColor: Colors.orange.withValues(alpha: 0.4),
          disabledColor: Colors.grey.shade300,
        ),
      ],

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
        tertiary: AppColors.orange,
        onTertiary: AppColors.lightPrimaryForeground,
        tertiaryContainer: Color(0xFFFFF3E0),
      ),

      // Adaptation des composants globaux (Scaffold, AppBar, ...)
      scaffoldBackgroundColor: AppColors.lightBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightForeground,
        elevation: 0,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInput,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // --radius: 0.625rem
          borderSide: BorderSide.none,
        ),
        enabledBorder: _border(AppColors.lightInputBorder),
        focusedBorder: _border(AppColors.lightInputBorderFocused),
        errorBorder: _border(AppColors.lightDestructive),
        hintStyle: TextStyle(
          color: AppColors.lightTextPrimary.withValues(alpha: 0.4),
        ), // Texte d'indication avec opacité à 40%
      ),

      // button Theme
      elevatedButtonTheme: _baseElevatedButtonTheme(),
    );
  }

  // --- Thème Sombre ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Outfit',
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.darkForeground,
        displayColor: AppColors.darkForeground,
      ),

      extensions: <ThemeExtension<dynamic>>[
        OikosButtonTheme(
          primaryGradient: const LinearGradient(
            colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          secondaryGradient: Colors
              .transparent, // Pas de gradient pour les boutons secondaires, juste une couleur unie
          tertiaryGradient: const LinearGradient(
            colors: [Colors.orangeAccent, Colors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),

          shadowColor: Colors.black.withValues(alpha: 0.2),
          tertiaryShadowColor: Colors.orange.withValues(alpha: 0.2),
          disabledColor: AppColors.darkMuted,
        ),
      ],

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
        tertiary: AppColors.orange,
        tertiaryContainer: Color(0xFF3E2723),
      ),

      scaffoldBackgroundColor: AppColors.darkBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkForeground,
        elevation: 0,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInput,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: _border(AppColors.darkInputBorder),
        focusedBorder: _border(AppColors.darkInputBorderFocused),
        errorBorder: _border(AppColors.darkDestructive),
        hintStyle: TextStyle(
          color: AppColors.darkForeground.withValues(alpha: 0.4),
        ),
      ),

      elevatedButtonTheme: _baseElevatedButtonTheme(),
    );
  }

  // Factorisation du style des boutons (commun aux deux thèmes)
  static ElevatedButtonThemeData _baseElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          50,
        ), // Ajusté la hauteur min (25 semblait petit)
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
