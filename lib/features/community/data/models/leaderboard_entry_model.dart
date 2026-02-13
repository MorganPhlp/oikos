import '../../domain/entities/leaderboard_entry.dart';

// Modèle de données pour une entrée du classement
class LeaderboardEntryModel extends LeaderboardEntry {

  LeaderboardEntryModel({
    required super.id,
    required super.label,
    required super.value,
    required super.rank,
    required super.isUser,
    required super.isMe,
    super.avatarUrl,
    required super.actionsCount,
    required super.streakDays,
    super.membersCount = 0,
  });

  // Factory pour les utilisateurs 
  factory LeaderboardEntryModel.fromUserView(Map<String, dynamic> json, String currentUserId) {
    return LeaderboardEntryModel(
      id: json['id']?.toString() ?? '',
      label: (json['username'] ?? json['pseudo'] ?? 'Anonyme') as String, 
      value: (json['total_xp'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      isUser: true,
      isMe: json['id'] == currentUserId,
      avatarUrl: json['avatar_url'] as String?,
      actionsCount: (json['actions_count'] as num?)?.toInt() ?? 0,
      streakDays: (json['streak_days'] as num?)?.toInt() ?? 0,
      membersCount: (json['members_count'] as num?)?.toInt() ?? 0, // Pas de membres pour un utilisateur
    );
  }

  // Factory pour les communautés
  factory LeaderboardEntryModel.fromCommunityView(Map<String, dynamic> json, String myCommunityCode) {
    return LeaderboardEntryModel(
      id: json['community_code']?.toString() ?? 'CODE_MANQUANT',
      label: (json['community_name'] as String?) ?? 'Communauté inconnue',
      value: (json['total_xp'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      isUser: false,
      isMe: json['community_code'] == myCommunityCode,
      actionsCount: (json['total_actions'] as num?)?.toInt() ?? 0,
      membersCount: (json['members_count'] as num?)?.toInt() ?? 0,
      streakDays: 0,
    );
  }

  // Méthode permettant de créer une copie d'une entrée du classement avec des modifications
  LeaderboardEntryModel copyWith({
    String? id,
    String? label,
    int? value,
    int? rank,
    bool? isUser,
    bool? isMe,
    String? avatarUrl,
    String? impactStats,
    int? actionsCount,
    int? streakDays,
    int? membersCount,
  }) {
    return LeaderboardEntryModel(
      id: id ?? this.id,
      label: label ?? this.label,
      value: value ?? this.value,
      rank: rank ?? this.rank,
      isUser: isUser ?? this.isUser,
      isMe: isMe ?? this.isMe,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      actionsCount: actionsCount ?? this.actionsCount,
      streakDays: streakDays ?? this.streakDays,
      membersCount: membersCount ?? this.membersCount,
    );
  }
}
