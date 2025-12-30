// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reponse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReponseUtilisateurModel _$ReponseUtilisateurModelFromJson(
  Map<String, dynamic> json,
) => _ReponseUtilisateurModel(
  id: (json['id'] as num?)?.toInt(),
  bilanId: (json['bilan_id'] as num?)?.toInt() ?? 0,
  questionId: (json['question_id'] as num?)?.toInt() ?? 0,
  valeur: json['valeur'],
);

Map<String, dynamic> _$ReponseUtilisateurModelToJson(
  _ReponseUtilisateurModel instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'bilan_id': instance.bilanId,
  'question_id': instance.questionId,
  'valeur': instance.valeur,
};
