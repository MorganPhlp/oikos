/// Breakpoints pour le responsive design
/// Utilisés dans toute l'application pour la cohérence
class Breakpoints {
  // Largeurs d'écran
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;

  // Helpers pour vérifier le type d'écran
  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < tablet;
  static bool isDesktop(double width) => width >= tablet ;

  // Obtenir le type d'écran
  static ScreenType getScreenType(double width) {
    if (width < mobile) return ScreenType.mobile;
    if (width < tablet) return ScreenType.tablet;
    return ScreenType.desktop;
  }
}

enum ScreenType { mobile, tablet, desktop }

/// Extension pour faciliter l'accès aux dimensions responsives
extension ResponsiveExtension on double {
  /// Retourne une valeur selon la largeur d'écran
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (this >= Breakpoints.desktop) return desktop ?? tablet ?? mobile;
    if (this >= Breakpoints.tablet) return desktop ?? tablet ?? mobile;
    if (this >= Breakpoints.mobile) return tablet ?? mobile;
    return mobile;
  }
}

