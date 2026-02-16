// Entité représentant une entrée du classement (utilisateur ou communauté)
class LeaderboardEntry {
  final String id;          // Identifiant unique (user.id ou communaute.code)
  final String label;       // Nom affiché (pseudo ou nom de la communauté)
  final int value;          // XP
  final int rank;           // Rang dans le classement
  final bool isUser;        // True = utilisateur, false = communauté
  final bool isMe;          // Utilisateur courant ou communauté courante
  final String? avatarUrl;  // URL de l'avatar (si il existe)
  final int membersCount;
  
  // Statistiques additionnelles
  final int actionsCount;     // Nombre d'actions effectuées 
  final int streakDays;       // Nombre de jours de streak consécutifs

  LeaderboardEntry({
    required this.id, 
    required this.label, 
    required this.value, 
    required this.rank, 
    required this.isUser,
    required this.isMe,
    this.avatarUrl,
    required this.actionsCount,
    required this.streakDays,
    this.membersCount = 0,
  });
}