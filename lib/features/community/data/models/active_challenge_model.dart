class ActiveChallengeModel {
  final String id; // Instance ID
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
      xpGain: (json['xp_gain'] as num?)?.toInt() ?? 0,
      dateFin: json['date_fin'] != null ? DateTime.parse(json['date_fin']) : DateTime.now(),
      participantsCount: (json['participants_count'] as num?)?.toInt() ?? 0,
      isJoined: json['is_joined'] ?? false,
    );
  }
}