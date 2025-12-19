// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilisateur_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UtilisateurEntity _$UtilisateurEntityFromJson(Map<String, dynamic> json) =>
    _UtilisateurEntity(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      pseudo: json['pseudo'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      role:
          $enumDecodeNullable(_$RoleUtilisateurEnumMap, json['role']) ??
          RoleUtilisateur.utilisateur,
      etatCompte:
          $enumDecodeNullable(_$EtatCompteEnumMap, json['etat_compte']) ??
          EtatCompte.actif,
      estCompteValide: json['est_compte_valide'] as bool? ?? true,
      impactScoreXp: (json['impact_score_xp'] as num?)?.toInt() ?? 0,
      co2EconomiseTotal:
          (json['co2_economise_total'] as num?)?.toDouble() ?? 0.0,
      aAccepteCgu: json['a_accepte_cgu'] as bool? ?? false,
      communauteNom: json['communaute_nom'] as String? ?? '',
      objectif: (json['objectif'] as num?)?.toInt() ?? -10,
    );

Map<String, dynamic> _$UtilisateurEntityToJson(_UtilisateurEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'pseudo': instance.pseudo,
      'avatar': instance.avatar,
      'role': _$RoleUtilisateurEnumMap[instance.role]!,
      'etat_compte': _$EtatCompteEnumMap[instance.etatCompte]!,
      'est_compte_valide': instance.estCompteValide,
      'impact_score_xp': instance.impactScoreXp,
      'co2_economise_total': instance.co2EconomiseTotal,
      'a_accepte_cgu': instance.aAccepteCgu,
      'communaute_nom': instance.communauteNom,
      'objectif': instance.objectif,
    };

const _$RoleUtilisateurEnumMap = {
  RoleUtilisateur.utilisateur: 'UTILISATEUR',
  RoleUtilisateur.administrateur: 'ADMINISTRATEUR',
};

const _$EtatCompteEnumMap = {
  EtatCompte.actif: 'ACTIF',
  EtatCompte.anonymise: 'ANONYMISE',
  EtatCompte.supprime: 'SUPPRIME',
};
