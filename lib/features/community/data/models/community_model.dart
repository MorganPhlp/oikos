import 'package:oikos/features/community/domain/entities/community_entity.dart';

class CommunityModel extends CommunityEntity {
  const CommunityModel({
    required super.code,
    required super.nom,
    super.entrepriseId,
    super.description,
    required super.couleurHEX,
    super.plantXp,
    super.totalCarbonSaved,
    super.logoUrl,
    super.membersCount,
  });

  /// Transforme un JSON de Supabase en CommunityModel

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      code: (json['code'] ?? "").toString(),
      nom: (json['nom'] ?? "Communauté sans nom").toString(),
      couleurHEX: (json['couleurHEX'] ?? "#FFFFFF").toString(),

      entrepriseId: json['entreprise_id']?.toString(),
      description: json['description']?.toString(),
      plantXp: (json['plant_xp'] as num?)?.toInt() ?? 0,
      totalCarbonSaved: (json['total_carbon_saved'] as num?)?.toDouble() ?? 0.0,
      logoUrl: json['logo_url']?.toString(),

      membersCount:
          (json['members_count'] ?? json['nb_membres'] as num?)?.toInt() ?? 0,
    );
  }

  /// Transforme le modèle en JSON pour insertion/update dans Supabase
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'nom': nom,
      'entreprise_id': entrepriseId,
      'description': description,
      'couleurHEX': couleurHEX,
      'plant_xp': plantXp,
      'total_carbon_saved': totalCarbonSaved,
      'logo_url': logoUrl,
      'members_count': membersCount,
    };
  }
}
