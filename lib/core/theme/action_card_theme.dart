import 'package:flutter/material.dart';

class ActionCardTheme extends ThemeExtension<ActionCardTheme> {
  final Color transport;
  final Color alimentation;
  final Color energie;
  final Color eau;
  final Color dechet;
  final Color numerique;
  final Color logement;
  final Color biodiversite;
  final Color textile;
  final Color defaultColor;

  const ActionCardTheme({
    required this.transport,
    required this.alimentation,
    required this.energie,
    required this.eau,
    required this.dechet,
    required this.numerique,
    required this.logement,
    required this.biodiversite,
    required this.textile,
    required this.defaultColor,
  });

  @override
  ActionCardTheme copyWith({
    Color? transport,
    Color? alimentation,
    Color? energie,
    Color? eau,
    Color? dechet,
    Color? numerique,
    Color? logement,
    Color? biodiversite,
    Color? textile,
    Color? defaultColor,
  }) {
    return ActionCardTheme(
      transport: transport ?? this.transport,
      alimentation: alimentation ?? this.alimentation,
      energie: energie ?? this.energie,
      eau: eau ?? this.eau,
      dechet: dechet ?? this.dechet,
      numerique: numerique ?? this.numerique,
      logement: logement ?? this.logement,
      biodiversite: biodiversite ?? this.biodiversite,
      textile: textile ?? this.textile,
      defaultColor: defaultColor ?? this.defaultColor,
    );
  }

  @override
  ActionCardTheme lerp(ThemeExtension<ActionCardTheme>? other, double t) {
    if (other is! ActionCardTheme) return this;
    return ActionCardTheme(
      transport: Color.lerp(transport, other.transport, t)!,
      alimentation: Color.lerp(alimentation, other.alimentation, t)!,
      energie: Color.lerp(energie, other.energie, t)!,
      eau: Color.lerp(eau, other.eau, t)!,
      dechet: Color.lerp(dechet, other.dechet, t)!,
      numerique: Color.lerp(numerique, other.numerique, t)!,
      logement: Color.lerp(logement, other.logement, t)!,
      biodiversite: Color.lerp(biodiversite, other.biodiversite, t)!,
      textile: Color.lerp(textile, other.textile, t)!,
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
    );
  }

  /// Helper pour récupérer la couleur selon le nom de la catégorie
  Color getCategoryColor(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('transport')) return transport;
    if (lower.contains('alimentation')) return alimentation;
    if (lower.contains('énergie') || lower.contains('energie')) return energie;
    if (lower.contains('eau')) return eau;
    if (lower.contains('déchet') || lower.contains('dechet')) return dechet;
    if (lower.contains('numérique') || lower.contains('numerique')) {
      return numerique;
    }
    if (lower.contains('logement')) return logement;
    if (lower.contains('biodiversité') || lower.contains('biodiversite')) {
      return biodiversite;
    }
    if (lower.contains('textile') || lower.contains('mode')) return textile;
    return defaultColor;
  }
}
