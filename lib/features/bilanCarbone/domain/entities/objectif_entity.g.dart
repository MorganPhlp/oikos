// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objectif_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ObjectifEntity _$ObjectifEntityFromJson(Map<String, dynamic> json) =>
    _ObjectifEntity(
      valeur: (json['valeur'] as num).toDouble(),
      label: json['label'] as String,
      description: json['description'] as String,
      colors: (json['colors'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ObjectifEntityToJson(_ObjectifEntity instance) =>
    <String, dynamic>{
      'valeur': instance.valeur,
      'label': instance.label,
      'description': instance.description,
      'colors': instance.colors,
    };
