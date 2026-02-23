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