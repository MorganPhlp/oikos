import 'package:flutter/material.dart';
import '../../domain/entities/action_entity.dart';

class ActionModel extends ActionEntity {
  const ActionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.categoryName,
    required super.difficulty,
    required super.points, // xp_gain
    required super.co2Saved, // gain_co2
    required super.icon,
    required super.tips,
    required super.frequency,
  });

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      id: json['id'],
      title: json['titre'] ?? 'Sans titre',
      description: json['description'] ?? '',

      // 👇 ICI : On récupère le NOM de la catégorie (ex: 'Transport')
      categoryName: json['categorie_nom'] ?? 'Divers',

      difficulty: json['difficulte'] ?? 'Facile',

      // 👇 ICI : Correspondance avec tes colonnes SQL
      points: json['xp_gain'] ?? 0,
      co2Saved: "${json['gain_co2'] ?? 0} kg", // On affiche le float + "kg"

      icon: _getIconByName(json['icon_name']),
      tips: List<String>.from(json['tips'] ?? []),
      frequency: json['frequence']?? 'unique',
    );
  }

  // Petite map pour transformer le texte en Icône Flutter
  static IconData _getIconByName(String? name) {
    switch (name) {
    // Tes nouvelles icônes
      case 'directions_walk': return Icons.directions_walk;
      case 'pedal_bike': return Icons.pedal_bike;
      case 'electric_bike': return Icons.electric_bike;
      case 'videocam': return Icons.videocam;
      case 'water': return Icons.water_drop;
      case 'spa': return Icons.spa;
      case 'sentiment_very_satisfied': return Icons.sentiment_very_satisfied;
      case 'delete_sweep': return Icons.delete_sweep;
      case 'power_settings_new': return Icons.power_settings_new;
      case 'local_bar': return Icons.local_bar;
      case 'shower': return Icons.shower;
      case 'cloud': return Icons.cloud;
      case 'checkroom': return Icons.checkroom;
      case 'wb_sunny': return Icons.wb_sunny;
      case 'router': return Icons.router;
      case 'receipt_long': return Icons.receipt_long;
      case 'shopping_basket': return Icons.shopping_basket;
      case 'savings': return Icons.savings;
      case 'markunread_mailbox': return Icons.markunread_mailbox;
    // Par défaut
      default: return Icons.eco;
    }
  }
}