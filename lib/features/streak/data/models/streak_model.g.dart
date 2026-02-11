// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StreakModel _$StreakModelFromJson(Map<String, dynamic> json) => _StreakModel(
  utilisateurId: json['utilisateur_id'] as String,
  currentStreak: (json['effective_streak'] as num).toInt(),
  lastUpdated: DateTime.parse(json['last_updated'] as String),
  saisonNom: json['saison_nom'] as String?,
  saisonDebut: json['saison_debut'] == null
      ? null
      : DateTime.parse(json['saison_debut'] as String),
  saisonFin: json['saison_fin'] == null
      ? null
      : DateTime.parse(json['saison_fin'] as String),
);

Map<String, dynamic> _$StreakModelToJson(_StreakModel instance) =>
    <String, dynamic>{
      'utilisateur_id': instance.utilisateurId,
      'effective_streak': instance.currentStreak,
      'last_updated': instance.lastUpdated.toIso8601String(),
      'saison_nom': instance.saisonNom,
      'saison_debut': instance.saisonDebut?.toIso8601String(),
      'saison_fin': instance.saisonFin?.toIso8601String(),
    };
