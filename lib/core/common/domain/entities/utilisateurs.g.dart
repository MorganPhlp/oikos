// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilisateurs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Utilisateurs _$UtilisateursFromJson(Map<String, dynamic> json) =>
    _Utilisateurs(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      pseudo: json['pseudo'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      codeCommunaute: json['code_communaute'] as String? ?? '',
      entrepriseId: json['entreprise_id'] as String? ?? '',
      role:
          $enumDecodeNullable(_$RoleUtilisateurEnumMap, json['role']) ??
          RoleUtilisateur.utilisateur,
      etatCompte:
          $enumDecodeNullable(_$EtatCompteEnumMap, json['etat_compte']) ??
          EtatCompte.actif,
      estCompteValide: json['est_compte_valide'] as bool? ?? true,
      impactScoreXp: (json['impact_score_xp'] as num?)?.toInt() ?? 0,
      aAccepteCgu: json['a_accepte_cgu'] as bool? ?? false,
      hasCompletedBilan: json['a_complete_bilan'] as bool? ?? false,
      objectif: (json['objectif'] as num?)?.toInt() ?? -10,
    );

Map<String, dynamic> _$UtilisateursToJson(_Utilisateurs instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'pseudo': instance.pseudo,
      'avatar_url': instance.avatarUrl,
      'code_communaute': instance.codeCommunaute,
      'entreprise_id': instance.entrepriseId,
      'role': _$RoleUtilisateurEnumMap[instance.role]!,
      'etat_compte': _$EtatCompteEnumMap[instance.etatCompte]!,
      'est_compte_valide': instance.estCompteValide,
      'impact_score_xp': instance.impactScoreXp,
      'a_accepte_cgu': instance.aAccepteCgu,
      'a_complete_bilan': instance.hasCompletedBilan,
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
