class CommunityActionModel {
  final String id;
  final String title;
  final String subtitle;
  final int xpGain;
  final String iconKey;

  CommunityActionModel({
<<<<<<< HEAD
    required super.id,
    required super.title,
    required super.subtitle,
    required super.xpGain,
    required super.iconKey,
=======
    required this.id,
    required this.title,
    required this.subtitle,
    required this.xpGain,
    required this.iconKey,
>>>>>>> origin/master
  });

  factory CommunityActionModel.fromJson(Map<String, dynamic> json) {
    return CommunityActionModel(
<<<<<<< HEAD
      id: json['id']?.toString() ?? '0',
      title: json['titre'] as String? ?? 'Action inconnue',
      subtitle: json['description'] as String? ?? '',
      xpGain: (json['impact_score'] as num?)?.toInt() ?? 0,
      iconKey: json['icon_name'] as String? ?? 'zap',
=======
      id: json['id']?.toString() ?? '',
      title: json['titre'] ?? '',
      subtitle: json['description'] ?? '',
      xpGain: (json['xp_gain'] as num?)?.toInt() ?? 0,
      iconKey: json['icon_name'] ?? 'bolt',
>>>>>>> origin/master
    );
  }
}
