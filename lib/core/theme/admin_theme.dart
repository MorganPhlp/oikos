import 'package:flutter/material.dart';

// =============================================================================
// GRADIENT BACKGROUND — ThemeExtension
// =============================================================================

/// Stores the page gradient for the admin section.
/// Readable anywhere via [GradientBackground.of(context)].
class GradientBackground extends ThemeExtension<GradientBackground> {
  final LinearGradient gradient;

  const GradientBackground({required this.gradient});

  // ── Presets ──────────────────────────────────────────────────────────────

  /// White → Light Sky Blue
  static const GradientBackground light = GradientBackground(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFE3F2FD)],
    ),
  );

  /// Deep Navy → Near-Black
  static const GradientBackground dark = GradientBackground(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0D1B2A), Color(0xFF090C12)],
    ),
  );

  static GradientBackground of(BuildContext context) =>
      Theme.of(context).extension<GradientBackground>()!;

  // ── ThemeExtension ────────────────────────────────────────────────────────

  @override
  GradientBackground copyWith({LinearGradient? gradient}) =>
      GradientBackground(gradient: gradient ?? this.gradient);

  @override
  GradientBackground lerp(
    ThemeExtension<GradientBackground>? other,
    double t,
  ) {
    if (other is! GradientBackground) return this;
    return GradientBackground(
      gradient:
          (Gradient.lerp(gradient, other.gradient, t) as LinearGradient?) ??
              gradient,
    );
  }
}

// =============================================================================
// ADMIN COLORS — ThemeExtension
// =============================================================================

/// All admin-specific semantic colors.
/// Access via [AdminColors.of(context)] inside the admin section.
class AdminColors extends ThemeExtension<AdminColors> {
  final Color background;
  final Color pageBackground;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color border;
  final Color borderStrong;
  final Color inputBackground;
  final Color ring;
  final Color sidebarBackground;

  const AdminColors({
    required this.background,
    required this.pageBackground,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.border,
    required this.borderStrong,
    required this.inputBackground,
    required this.ring,
    required this.sidebarBackground,
  });

  // ── Light ─────────────────────────────────────────────────────────────────

