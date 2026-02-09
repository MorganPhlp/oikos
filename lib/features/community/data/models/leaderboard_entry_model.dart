import 'dart:math';
import '../../domain/entities/leaderboard_entry.dart';

// Modèle de données pour une entrée du classement
class LeaderboardEntryModel extends LeaderboardEntry {
  LeaderboardEntryModel({
    required super.id, required super.label, required super.value, required super.rank, required super.isUser, required super.isMe, super.avatarUrl, super.impactStats, super.actionsCount, super.streakDays
  });

  factory LeaderboardEntryModel.fromUserView(Map<String, dynamic> json, String currentUserId) {
    // TODO : remplacer les données mock par des vraies données issues de l'API
    final random = Random();
    return LeaderboardEntryModel(
      id: json['id']?.toString() ?? '',
      label: (json['username'] as String?) ?? 'Anonyme',
      value: (json['total_xp'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      isUser: true,
      isMe: json['id'] == currentUserId,
      impactStats: "-${random.nextInt(100) + 10}kg", // Mock
      actionsCount: random.nextInt(50) + 5,           // Mock
      streakDays: random.nextInt(20),                 // Mock
    );
  }

  factory LeaderboardEntryModel.fromCommunityView(Map<String, dynamic> json, String myCommunityCode) {
    final int xp = (json['plant_xp'] as num?)?.toInt() ?? 0;
    return LeaderboardEntryModel(
      id: json['community_code']?.toString() ?? 'CODE_MANQUANT',
      label: (json['community_name'] as String?) ?? 'Communauté inconnue',
      value: xp,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      isUser: false,
      isMe: json['community_code'] == myCommunityCode,
      impactStats: "Niveau ${xp ~/ 1000 + 1}", // Calcul fictif du niveau
      actionsCount: xp ~/ 50, // Estimation nb actions
    );
  }
}