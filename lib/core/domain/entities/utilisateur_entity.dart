import 'package:freezed_annotation/freezed_annotation.dart';

part 'utilisateur_entity.freezed.dart';
part 'utilisateur_entity.g.dart';

enum RoleUtilisateur {
  @JsonValue('UTILISATEUR')
  utilisateur,
  @JsonValue('ADMINISTRATEUR')
  administrateur,
}

enum EtatCompte {
  @JsonValue('ACTIF')
  actif,
  @JsonValue('ANONYMISE')
  anonymise,
  @JsonValue('SUPPRIME')
  supprime,
}

@freezed
sealed class UtilisateurEntity with _$UtilisateurEntity {
  const factory UtilisateurEntity({
    @Default('') String id,
    @Default('') String email,
    @Default('') String pseudo,
    @Default('') String avatar,
    
    @Default(RoleUtilisateur.utilisateur) 
    RoleUtilisateur role,
    
    @JsonKey(name: 'etat_compte') // Matcher le snake_case SQL
    @Default(EtatCompte.actif) 
    EtatCompte etatCompte,

    @JsonKey(name: 'est_compte_valide') // Correction : camelCase ici, snake_case en DB
    @Default(true) bool estCompteValide,

    @JsonKey(name: 'impact_score_xp')
    @Default(0) int impactScoreXp,

    @JsonKey(name: 'co2_economise_total')
    @Default(0.0) double co2EconomiseTotal,

    @JsonKey(name: 'a_accepte_cgu') // Matcher le snake_case SQL
    @Default(false) bool aAccepteCgu,

    @JsonKey(name: 'communaute_nom')
    @Default('') String communauteNom,

    // Ce champ n'existe pas dans ta table SQL 'utilisateur'. 
    // S'il vient d'une jointure ou d'un calcul, garde-le, sinon il sera ignoré par Supabase.
    @Default(-10) int objectif, 
  }) = _UtilisateurEntity;

  factory UtilisateurEntity.fromJson(Map<String, dynamic> json) =>
      _$UtilisateurEntityFromJson(json);
}