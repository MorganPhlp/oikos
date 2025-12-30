// Classe représentant un utilisateur dans l'application.
// Définit dans le module core pour être utilisé globalement car plusieurs fonctionnalités peuvent en avoir besoin.

class User {
  final String id;
  final String email;
  final String pseudo;
  final String communityCode;

  User({
    required this.id,
    required this.email,
    required this.pseudo,
    required this.communityCode,
  });
}