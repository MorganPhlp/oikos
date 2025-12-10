import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oikos/core/theme/app_colors.dart';

class AppTypography {
  const AppTypography._();

  // On définit la font globale ici pour pouvoir la changer facilement
  static TextTheme get textTheme {
    return GoogleFonts.outfitTextTheme();
  }

  // Styles spécifiques basés sur ton CSS (h1, h2, etc.)
  static TextStyle get h1 => GoogleFonts.outfit(
    fontSize: 30, // var(--text-3xl) approx
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle get h2 => GoogleFonts.outfit(
    fontSize: 24, // var(--text-2xl) approx
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle get body => GoogleFonts.outfit(
    fontSize: 18, // var(--font-size) du :root
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
}