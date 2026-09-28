// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Company _$CompanyFromJson(Map<String, dynamic> json) => _Company(
  id: json['id'] as String,
  name: json['nom'] as String,
  logoUrl: json['logo_url'] as String?,
  domainEmail: json['domaine_email'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$CompanyToJson(_Company instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.name,
  'logo_url': instance.logoUrl,
  'domaine_email': instance.domainEmail,
  'description': instance.description,
};
