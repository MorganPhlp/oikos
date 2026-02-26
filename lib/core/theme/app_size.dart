import 'package:flutter/material.dart';
import 'package:oikos/core/theme/breakpoints.dart';

/// Helpers de tailles responsives pour la typographie et les icônes.
/// Adapte automatiquement les tailles selon le type d'écran (mobile/tablet/desktop).
class AppSizes {
  AppSizes._();

  /// TextStyle pour les titres / valeurs KPI (grande taille).
  /// mobile: 16px — tablet: 18px — desktop: 20px
  static TextStyle headlineSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fontSize = Breakpoints.isMobile(w)
        ? 16.0
        : Breakpoints.isTablet(w)
            ? 18.0
            : 20.0;
    return TextStyle(fontSize: fontSize);
  }

  /// TextStyle pour les corps de texte (taille normale).
  /// mobile: 12px — tablet: 13px — desktop: 14px
  static TextStyle bodySize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fontSize = Breakpoints.isMobile(w)
        ? 12.0
        : Breakpoints.isTablet(w)
            ? 13.0
            : 14.0;
    return TextStyle(fontSize: fontSize);
  }

  /// Taille d'icône responsive.
  /// mobile: 20px — tablet: 22px — desktop: 24px
  static double iconSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Breakpoints.isMobile(w) ? 20.0 : Breakpoints.isTablet(w) ? 22.0 : 24.0;
  }
}
