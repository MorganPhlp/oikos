import '../../domain/entities/community_action.dart';

// Modèle de données pour une action communautaire
class CommunityActionModel extends CommunityAction {
  CommunityActionModel({
    required super.id, required super.title, required super.subtitle, required super.xpGain, required super.iconKey
  });

  factory CommunityActionModel.fromJson(Map<String, dynamic> json) {
    return CommunityActionModel(
      id: json['id']?.toString() ?? '0', // Si pas d'id, on met '0'
      title: (json['title'] as String?) ?? 'Action inconnue', // Si pas de titre, on met 'Action inconnue'
      subtitle: (json['subtitle'] as String?) ?? '', // Si pas de sous-titre, on met une chaîne vide
      xpGain: (json['xp_gain'] as num?)?.toInt() ?? 0, // Si pas de gain XP, on met 0
      iconKey: (json['icon_key'] as String?) ?? 'zap', // Si pas de clé d'icône, on met 'zap'
    );
  }
}