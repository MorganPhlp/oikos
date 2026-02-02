import 'package:flutter/material.dart';

/// Thème shadcn/ui converti pour Flutter
/// Basé sur le système de design tokens CSS original
class AdminTheme {
  // ============================================
  // COULEURS - MODE CLAIR
  // ============================================
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF0A0A0A); // oklch(0.145 0 0)
  static const Color title = Color(0xFF15803D); // oklch(0.145 0 0)
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF0A0A0A);
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF0A0A0A);
  static const Color primary = Color(0xFF030213);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFF0F0F5); // oklch(0.95 0.0058 264.53)
  static const Color secondaryForeground = Color(0xFF030213);
  static const Color muted = Color(0xFFECECF0);
  static const Color mutedForeground = Color(0xFF717182);
  static const Color accent = Color(0xFFE9EBEF);
  static const Color accentForeground = Color(0xFF030213);
  static const Color destructive = Color(0xFFD4183D);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color border = Color(0x1A000000); // rgba(0, 0, 0, 0.1)
  static const Color input = Colors.transparent;
  static const Color inputBackground = Color(0xFFF3F3F5);
  static const Color switchBackground = Color(0xFFCBCED4);
  static const Color ring = Color(0xFFB3B3B3); // oklch(0.708 0 0)



  // ============================================
  // COULEURS - MODE SOMBRE
  // ============================================
  static const Color darkBackground = Color(0xFF0A0A0A); // oklch(0.145 0 0)
  static const Color darkForeground = Color(0xFFFAFAFA); // oklch(0.985 0 0)
  static const Color darkCard = Color(0xFF0A0A0A);
  static const Color darkCardForeground = Color(0xFFFAFAFA);
  static const Color darkPopover = Color(0xFF0A0A0A);
  static const Color darkPopoverForeground = Color(0xFFFAFAFA);
  static const Color darkPrimary = Color(0xFFFAFAFA);
  static const Color darkPrimaryForeground = Color(0xFF171717);
  static const Color darkSecondary = Color(0xFF262626); // oklch(0.269 0 0)
  static const Color darkSecondaryForeground = Color(0xFFFAFAFA);
  static const Color darkMuted = Color(0xFF262626);
  static const Color darkMutedForeground = Color(0xFFB3B3B3);
  static const Color darkAccent = Color(0xFF262626);
  static const Color darkAccentForeground = Color(0xFFFAFAFA);
  static const Color darkDestructive = Color(
    0xFF7F1D1D,
  ); // oklch(0.396 0.141 25.723)
  static const Color darkDestructiveForeground = Color(0xFFEF4444);
  static const Color darkBorder = Color(0xFF262626);
  static const Color darkInput = Color(0xFF262626);
  static const Color darkRing = Color(0xFF525252); // oklch(0.439 0 0)


 

  // ============================================
  // RAYONS DE BORDURE
  // ============================================
  static const double radius = 10.0; // 0.625rem = 10px
  static const double radiusSm = 6.0; // radius - 4px
  static const double radiusMd = 8.0; // radius - 2px
  static const double radiusLg = 10.0; // radius
  static const double radiusXl = 14.0; // radius + 4px

  // ============================================
  // TYPOGRAPHIE
  // ============================================
  static const double fontSize = 16.0;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;

  // ============================================
  // THÈME CLAIR
  // ============================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter', // ou votre police préférée
      // Schéma de couleurs
      colorScheme: const ColorScheme.light(
        surface: background,
        onSurface: foreground,
        primary: primary,
        onPrimary: primaryForeground,
        secondary: secondary,
        onSecondary: secondaryForeground,
        error: destructive,
        onError: destructiveForeground,
        outline: border,
      ),

      // Fond
      scaffoldBackgroundColor: background,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: title,
        ),
        scrolledUnderElevation: 0,
      ),


      // Boutons élevés (Primary)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: fontWeightMedium,
          ),
        ),
      ),

      // Boutons outlined (Secondary)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryForeground,
          backgroundColor: secondary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          side: BorderSide.none,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: fontWeightMedium,
          ),
        ),
      ),

      // Boutons texte (Ghost)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentForeground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: fontWeightMedium,
          ),
        ).copyWith(overlayColor: WidgetStateProperty.all(accent)),
      ),

      // Champs de texte
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: destructive, width: 2),
        ),
        labelStyle: const TextStyle(
          color: mutedForeground,
          fontWeight: fontWeightMedium,
        ),
        hintStyle: const TextStyle(
          color: mutedForeground,
          fontWeight: fontWeightNormal,
        ),
      ),


      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(primaryForeground),
        side: const BorderSide(color: primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),

      // Radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return mutedForeground;
        }),
      ),


      // Typography
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 36,
          fontWeight: fontWeightMedium,
          color: title,
          height: 1.5,
        ),
        titleMedium: TextStyle(
          fontSize: 30,
          fontWeight: fontWeightMedium,
          color: title,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontSize: 24,
          fontWeight: fontWeightMedium,
          color: foreground,
          height: 1.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: fontWeightMedium,
          color: foreground,
          height: 1.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: fontWeightMedium,
          color: foreground,
          height: 1.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: fontWeightMedium,
          color: foreground,
          height: 1.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightNormal,
          color: foreground,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightNormal,
          color: foreground,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: fontWeightNormal,
          color: mutedForeground,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightMedium,
          color: foreground,
          height: 1.5,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightMedium,
          color: foreground,
          height: 1.5,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: fontWeightMedium,
          color: mutedForeground,
          height: 1.5,
        ),
      ),
    ).copyWith(
      extensions: <ThemeExtension<dynamic>>[
        const MyColors(
          mainGradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 255, 255), Color(0xFFE3F2FD)], // Vert 50, Bleu 50
          ),
        ),
      ],
    );
  }

  // ============================================
  // THÈME SOMBRE
  // ============================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',

      // Schéma de couleurs
      colorScheme: const ColorScheme.dark(
        surface: darkBackground,
        onSurface: darkForeground,
        primary: darkPrimary,
        onPrimary: darkPrimaryForeground,
        secondary: darkSecondary,
        onSecondary: darkSecondaryForeground,
        error: darkDestructive,
        onError: darkDestructiveForeground,
        outline: darkBorder,
      ),

      // Fond
      scaffoldBackgroundColor: darkBackground,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: title,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightMedium,
          color: darkForeground,
        ),
        scrolledUnderElevation: 0,
      ),

      // Boutons élevés
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkPrimaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: fontWeightMedium,
          ),
        ),
      ),

      // Boutons outlined
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkSecondaryForeground,
          backgroundColor: darkSecondary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          side: BorderSide.none,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: fontWeightMedium,
          ),
        ),
      ),

      // Boutons texte
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkAccentForeground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: fontWeightMedium,
          ),
        ).copyWith(overlayColor: WidgetStateProperty.all(darkAccent)),
      ),

      // Champs de texte
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInput,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkRing, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkDestructive),
        ),
        labelStyle: const TextStyle(
          color: darkMutedForeground,
          fontWeight: fontWeightMedium,
        ),
        hintStyle: const TextStyle(
          color: darkMutedForeground,
          fontWeight: fontWeightNormal,
        ),
      ),

      
      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(darkPrimaryForeground),
        side: const BorderSide(color: darkMutedForeground, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        displayMedium: TextStyle(
          fontSize: 30,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightNormal,
          color: darkForeground,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightNormal,
          color: darkForeground,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: fontWeightNormal,
          color: darkMutedForeground,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightMedium,
          color: darkForeground,
          height: 1.5,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: fontWeightMedium,
          color: darkMutedForeground,
          height: 1.5,
        ),
      ),
    );
  }
}

