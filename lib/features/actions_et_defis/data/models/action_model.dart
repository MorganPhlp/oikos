import 'package:flutter/material.dart';

import '../../domain/entities/action_entity.dart';

class ActionModel extends ActionEntity {
  const ActionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.categoryName,
    super.tags,
    required super.difficulty,
    required super.impactScore,
    required super.icon,
    required super.tips,
    required super.frequency,
  });

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      id: json['id'],
      title: json['titre'] ?? 'Sans titre',
      description: json['description'] ?? '',
      categoryName: json['categorie_nom'] ?? 'Divers',
      tags: List<String>.from(json['tags'] ?? []),
      difficulty: json['difficulte'] ?? 'Facile',
      impactScore: json['impact_score'] ?? 0,
      icon: _getIconByName(json['icon_name']),
      tips: List<String>.from(json['tips'] ?? []),
      frequency: json['frequence'] ?? 'unique',
    );
  }

  static IconData _getIconByName(String? name) {
    const iconMap = <String, IconData>{
      'directions_walk': Icons.directions_walk,
      'pedal_bike': Icons.pedal_bike,
      'electric_bike': Icons.electric_bike,
      'videocam': Icons.videocam,
      'water': Icons.water_drop,
      'spa': Icons.spa,
      'sentiment_very_satisfied': Icons.sentiment_very_satisfied,
      'delete_sweep': Icons.delete_sweep,
      'power_settings_new': Icons.power_settings_new,
      'local_bar': Icons.local_bar,
      'shower': Icons.shower,
      'cloud': Icons.cloud,
      'checkroom': Icons.checkroom,
      'wb_sunny': Icons.wb_sunny,
      'router': Icons.router,
      'receipt_long': Icons.receipt_long,
      'shopping_basket': Icons.shopping_basket,
      'savings': Icons.savings,
      'markunread_mailbox': Icons.markunread_mailbox,
    };
    return iconMap[name] ?? Icons.eco;
  }
}
