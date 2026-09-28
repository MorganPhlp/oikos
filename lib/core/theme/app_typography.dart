import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  // On définit la font globale ici pour pouvoir la changer facilement
  static TextTheme get textTheme {
    return Typography.material2021().black.apply(fontFamily: 'Outfit');
  }

  // Styles spécifiques basés sur ton CSS (h1, h2, etc.)
  static TextStyle get h1 => const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 30, // var(--text-3xl) approx
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle get h2 => const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 24, // var(--text-2xl) approx
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle get body => const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18, // var(--font-size) du :root
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
}
