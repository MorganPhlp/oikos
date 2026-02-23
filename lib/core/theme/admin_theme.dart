import 'package:flutter/material.dart';

class AdminTheme {
  // ===========================================================================
  // COULEURS DE BASE
  // ===========================================================================
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF0A0A0A);

  /// Fond légèrement grisé pour le corps des pages
  static const Color pageBackground = Color(0xFFF4F4F6);

  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF0A0A0A);

  static const Color primary = Color(0xFF030213);
  static const Color primaryForeground = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFFF0F0F5);
  static const Color muted = Color(0xFFECECF0);
  static const Color mutedForeground = Color(0xFF717182);

  static const Color accent = Color(0xFFE9EBEF);
  static const Color accentForeground = Color(0xFF030213);

  static const Color border = Color(0x1A000000);
  static const Color borderStrong = Color(0x26000000);
  static const Color inputBackground = Color(0xFFF3F3F5);
  static const Color ring = Color(0xFFB3B3B3);

  // ===========================================================================
  // COULEURS SÉMANTIQUES
  // ===========================================================================
  static const Color errorForeground = Color(0xFFE53E3E);
  static const Color successForeground = Color(0xFF38A169);
  static const Color warningForeground = Color(0xFFD69E2E);
  static const Color warningBackground = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);
  static const Color secondaryForeground = Color(0xFF444444);

  static const Color destructive = Color(0xFFD4183D);
  static const Color destructiveForeground = Color(0xFFFFFFFF);

  // ===========================================================================
  // COULEUR D'ACTION PRINCIPALE (verte — utilisée pour tous les CTA)
  // ===========================================================================
  static const Color actionGreen = Color(0xFF16A34A);
  static const Color actionGreenHover = Color(0xFF15803D);
  static const Color actionGreenLight = Color(0xFFDCFCE7);
  static const Color actionGreenForeground = Color(0xFFFFFFFF);

  // ===========================================================================
  // RAYONS DE BORDURE
  // ===========================================================================
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 10.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 24.0;

  // ===========================================================================
  // TYPOGRAPHIE
  // ===========================================================================
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // ===========================================================================
  // ESPACEMENT
  // ===========================================================================
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ===========================================================================
  // DÉCORATIONS RÉUTILISABLES
  // ===========================================================================

  /// Décoration standard pour les cartes (fond blanc, ombre douce, rayon XL)
  static const BoxDecoration cardDecoration = BoxDecoration(
    color: card,
    borderRadius: BorderRadius.all(Radius.circular(radiusXl)),
    boxShadow: [
      BoxShadow(
        color: Color(0x0A000000),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
      BoxShadow(
        color: Color(0x05000000),
        blurRadius: 24,
        offset: Offset(0, 8),
      ),
    ],
  );

  /// Décoration pour les cartes compactes (mobile)
  static const BoxDecoration cardDecorationCompact = BoxDecoration(
    color: card,
    borderRadius: BorderRadius.all(Radius.circular(radiusMd)),
    boxShadow: [
      BoxShadow(
        color: Color(0x08000000),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  );

  // ===========================================================================
  // THÈME MATERIAL
  // ===========================================================================
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: Colors.transparent,
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: primary.withValues(alpha: 0.08),
        useIndicator: true,
        unselectedIconTheme: const IconThemeData(color: mutedForeground),
        selectedIconTheme: const IconThemeData(color: primary),
        unselectedLabelTextStyle: const TextStyle(color: mutedForeground),
        selectedLabelTextStyle: const TextStyle(
          color: primary,
          fontWeight: fontWeightMedium,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 36,
          fontWeight: fontWeightMedium,
          color: foreground,
          height: 1.5,
        ),
        titleMedium: TextStyle(
          fontSize: 30,
          fontWeight: fontWeightMedium,
          color: foreground,
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
        const GradientBackground(
          mainGradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFE3F2FD)],
          ),
        ),
      ],
    );
  }
}

class GradientBackground extends ThemeExtension<GradientBackground> {
  final Gradient? mainGradient;

  const GradientBackground({required this.mainGradient});

  @override
  ThemeExtension<GradientBackground> copyWith({Gradient? mainGradient}) =>
      GradientBackground(mainGradient: mainGradient ?? this.mainGradient);

  @override
  ThemeExtension<GradientBackground> lerp(
    ThemeExtension<GradientBackground>? other,
    double t,
  ) => this;
}
