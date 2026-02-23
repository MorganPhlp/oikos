/// Entité représentant une entrée du classement (utilisateur ou communauté)
class LeaderboardEntry {
  final String id;
  final String label;
  final int value;
  final int rank;
  final bool isUser;
  final bool isMe;
  final String? avatarUrl;
  final int membersCount;
  final int actionsCount;
  final int streakDays;

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