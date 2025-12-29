// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carbone_equivalent_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarboneEquivalentEntity _$CarboneEquivalentEntityFromJson(
  Map<String, dynamic> json,
) => _CarboneEquivalentEntity(
  id: (json['id'] as num?)?.toInt() ?? 0,
  equivalentLabel: json['equivalent_label'] as String? ?? '',
  valeur1Tonne: (json['valeur_1_tonne'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$CarboneEquivalentEntityToJson(
  _CarboneEquivalentEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'equivalent_label': instance.equivalentLabel,
  'valeur_1_tonne': instance.valeur1Tonne,
};
