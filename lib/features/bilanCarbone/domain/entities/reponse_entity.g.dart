// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reponse_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReponseUtilisateurEntity _$ReponseUtilisateurEntityFromJson(
  Map<String, dynamic> json,
) => _ReponseUtilisateurEntity(
  id: (json['id'] as num?)?.toInt() ?? 0,
  bilanId: (json['bilan_id'] as num?)?.toInt() ?? 0,
  questionId: (json['question_id'] as num?)?.toInt() ?? 0,
  valeur: json['valeur'] ?? null,
);

Map<String, dynamic> _$ReponseUtilisateurEntityToJson(
  _ReponseUtilisateurEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'bilan_id': instance.bilanId,
  'question_id': instance.questionId,
  'valeur': instance.valeur,
};
