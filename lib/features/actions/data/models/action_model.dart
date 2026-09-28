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
    required super.iconName,
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
      iconName: json['icon_name'] as String? ?? 'eco',
      tips: List<String>.from(json['tips'] ?? []),
      frequency: json['frequence'] ?? 'unique',
    );
  }
}
