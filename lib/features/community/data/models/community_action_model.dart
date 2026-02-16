import '../../domain/entities/community_action.dart';

// Modèle de données pour une action communautaire
class CommunityActionModel extends CommunityAction {
  CommunityActionModel({
    required super.id, required super.title, required super.subtitle, required super.xpGain, required super.iconKey
  });

  factory CommunityActionModel.fromJson(Map<String, dynamic> json) {
    return CommunityActionModel(
      id: json['id']?.toString() ?? '0',
      title: json['titre'] as String? ?? 'Action inconnue',
      subtitle: json['description'] as String? ?? '',
      xpGain: (json['xp_gain'] as num?)?.toInt() ?? 0,
      iconKey: json['icon_name'] as String? ?? 'zap',
    );
  }
}