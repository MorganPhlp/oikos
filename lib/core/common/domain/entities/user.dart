enum RoleUtilisateur { utilisateur, administrateur }

enum EtatCompte { actif, anonymise, supprime }

/// Shared immutable profile, independent of Flutter and Supabase.
class UserEntity {
  final String id, email, pseudo, communityCode, entrepriseId;
  final String? avatar;
  final bool hasCompletedBilan, isActive, estCompteValide, aAccepteCgu;
  final int impactScoreXp;
  final RoleUtilisateur role;
  final EtatCompte etatCompte;
  final double objectif;
  const UserEntity({
    required this.id,
    required this.email,
    required this.pseudo,
    required this.communityCode,
    this.entrepriseId = '',
    this.avatar,
    this.hasCompletedBilan = false,
    this.isActive = true,
    this.impactScoreXp = 0,
    this.role = RoleUtilisateur.utilisateur,
    this.etatCompte = EtatCompte.actif,
    this.estCompteValide = true,
    this.aAccepteCgu = false,
    this.objectif = 0.1,
  });
  bool get isAdmin => role == RoleUtilisateur.administrateur;
  bool get canSignIn => etatCompte == EtatCompte.actif && estCompteValide;
  String get codeCommunaute => communityCode;
  String? get avatarUrl => avatar;
  UserEntity copyWith({
    String? email,
    String? pseudo,
    String? codeCommunaute,
    String? entrepriseId,
    String? avatarUrl,
    bool? hasCompletedBilan,
    bool? isActive,
    int? impactScoreXp,
    RoleUtilisateur? role,
    EtatCompte? etatCompte,
    bool? estCompteValide,
    bool? aAccepteCgu,
    double? objectif,
  }) => UserEntity(
    id: id,
    email: email ?? this.email,
    pseudo: pseudo ?? this.pseudo,
    communityCode: codeCommunaute ?? communityCode,
    entrepriseId: entrepriseId ?? this.entrepriseId,
    avatar: avatarUrl ?? avatar,
    hasCompletedBilan: hasCompletedBilan ?? this.hasCompletedBilan,
    isActive: isActive ?? this.isActive,
    impactScoreXp: impactScoreXp ?? this.impactScoreXp,
    role: role ?? this.role,
    etatCompte: etatCompte ?? this.etatCompte,
    estCompteValide: estCompteValide ?? this.estCompteValide,
    aAccepteCgu: aAccepteCgu ?? this.aAccepteCgu,
    objectif: objectif ?? this.objectif,
  );
}
