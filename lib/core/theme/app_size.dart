import 'package:flutter/material.dart';
import 'package:oikos/core/theme/breakpoints.dart';

class AppSizes {
  // Fonction utilitaire pour adapter la taille selon le contexte
  static TextStyle titleSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) {
      return Theme.of(context).textTheme.titleSmall!;
    } // Large Desktop
    else if (Breakpoints.isTablet(width)) {
      return Theme.of(context).textTheme.titleMedium!;
    } else {
      return Theme.of(context).textTheme.titleLarge!;
    }
  }

  static TextStyle bodySize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) {
      return Theme.of(context).textTheme.bodySmall!;
    } // Large Desktop
    else if (Breakpoints.isTablet(width)) {
      return Theme.of(context).textTheme.bodyMedium!;
    } else {
      return Theme.of(context).textTheme.bodyLarge!;
    }
  }

  static TextStyle headlineSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Breakpoints.isMobile(width)) {
      return Theme.of(context).textTheme.headlineSmall!;
    } // Large Desktop
    else if (Breakpoints.isTablet(width)) {
      return Theme.of(context).textTheme.headlineMedium!;
    } else {
      return Theme.of(context).textTheme.headlineLarge!;
    }
  }

  static double iconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (Breakpoints.isMobile(width)) {
      return 24.0; // Taille standard mobile
    } 
    else if (Breakpoints.isTablet(width)) {
      return 28.0; // Un peu plus grand pour les tablettes
    } 
    else {
      return 32.0; // Taille confortable pour le Desktop
    }
  }


}
