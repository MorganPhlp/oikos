import 'package:oikos/core/common/domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.pseudo,
    required super.communityCode,
    super.entrepriseId,
    super.avatar,
    super.hasCompletedBilan,
    super.isActive,
    super.impactScoreXp,
    super.role,
    super.etatCompte,
    super.estCompteValide,
    super.aAccepteCgu,
    super.objectif,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String? ?? '',
    pseudo: json['pseudo'] as String? ?? '',
    communityCode: json['code_communaute'] as String? ?? '',
    entrepriseId: json['entreprise_id'] as String? ?? '',
    avatar: json['avatar_url'] as String?,
    hasCompletedBilan: json['a_complete_bilan'] as bool? ?? false,
    isActive: json['est_actif'] as bool? ?? true,
    impactScoreXp: (json['impact_score_xp'] as num?)?.toInt() ?? 0,
    role: json['role'] == 'ADMINISTRATEUR'
        ? RoleUtilisateur.administrateur
        : RoleUtilisateur.utilisateur,
    etatCompte: switch (json['etat_compte']) {
      'ANONYMISE' => EtatCompte.anonymise,
      'SUPPRIME' => EtatCompte.supprime,
      _ => EtatCompte.actif,
    },
    estCompteValide: json['est_compte_valide'] as bool? ?? true,
    aAccepteCgu: json['a_accepte_cgu'] as bool? ?? false,
    objectif: (json['objectif'] as num?)?.toDouble() ?? 0.1,
  );
}
