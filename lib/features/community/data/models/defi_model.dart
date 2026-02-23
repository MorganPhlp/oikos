/// Modèle symbolisant les défis
/// [id] : identifiant unique
/// [title] : titre du défi
/// [description] : description du défi
/// [category] : catégorie du défi (Transport, Alimentation, Énergie, Toutes)
/// [difficulty] : difficulté du défi (Facile, Moyen, Difficile)
/// [xpGain] : quantité d'XP gagnés en accomplissant ce défi
/// [co2Gain] : quantité de CO2 économisée en accomplissant ce défi
/// [iconName] : nom de l'icône associée
/// [tips] : conseil pour réaliser le défi
/// [frequency] : fréquence de réalisation du défi
class DefiModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final int xpGain;
  final double co2Gain;
  final String iconName;
  final String? tips;
  final String? frequency;

  DefiModel({
    required this.id, required this.title, required this.description,
    required this.category, required this.difficulty, required this.xpGain,
    required this.co2Gain, required this.iconName, this.tips, this.frequency,
  });

  factory DefiModel.fromJson(Map<String, dynamic> json) {
    return DefiModel(
      id: json['id']?.toString() ?? '',
      title: json['titre'] ?? '',
      description: json['description'] ?? '',
      category: json['categorie_nom'] ?? 'Général',
      difficulty: json['difficulte'] ?? 'Moyen',
      xpGain: (json['xp_gain'] as num?)?.toInt() ?? 0,
      co2Gain: (json['gain_co2'] as num?)?.toDouble() ?? 0.0,
      iconName: json['icon_name'] ?? 'swords',
      tips: json['tips'],
      frequency: json['frequence'],
    );
  }
}