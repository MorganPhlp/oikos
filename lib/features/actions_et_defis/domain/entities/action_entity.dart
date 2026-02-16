import 'package:flutter/material.dart';

class ActionEntity {
  final String id;
  final String title;
  final String description;
  final String categoryName;
  final String difficulty;
  final int points;
  final String co2Saved;
  final IconData icon;
  final List<String> tips;
  final String frequency;

  const ActionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryName,
    required this.difficulty,
    required this.points,
    required this.co2Saved,
    required this.icon,
    required this.tips,
    required this.frequency
  });
}