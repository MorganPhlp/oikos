// Modèle de données pour un défi actif
class ActiveChallengeModel {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final int xpGain; // Nombre d'XP que fait gagner le défi
  final DateTime dateFin; // Fin du défi pour tout le monde
  final int participantsCount; // Nombre de participants
  final bool isJoined; // Indique si l'utilisateur courant a rejoint le défi ou non

  ActiveChallengeModel({
    required this.id, required this.title, required this.description, 
    required this.iconName, required this.xpGain, 
    required this.dateFin, required this.participantsCount,
    required this.isJoined,
  });

  factory ActiveChallengeModel.fromJson(Map<String, dynamic> json) {
    return ActiveChallengeModel(
      id: json['defi_id']?.toString() ?? '',
      title: json['titre'] ?? 'Défi',
      description: json['description'] ?? '',
      iconName: json['icon_name'] ?? 'zap',
      xpGain: (json['xp_gain'] as num?)?.toInt() ?? 0,
      dateFin: json['date_fin'] != null ? DateTime.parse(json['date_fin']) : DateTime.now().add(const Duration(days: 7)),
      participantsCount: (json['participants_count'] as num?)?.toInt() ?? 0,
      isJoined: json['is_joined'] ?? false,
    );
  }
}