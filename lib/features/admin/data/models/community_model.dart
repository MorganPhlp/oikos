import 'package:oikos/features/admin/domain/entities/community.dart';


class CommunityModel extends Community {
  const CommunityModel({
    required super.id,
    required super.name,
    required super.code,
    required super.companyId,
    required super.membersCount,
    super.avgScore

  });

  /// Transforme le JSON de Supabase (ou de ta vue SQL) en CommunityModel
  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      companyId: json['company_id'] as String,
      membersCount: json['members_count'] as int,
      avgScore:(json['avg_score'] as num?)?.toDouble()
    );
  }

  /// Transforme l'objet en Map pour l'envoyer à Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name, 
      'code': code,
      'company_id':companyId,
      'avg_score':avgScore
    };
  }
}

