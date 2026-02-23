// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Community _$CommunityFromJson(Map<String, dynamic> json) => _Community(
  code: json['code'] as String,
  name: json['nom'] as String,
  companyId: json['entreprise_id'] as String,
  description: json['description'] as String,
  membersCount: (json['nombre_membres'] as num?)?.toInt() ?? 0,
  avgScore: (json['bilan_moyen'] as num?)?.toDouble() ?? 0,
  logoUrl: json['logo_url'] as String?,
);

Map<String, dynamic> _$CommunityToJson(_Community instance) =>
    <String, dynamic>{
      'code': instance.code,
      'nom': instance.name,
      'entreprise_id': instance.companyId,
      'description': instance.description,
      'nombre_membres': instance.membersCount,
      'bilan_moyen': instance.avgScore,
      'logo_url': instance.logoUrl,
    };
