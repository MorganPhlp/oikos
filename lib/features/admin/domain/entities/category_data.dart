import 'package:flutter/material.dart';

/// Données d'une catégorie
class CategoryData {
  final String name;
  final double percentage; // pourcentage
  final double co2; // tonnes
  final Color color;

  const CategoryData({
    required this.name,
    required this.percentage,
    required this.co2,
    required this.color
  });
}
