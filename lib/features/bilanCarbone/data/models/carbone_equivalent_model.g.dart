// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carbone_equivalent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarboneEquivalentModel _$CarboneEquivalentModelFromJson(
  Map<String, dynamic> json,
) => _CarboneEquivalentModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  equivalentLabel: json['equivalent_label'] as String? ?? '',
  valeur1Tonne: (json['valeur_1_tonne'] as num?)?.toDouble() ?? 0.0,
  icone: json['icone'] as String?,
);

Map<String, dynamic> _$CarboneEquivalentModelToJson(
  _CarboneEquivalentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'equivalent_label': instance.equivalentLabel,
  'valeur_1_tonne': instance.valeur1Tonne,
  'icone': instance.icone,
};
