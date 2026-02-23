import 'package:flutter/material.dart';
import 'package:oikos/core/theme/breakpoints.dart';

class AppSizes {
  // ===========================================================================
  // TYPOGRAPHIE RESPONSIVE
  // ===========================================================================

  static TextStyle titleSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) return Theme.of(context).textTheme.titleSmall!;
    if (Breakpoints.isTablet(width)) return Theme.of(context).textTheme.titleMedium!;
    return Theme.of(context).textTheme.titleLarge!;
  }

  static TextStyle bodySize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) return Theme.of(context).textTheme.bodySmall!;
    if (Breakpoints.isTablet(width)) return Theme.of(context).textTheme.bodyMedium!;
    return Theme.of(context).textTheme.bodyLarge!;
  }

  static TextStyle headlineSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) return Theme.of(context).textTheme.headlineSmall!;
    if (Breakpoints.isTablet(width)) return Theme.of(context).textTheme.headlineMedium!;
    return Theme.of(context).textTheme.headlineLarge!;
  }

  static double iconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) return 24.0;
    if (Breakpoints.isTablet(width)) return 28.0;
    return 32.0;
  }

  // ===========================================================================
  // ESPACEMENT ET PADDING RESPONSIVE
  // ===========================================================================

  /// Padding horizontal/vertical de page selon l'écran
  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) return const EdgeInsets.all(16.0);
    if (Breakpoints.isTablet(width)) return const EdgeInsets.all(24.0);
    return const EdgeInsets.all(32.0);
  }

  /// Espacement vertical entre les sections d'une page
  static double sectionSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) return 16.0;
    if (Breakpoints.isTablet(width)) return 20.0;
    return 24.0;
  }

  /// Padding interne des cartes
  static double cardPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) return 16.0;
    return 20.0;
  }

  /// Rayon de bordure des cartes selon l'écran
  static double cardRadius(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) return 12.0;
    return 16.0;
  }

  /// Espacement dans une grille de cartes
  static double gridSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) return 12.0;
    if (Breakpoints.isTablet(width)) return 16.0;
    return 24.0;
  }
}
