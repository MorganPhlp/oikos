// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorie_empreinte_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategorieEmpreinteEntity _$CategorieEmpreinteEntityFromJson(
  Map<String, dynamic> json,
) => _CategorieEmpreinteEntity(
  nom: json['nom'] as String? ?? '',
  icone: json['icone'] as String? ?? '',
  couleurHEX: json['couleurHEX'] as String? ?? '',
  description: json['description'] as String? ?? '',
);

Map<String, dynamic> _$CategorieEmpreinteEntityToJson(
  _CategorieEmpreinteEntity instance,
) => <String, dynamic>{
  'nom': instance.nom,
  'icone': instance.icone,
  'couleurHEX': instance.couleurHEX,
  'description': instance.description,
};
