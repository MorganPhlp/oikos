// Classe représentant un utilisateur dans l'application.
// Définit dans le module core pour être utilisé globalement car plusieurs fonctionnalités peuvent en avoir besoin.

class UserEntity {
  final String id;
  final String email;
  final String pseudo;
  final String communityCode;
  final bool hasCompletedBilan;
  final String? avatar;
  final String? entrepriseId;
  final bool isActive;
  final int impactScoreXp;

  UserEntity({
    required this.id,
    required this.email,
    required this.pseudo,
    required this.communityCode,
    this.hasCompletedBilan = false,
    this.avatar,
    this.entrepriseId,
    this.isActive = true,
    this.impactScoreXp = 0,
  });
}
