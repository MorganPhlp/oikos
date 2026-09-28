/// Modèle symbolisant les actions communautaires
/// [id] : identifiant unique
/// [title] : titre de l'action communautaire
/// [subtitle] : sous-titre de l'action communautaire
/// [xpGain] : nombre d'XP gagnés en accomplissant cette action communautaire
/// [iconKey] : nom de l'icône associée
class CommunityActionModel {
  final String id;
  final String title;
  final String subtitle;
  final int xpGain;
  final String iconKey;

  CommunityActionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.xpGain,
    required this.iconKey,
  });

  factory CommunityActionModel.fromJson(Map<String, dynamic> json) {
    return CommunityActionModel(
      id: json['id']?.toString() ?? '',
      title: json['titre'] ?? '',
      subtitle: json['description'] ?? '',
      xpGain: (json['impact_score'] as num?)?.toInt() ?? 0,
      iconKey: json['icon_name'] ?? 'bolt',
    );
  }
}