  static const AdminColors light = AdminColors(
    background: Color(0xFFFFFFFF),
    pageBackground: Color(0xFFF4F4F6),
    foreground: Color(0xFF0A0A0A),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF0A0A0A),
    primary: Color(0xFF030213),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFF0F0F5),
    muted: Color(0xFFECECF0),
    mutedForeground: Color(0xFF717182),
    accent: Color(0xFFE9EBEF),
    accentForeground: Color(0xFF030213),
    border: Color(0x1A000000),
    borderStrong: Color(0x26000000),
    inputBackground: Color(0xFFF3F3F5),
    ring: Color(0xFFB3B3B3),
    sidebarBackground: Color(0xFFFFFFFF),
  );

  // ── Dark ──────────────────────────────────────────────────────────────────

  static const AdminColors dark = AdminColors(
    background: Color(0xFF13151C),
    pageBackground: Color(0xFF181A21),
    foreground: Color(0xFFF1F1F5),
    card: Color(0xFF1E2130),
    cardForeground: Color(0xFFF1F1F5),
    primary: Color(0xFFE2E2F0),
    primaryForeground: Color(0xFF13151C),
    secondary: Color(0xFF252836),
    muted: Color(0xFF282B3A),
    mutedForeground: Color(0xFF8E8EA8),
    accent: Color(0xFF2D3045),
    accentForeground: Color(0xFFE2E2F0),
    border: Color(0x14FFFFFF),
    borderStrong: Color(0x1FFFFFFF),
    inputBackground: Color(0xFF23262F),
    ring: Color(0xFF4A4A6A),
    sidebarBackground: Color(0xFF0F1117),
  );

  // ── Convenience ──────────────────────────────────────────────────────────

  static AdminColors of(BuildContext context) =>
      Theme.of(context).extension<AdminColors>()!;

  /// Theme-aware card decoration.
  /// In dark mode: adds a subtle border and deeper shadow.
  BoxDecoration get cardDecoration {
    final isDarkSurface = card.computeLuminance() < 0.5;
    return BoxDecoration(
      color: card,
      borderRadius: const BorderRadius.all(
        Radius.circular(AdminTheme.radiusXl),
      ),
      border: isDarkSurface ? Border.all(color: border) : null,
      boxShadow: isDarkSurface
          ? [
              const BoxShadow(
                color: Color(0x28000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ]
          : [
              const BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
              const BoxShadow(
                color: Color(0x05000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
    );
  }

  /// Compact variant (mobile).
  BoxDecoration get cardDecorationCompact {
    final isDarkSurface = card.computeLuminance() < 0.5;
    return BoxDecoration(
      color: card,
      borderRadius: const BorderRadius.all(
        Radius.circular(AdminTheme.radiusMd),
      ),
      border: isDarkSurface ? Border.all(color: border) : null,
      boxShadow: [
        BoxShadow(
          color: isDarkSurface
              ? const Color(0x1A000000)
              : const Color(0x08000000),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // ── ThemeExtension ────────────────────────────────────────────────────────

  @override
  AdminColors copyWith({
    Color? background,
    Color? pageBackground,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? border,
    Color? borderStrong,
    Color? inputBackground,
    Color? ring,
    Color? sidebarBackground,
  }) =>
      AdminColors(
        background: background ?? this.background,
        pageBackground: pageBackground ?? this.pageBackground,
        foreground: foreground ?? this.foreground,
        card: card ?? this.card,
        cardForeground: cardForeground ?? this.cardForeground,
        primary: primary ?? this.primary,
        primaryForeground: primaryForeground ?? this.primaryForeground,
        secondary: secondary ?? this.secondary,
        muted: muted ?? this.muted,
        mutedForeground: mutedForeground ?? this.mutedForeground,
        accent: accent ?? this.accent,
        accentForeground: accentForeground ?? this.accentForeground,
        border: border ?? this.border,
        borderStrong: borderStrong ?? this.borderStrong,
        inputBackground: inputBackground ?? this.inputBackground,
        ring: ring ?? this.ring,
        sidebarBackground: sidebarBackground ?? this.sidebarBackground,
      );

  @override
  AdminColors lerp(ThemeExtension<AdminColors>? other, double t) {
    if (other is! AdminColors) return this;
    return AdminColors(
      background: Color.lerp(background, other.background, t)!,
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryForeground:
          Color.lerp(primaryForeground, other.primaryForeground, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentForeground:
          Color.lerp(accentForeground, other.accentForeground, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      ring: Color.lerp(ring, other.ring, t)!,
      sidebarBackground:
          Color.lerp(sidebarBackground, other.sidebarBackground, t)!,
    );
  }
}

// =============================================================================
// ADMIN THEME
// =============================================================================

class AdminTheme {
  // ===========================================================================
  // COULEURS DE BASE (Light — rétrocompatibilité)
  // Pour le dark mode, utiliser AdminColors.of(context).xxx
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
  // COULEUR D'ACTION (verte — brand identique light/dark)
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
  // DÉCORATIONS STATIQUES (Light — rétrocompatibilité)
  // Préférer AdminColors.of(context).cardDecoration pour le dark mode.
  // ===========================================================================

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
  // THEME DATA
  // ===========================================================================

  static TextTheme _buildTextTheme(Color main, Color subdued) => TextTheme(
    titleLarge: TextStyle(
      fontSize: 36,
      fontWeight: fontWeightMedium,
      color: main,
      height: 1.5,
    ),
    titleMedium: TextStyle(
      fontSize: 30,
      fontWeight: fontWeightMedium,
      color: main,
      height: 1.5,
    ),
    titleSmall: TextStyle(
      fontSize: 24,
      fontWeight: fontWeightMedium,
      color: main,
      height: 1.5,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: fontWeightMedium,
      color: main,
      height: 1.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: fontWeightMedium,
      color: main,
      height: 1.5,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: fontWeightMedium,
      color: main,
      height: 1.5,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: fontWeightNormal,
      color: main,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: fontWeightNormal,
      color: main,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: fontWeightNormal,
      color: subdued,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: fontWeightMedium,
      color: main,
      height: 1.5,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: fontWeightMedium,
      color: main,
      height: 1.5,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: fontWeightMedium,
      color: subdued,
      height: 1.5,
    ),
  );

  /// Light ThemeData.
  /// Includes [AdminColors.light] and [GradientBackground.light] extensions.
  static ThemeData get lightTheme {
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
        indicatorColor: actionGreenLight,
        useIndicator: true,
        unselectedIconTheme: const IconThemeData(color: mutedForeground),
        selectedIconTheme: const IconThemeData(color: actionGreen),
        unselectedLabelTextStyle: const TextStyle(color: mutedForeground),
        selectedLabelTextStyle: const TextStyle(
          color: actionGreen,
          fontWeight: fontWeightMedium,
        ),
      ),
      textTheme: _buildTextTheme(
        AdminColors.light.foreground,
        AdminColors.light.mutedForeground,
      ),
    ).copyWith(
      extensions: <ThemeExtension<dynamic>>[
        AdminColors.light,
        GradientBackground.light,
      ],
    );
  }

  /// Dark ThemeData.
  /// Includes [AdminColors.dark] and [GradientBackground.dark] extensions.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: Colors.transparent,
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: actionGreenLight.withValues(alpha: 0.15),
        useIndicator: true,
        unselectedIconTheme: const IconThemeData(
          color: Color(0xFF8E8EA8), // AdminColors.dark.mutedForeground
        ),
        selectedIconTheme: const IconThemeData(color: actionGreen),
        unselectedLabelTextStyle: const TextStyle(
          color: Color(0xFF8E8EA8), // AdminColors.dark.mutedForeground
        ),
        selectedLabelTextStyle: const TextStyle(
          color: actionGreen,
          fontWeight: fontWeightMedium,
        ),
      ),
      textTheme: _buildTextTheme(
        AdminColors.dark.foreground,
        AdminColors.dark.mutedForeground,
      ),
    ).copyWith(
      extensions: <ThemeExtension<dynamic>>[
        AdminColors.dark,
        GradientBackground.dark,
      ],
    );
  }

}
