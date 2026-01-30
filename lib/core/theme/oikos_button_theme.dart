import 'package:flutter/material.dart';

class OikosButtonTheme extends ThemeExtension<OikosButtonTheme> {
  final LinearGradient? primaryGradient;
  final LinearGradient? tertiaryGradient;
  final Color? shadowColor;
  final Color? disabledColor;

  const OikosButtonTheme({
    required this.primaryGradient,
    required this.tertiaryGradient,
    required this.shadowColor,
    required this.disabledColor,
  });

  @override
  OikosButtonTheme copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? tertiaryGradient,
    Color? shadowColor,
    Color? disabledColor,
  }) {
    return OikosButtonTheme(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      tertiaryGradient: tertiaryGradient ?? this.tertiaryGradient,
      shadowColor: shadowColor ?? this.shadowColor,
      disabledColor: disabledColor ?? this.disabledColor,
    );
  }

  @override
  OikosButtonTheme lerp(ThemeExtension<OikosButtonTheme>? other, double t) {
    if (other is! OikosButtonTheme) return this;
    return OikosButtonTheme(
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t),
      tertiaryGradient: LinearGradient.lerp(tertiaryGradient, other.tertiaryGradient, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t),
    );
  }
}