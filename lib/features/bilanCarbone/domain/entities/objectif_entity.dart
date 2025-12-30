import 'dart:ui';

class ObjectifEntity {
  final double valeur;
  final String label;
  final String description;
  final List<int> colors;

  const ObjectifEntity({
    required this.valeur,
    required this.label,
    required this.description,
    required this.colors,
  });
}

extension ObjectifColors on ObjectifEntity {
  List<Color> get gradientColors => colors.map((c) => Color(c)).toList();
}
