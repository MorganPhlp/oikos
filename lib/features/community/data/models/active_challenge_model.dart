/// Modèle symbolisant les défis actifs
/// [id] : identifiant unique
/// [baseActionId] : identifiant unique de l'action associée
/// [title] : titre du défi
/// [description] : description du défi
/// [iconName] : nom de l'icône associée
/// [xpGain] : nombre d'XP gagnés en accomplissant ce défi
/// [dateFin] : date de fin du défi
/// [participantsCount] : nombre de participants au défi
/// [isJoined] : si le défi  a été rejoint par l'utilisateur connecté
class ActiveChallengeModel {
  final String id;
  final String baseActionId;
  final String title;
  final String description;
  final String iconName;
  final int xpGain;
  final DateTime dateFin;
  final int participantsCount;
  final bool isJoined;

  ActiveChallengeModel({
    required this.id, required this.baseActionId, required this.title, 
    required this.description, required this.iconName, required this.xpGain, 
    required this.dateFin, required this.participantsCount, required this.isJoined,
  });

  factory ActiveChallengeModel.fromJson(Map<String, dynamic> json) {
    return ActiveChallengeModel(
      id: json['action_id']?.toString() ?? '',
      baseActionId: json['base_action_id']?.toString() ?? '',
      title: json['titre'] ?? 'Action',
      description: json['description'] ?? '',
      iconName: json['icon_name'] ?? 'zap',
      xpGain: (json['impact_score'] as num?)?.toInt() ?? 0,
      dateFin: json['date_fin'] != null ? DateTime.parse(json['date_fin']) : DateTime.now(),
      participantsCount: (json['participants_count'] as num?)?.toInt() ?? 0,
      isJoined: json['is_joined'] ?? false,
    );
  }
}