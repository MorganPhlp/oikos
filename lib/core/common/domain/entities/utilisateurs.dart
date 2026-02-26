import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oikos/core/utils/utils.dart';

part 'utilisateurs.freezed.dart';
part 'utilisateurs.g.dart';

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
sealed class Utilisateurs with _$Utilisateurs {
  const factory Utilisateurs({
    @Default('') String id,
    @Default('') String email,
    @Default('') String pseudo,
    @JsonKey(name: 'avatar_url') @Default('') String? avatarUrl,
    @JsonKey(name: 'code_communaute') @Default('') String codeCommunaute,
    @JsonKey(name: 'entreprise_id') @Default('') String entrepriseId,

    @Default(RoleUtilisateur.utilisateur) RoleUtilisateur role,

    @JsonKey(name: 'etat_compte') // Matcher le snake_case SQL
    @Default(EtatCompte.actif)
    EtatCompte etatCompte,

    @JsonKey(
      name: 'est_compte_valide',
    ) // Correction : camelCase ici, snake_case en DB
    @Default(true)
    bool estCompteValide,

    @JsonKey(name: 'impact_score_xp') @Default(0) int impactScoreXp,


    @JsonKey(name: 'a_accepte_cgu') // Matcher le snake_case SQL
    @Default(false)
    bool aAccepteCgu,

    @JsonKey(name: 'a_complete_bilan') @Default(false) bool hasCompletedBilan,

    // Ce champ n'existe pas dans ta table SQL 'utilisateur'.
    // S'il vient d'une jointure ou d'un calcul, garde-le, sinon il sera ignoré par Supabase.
    @Default(-10) int objectif,
  }) = _Utilisateurs;

  factory Utilisateurs.fromJson(Map<String, dynamic> json) =>
      _$UtilisateursFromJson(json);
}

extension UtilisateursX on Utilisateurs {
  bool get isAdmin => role == RoleUtilisateur.administrateur;

  String get avatarNetworkUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      // Génère un avatar avec les initiales si pas d'image
      return "https://ui-avatars.com/api/?name=$pseudo&background=random";
    }
    return StorageUtils.getNetworkUrl('avatars', avatarUrl!);
  }

  String get avatarLocalUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      // Génère un avatar avec les initiales si pas d'image
      return "https://ui-avatars.com/api/?name=$pseudo&background=random";
    }
    return StorageUtils.getLocalUrl('avatars', avatarUrl!);
  }
}
