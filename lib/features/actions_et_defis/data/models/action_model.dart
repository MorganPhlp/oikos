import 'package:flutter/material.dart';
import '../../domain/entities/action_entity.dart';

class ActionModel extends ActionEntity {
  ActionModel({
    required super.id,
    required super.categoryName,
    required super.title,
    required super.description,
    required super.difficulty,
    required super.points,
    required super.icon,
    required super.tips,
    required super.frequency,
    required super.co2Saved,
    // Valeurs par défaut pour la progression
    super.progress = 0,
    super.isLifestyle = false,
  });

  // Transforme les données JSON de Supabase en un objet ActionModel
  factory ActionModel.fromJson(Map<String, dynamic> json) {

    // Associe un nom d'icône texte à un widget IconData de Flutter
    IconData getIcon(String? iconName) {
      if (iconName == null) return Icons.eco;
      final name = iconName.toLowerCase();
      if (name.contains('monitor') || name.contains('ecran')) return Icons.monitor;
      if (name.contains('food') || name.contains('repas') || name.contains('veg')) return Icons.restaurant;
      if (name.contains('car') || name.contains('voiture')) return Icons.directions_car;
      if (name.contains('water') || name.contains('eau')) return Icons.water_drop;
      if (name.contains('bike') || name.contains('velo')) return Icons.directions_bike;
      if (name.contains('stairs') || name.contains('escalier')) return Icons.stairs;
      if (name.contains('cup') || name.contains('tasse')) return Icons.local_cafe;
      return Icons.eco;
    }

    // Gestion de la liste des conseils (tips)
    List<String> parsedTips = [];
    if (json['tips'] != null) {
      parsedTips = List<String>.from(json['tips']);
    }

    // Création de l'instance avec sécurisation des données (null-safety)
    return ActionModel(
      id: json['id']?.toString() ?? '',
      categoryName: json['categorie_nom'] ?? 'Général',
      title: json['titre'] ?? 'Action sans titre',
      description: json['description'] ?? '',
      difficulty: json['difficulte'] ?? 'Facile',
      points: (json['impact_score'] as num?)?.toInt() ?? 10,
      icon: getIcon(json['icon_name']),
      tips: parsedTips.isNotEmpty ? parsedTips : ["Suis les instructions de l'action."],
      frequency: json['frequence'] ?? 'quotidienne',
      co2Saved: json['co2_economise'] != null ? "-${json['co2_economise']}g CO2" : "-50g CO2",

      // Récupération de l'état d'avancement depuis la table intermédiaire
      progress: (json['progression'] as num?)?.toInt() ?? 0,
      isLifestyle: json['mode_de_vie'] == true,
    );
  }
}