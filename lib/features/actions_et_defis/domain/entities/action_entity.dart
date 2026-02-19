import 'package:flutter/material.dart';

class ActionEntity {
  final String id;
  final String title;
  final String description;
  final String categoryName;
  final List<String> tags;
  final String difficulty;
  final int impactScore;
  final IconData icon;
  final List<String> tips;
  final String frequency;

  const ActionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryName,
    this.tags = const [],
    required this.difficulty,
    required this.impactScore,
    required this.icon,
    required this.tips,
    required this.frequency,
  });
}
