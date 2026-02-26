import 'package:flutter/material.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/core/theme/oikos_button_theme.dart';
import 'app_colors.dart';
import 'app_typography.dart';

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
    background: AppColors.lightBackground,
    pageBackground: Color(0xFFF2F7E8),
    foreground: AppColors.lightForeground,
    card: Colors.white,
    cardForeground: AppColors.lightForeground,
    primary: AppColors.lightPrimary,
    primaryForeground: AppColors.lightPrimaryForeground,
    secondary: AppColors.lightSecondary,
    muted: AppColors.lightMuted,
    mutedForeground: AppColors.lightMutedForeground,
    accent: Color(0xFFE9EBEF),
    accentForeground: AppColors.lightSecondaryForeground,
    border: AppColors.lightBorder,
    borderStrong: Color(0x26000000),
    inputBackground: AppColors.lightInput,
    ring: AppColors.lightInputBorderFocused,
    sidebarBackground: Colors.white,
  );

  // ── Dark ──────────────────────────────────────────────────────────────────

  static const AdminColors dark = AdminColors(
    background: AppColors.darkBackground,
    pageBackground: Color(0xFF1F211E),
    foreground: AppColors.darkForeground,
    card: Color(0xFF252824),
    cardForeground: AppColors.darkForeground,
    primary: AppColors.darkPrimary,
    primaryForeground: AppColors.darkPrimaryForeground,
    secondary: AppColors.darkSecondary,
    muted: AppColors.darkMuted,
    mutedForeground: AppColors.darkMutedForeground,
    accent: Color(0xFF2D3045),
    accentForeground: AppColors.darkForeground,
    border: AppColors.darkBorder,
    borderStrong: Color(0x1FFFFFFF),
    inputBackground: AppColors.darkInput,
    ring: AppColors.darkInputBorderFocused,
    sidebarBackground: AppColors.darkBackground,
  );

  // ── Convenience ──────────────────────────────────────────────────────────

  static AdminColors of(BuildContext context) =>
      Theme.of(context).extension<AdminColors>()!;

  /// Theme-aware card decoration.
  BoxDecoration get cardDecoration {
    final isDarkSurface = card.computeLuminance() < 0.5;
    return BoxDecoration(
      color: card,
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
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
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
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
// APP THEME
// =============================================================================

class AppTheme {
  const AppTheme._();

  // ===========================================================================
  // ESPACEMENT
  // ===========================================================================
  static const double spacingXs  = 4.0;
  static const double spacingSm  = 8.0;
  static const double spacingMd  = 16.0;
  static const double spacingLg  = 24.0;
  static const double spacingXl  = 32.0;
  static const double spacingXxl = 48.0;

  // ===========================================================================
  // RAYONS DE BORDURE
  // ===========================================================================
  static const double radiusSm  = 6.0;
  static const double radiusMd  = 8.0;
  static const double radiusLg  = 10.0;
  static const double radiusXl  = 16.0;
  static const double radiusXxl = 24.0;

  // ===========================================================================
  // COULEURS SÉMANTIQUES (ex-AdminTheme)
  // ===========================================================================
  static const Color actionGreen           = AppColors.lightPrimary;
  static const Color actionGreenLight      = AppColors.lightPrimaryContainer;
  static const Color actionGreenForeground = AppColors.lightPrimaryForeground;
  static const Color errorForeground       = AppColors.lightDestructive;
  static const Color successForeground     = AppColors.lightPrimary;
  static const Color warningForeground     = Color(0xFFD69E2E);
  static const Color warningBackground     = Color(0xFFFFFBEB);
  static const Color warningBorder         = Color(0xFFFDE68A);
  static const Color mutedForeground       = AppColors.lightMutedForeground;

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
      fontFamily: 'Outfit',
      textTheme: AppTypography.textTheme,

      extensions: <ThemeExtension<dynamic>>[
        AdminColors.light,
        OikosButtonTheme(
          primaryGradient: const LinearGradient(
            colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          secondaryGradient: Colors.transparent,
          tertiaryGradient: const LinearGradient(
            colors: [Colors.orangeAccent, Colors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          shadowColor: AppColors.gradientGreenEnd.withValues(alpha: 0.4),
          tertiaryShadowColor: Colors.orange.withValues(alpha: 0.4),
          disabledColor: Colors.grey.shade300,
        ),

        ActionCardTheme(
          transport: Color(0xFF4CAF50),
          alimentation: Color(0xFFFF9800),
          energie: Color(0xFFFFC107),
          eau: Color(0xFF2196F3),
          dechet: Color(0xFF795548),
          numerique: Color(0xFF9C27B0),
          logement: Color(0xFF607D8B),
          biodiversite: Color(0xFF009688),
          textile: Color(0xFFE91E63),
          defaultColor: Colors.grey,
        ),
      ],

      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightPrimaryForeground,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightSecondaryForeground,
        error: AppColors.lightDestructive,
        onError: AppColors.lightDestructiveError,
        surface: AppColors.lightBackground,
        onSurface: AppColors.lightForeground,
        outline: AppColors.lightBorder,
        tertiary: AppColors.orange,
        onTertiary: AppColors.lightPrimaryForeground,
        tertiaryContainer: Color(0xFFFFF3E0),
      ),

      scaffoldBackgroundColor: AppColors.lightBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightForeground,
        elevation: 0,
      ),

      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.lightPrimaryContainer,
        useIndicator: true,
        unselectedIconTheme: IconThemeData(color: AppColors.lightMutedForeground),
        selectedIconTheme: IconThemeData(color: AppColors.lightPrimary),
        unselectedLabelTextStyle: TextStyle(color: AppColors.lightMutedForeground),
        selectedLabelTextStyle: TextStyle(
          color: AppColors.lightPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInput,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: _border(AppColors.lightInputBorder),
        focusedBorder: _border(AppColors.lightInputBorderFocused),
        errorBorder: _border(AppColors.lightDestructive),
        hintStyle: TextStyle(
          color: AppColors.lightTextPrimary.withValues(alpha: 0.4),
        ),
      ),

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
        AdminColors.dark,
        OikosButtonTheme(
          primaryGradient: const LinearGradient(
            colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          secondaryGradient: Colors.transparent,
          tertiaryGradient: const LinearGradient(
            colors: [Colors.orangeAccent, Colors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),

          shadowColor: Colors.black.withValues(alpha: 0.2),
          tertiaryShadowColor: Colors.orange.withValues(alpha: 0.2),
          disabledColor: AppColors.darkMuted,
        ),

        ActionCardTheme(
          transport: Color(0xFF4CAF50),
          alimentation: Color(0xFFFF9800),
          energie: Color(0xFFFFC107),
          eau: Color(0xFF2196F3),
          dechet: Color(0xFF795548),
          numerique: Color(0xFF9C27B0),
          logement: Color(0xFF607D8B),
          biodiversite: Color(0xFF009688),
          textile: Color(0xFFE91E63),
          defaultColor: Colors.grey,
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

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.darkPrimary.withValues(alpha: 0.15),
        useIndicator: true,
        unselectedIconTheme: const IconThemeData(color: AppColors.darkMutedForeground),
        selectedIconTheme: const IconThemeData(color: AppColors.darkPrimary),
        unselectedLabelTextStyle: const TextStyle(color: AppColors.darkMutedForeground),
        selectedLabelTextStyle: const TextStyle(
          color: AppColors.darkPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.transparent,
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

  static ElevatedButtonThemeData _baseElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
