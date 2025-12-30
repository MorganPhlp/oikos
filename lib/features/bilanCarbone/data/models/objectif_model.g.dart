// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objectif_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ObjectifModel _$ObjectifModelFromJson(Map<String, dynamic> json) =>
    _ObjectifModel(
      valeur: (json['valeur'] as num).toDouble(),
      label: json['label'] as String,
      description: json['description'] as String,
      colors: (json['colors'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ObjectifModelToJson(_ObjectifModel instance) =>
    <String, dynamic>{
      'valeur': instance.valeur,
      'label': instance.label,
      'description': instance.description,
      'colors': instance.colors,
    };
