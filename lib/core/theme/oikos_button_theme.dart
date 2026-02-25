import 'package:flutter/material.dart';

class OikosButtonTheme extends ThemeExtension<OikosButtonTheme> {
  final LinearGradient? primaryGradient;
  final Color? secondaryGradient;
  final LinearGradient? tertiaryGradient;
  final Color? shadowColor;
  final Color? tertiaryShadowColor;
  final Color? disabledColor;

  const OikosButtonTheme({
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.tertiaryGradient,
    required this.shadowColor,
    required this.tertiaryShadowColor,
    required this.disabledColor,
  });

  @override
  OikosButtonTheme copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? tertiaryGradient,
    Color? secondaryGradient,
    Color? shadowColor,
    Color? tertiaryShadowColor,
    Color? disabledColor,
  }) {
    return OikosButtonTheme(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      tertiaryGradient: tertiaryGradient ?? this.tertiaryGradient,
      shadowColor: shadowColor ?? this.shadowColor,
      tertiaryShadowColor: tertiaryShadowColor ?? this.tertiaryShadowColor,
      disabledColor: disabledColor ?? this.disabledColor,
      secondaryGradient: this.secondaryGradient,
    );
  }

  @override
  OikosButtonTheme lerp(ThemeExtension<OikosButtonTheme>? other, double t) {
    if (other is! OikosButtonTheme) return this;
    return OikosButtonTheme(
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t),
      tertiaryGradient: LinearGradient.lerp(tertiaryGradient, other.tertiaryGradient, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      tertiaryShadowColor: Color.lerp(tertiaryShadowColor, other.tertiaryShadowColor, t),
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t),
      secondaryGradient: Color.lerp(secondaryGradient, other.secondaryGradient, t),
    );
  }
}