//  classe pour transporter mon dégradé
class MyColors extends ThemeExtension<MyColors> {
  final Gradient? mainGradient;
  const MyColors({required this.mainGradient});

  @override
  ThemeExtension<MyColors> copyWith({Gradient? mainGradient}) => MyColors(mainGradient: mainGradient ?? this.mainGradient);

  @override
  ThemeExtension<MyColors> lerp(ThemeExtension<MyColors>? other, double t) => this;
}

// ============================================
// EXTENSION POUR ACCÈS FACILE AUX COULEURS
// ============================================
extension AdminColors on BuildContext {
  // Accès rapide aux couleurs via le contexte
  Color get primary => Theme.of(this).brightness == Brightness.dark
      ? AdminTheme.darkPrimary
      : AdminTheme.primary;

  Color get muted => Theme.of(this).brightness == Brightness.dark
      ? AdminTheme.darkMuted
      : AdminTheme.muted;

  Color get mutedForeground => Theme.of(this).brightness == Brightness.dark
      ? AdminTheme.darkMutedForeground
      : AdminTheme.mutedForeground;

  Color get destructive => Theme.of(this).brightness == Brightness.dark
      ? AdminTheme.darkDestructive
      : AdminTheme.destructive;

  Color get border => Theme.of(this).brightness == Brightness.dark
      ? AdminTheme.darkBorder
      : AdminTheme.border;

  Color get accent => Theme.of(this).brightness == Brightness.dark
      ? AdminTheme.darkAccent
      : AdminTheme.accent;

}

/// Couleurs utilisées dans le module Community
class CommunityColors {
  static const Color primary = Color(0xFF16A34A);
  static const Color primaryLight = Color(0xFFDCFCE7);
  static const Color danger = Colors.red;
  static const Color warning = Color(0xFFFEF3C7);
  static const Color warningBorder = Color(0xFFFDE68A);
  static const Color warningText = Color(0xFF92400E);
}
