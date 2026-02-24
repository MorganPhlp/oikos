import 'package:flutter/material.dart';

class ActionEntity {
  final String id;
  final String categoryName;
  final String title;
  final String description;
  final String difficulty;
  final int points;
  final IconData icon;
  final List<String> tips;
  final String frequency;
  final String co2Saved;
  final int progress;
  final bool isLifestyle;

  ActionEntity({
    required this.id, required this.categoryName, required this.title, required this.description,
    required this.difficulty, required this.points, required this.icon, required this.tips,
    required this.frequency, required this.co2Saved,
    this.progress = 0, // Par défaut à 0
    this.isLifestyle = false, // Par défaut false
  });
}