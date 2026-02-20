import 'package:flutter/material.dart';

class AdminTheme {
  // Couleurs
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF0A0A0A);
  static const Color errorForeground = Color.fromARGB(255, 248, 86, 86);
  static const Color successForeground = Color.fromARGB(255, 123, 245, 98);
  static const Color secondaryForeground = Color.fromARGB(255, 68, 68, 68);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF0A0A0A);
  static const Color primary = Color(0xFF030213);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFF0F0F5);
  static const Color muted = Color(0xFFECECF0);
  static const Color mutedForeground = Color(0xFF717182);
  static const Color accent = Color(0xFFE9EBEF);
  static const Color accentForeground = Color(0xFF030213);
  static const Color destructive = Color(0xFFD4183D);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color border = Color(0x1A000000);
  static const Color inputBackground = Color(0xFFF3F3F5);
  static const Color ring = Color(0xFFB3B3B3);

  // Rayons de bordure
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 10.0;

  // Typographie
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;

  static const BoxDecoration cardDecoration = BoxDecoration(
    color: card,
    borderRadius: BorderRadius.all(Radius.circular(radiusMd)),
    boxShadow: [
      BoxShadow(
        color: border,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: Colors.transparent,
      
      // On rend la barre de navigation transparente
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // Pareil pour le NavigationRail (Sidebar)
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: primary.withValues(alpha: 0.08),
        useIndicator: true,
        unselectedIconTheme: const IconThemeData(color: mutedForeground),
        selectedIconTheme: const IconThemeData(color: primary),
        unselectedLabelTextStyle: const TextStyle(color: mutedForeground),
        selectedLabelTextStyle: const TextStyle(color: primary, fontWeight: fontWeightMedium),
      ),     
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 36, fontWeight: fontWeightMedium, color: foreground, height: 1.5),
        titleMedium: TextStyle(fontSize: 30, fontWeight: fontWeightMedium, color: foreground, height: 1.5),
        titleSmall: TextStyle(fontSize: 24, fontWeight: fontWeightMedium, color: foreground, height: 1.5),
        headlineLarge: TextStyle(fontSize: 24, fontWeight: fontWeightMedium, color: foreground, height: 1.5),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: fontWeightMedium, color: foreground, height: 1.5),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: fontWeightMedium, color: foreground, height: 1.5),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: fontWeightNormal, color: foreground, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: fontWeightNormal, color: foreground, height: 1.5),
        bodySmall: TextStyle(fontSize: 12, fontWeight: fontWeightNormal, color: mutedForeground, height: 1.5),
        labelLarge: TextStyle(fontSize: 16, fontWeight: fontWeightMedium, color: foreground, height: 1.5),
        labelMedium: TextStyle(fontSize: 14, fontWeight: fontWeightMedium, color: foreground, height: 1.5),
        labelSmall: TextStyle(fontSize: 12, fontWeight: fontWeightMedium, color: mutedForeground, height: 1.5),
      ),
    ).copyWith(
      extensions: <ThemeExtension<dynamic>>[
        const GradientBackground(
          mainGradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 255, 255), Color(0xFFE3F2FD)],
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
  ThemeExtension<GradientBackground> lerp(ThemeExtension<GradientBackground>? other, double t) => this;
}
