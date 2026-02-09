class LeaderboardEntry {
  final String id;          // Identifiant unique (user.id ou communaute.code)
  final String label;       // Nom affiché (pseudo ou nom de la communauté)
  final int value;          // XP
  final int rank;           // Rang dans le classement
  final bool isUser;        // True = utilisateur, false = communauté
  final bool isMe;          // Utilisateur courant ou communauté courante
  final String? avatarUrl;  // URL de l'avatar (optionnel)
  
  // Statistiques additionnelles
  final String impactStats;   // Amélioration actuelle de l'empreinte carbone (ex: "-89kg CO2")
  final int actionsCount;     // Nombre d'actions effectuées (ex: 45 actions)
  final int streakDays;       // Nombre de jours de streak consécutifs (ex: 12 jours)

  LeaderboardEntry({
    required this.id, 
    required this.label, 
    required this.value, 
    required this.rank, 
    required this.isUser,
    required this.isMe,
    this.avatarUrl,
    // TODO: ajouter les connexions pour les données suivantes
    this.impactStats = "-0kg",
    this.actionsCount = 0,
    this.streakDays = 0,
  });
}