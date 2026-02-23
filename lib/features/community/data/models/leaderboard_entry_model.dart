import '../../domain/entities/leaderboard_entry.dart';

/// Modèle sumbolisant une entrée du classement
/// [id] : identifiant unique
/// [label] : nom affiché
/// [value] : total des points (XP)
/// [rank] : rang dans le classement
/// [isUser] : utilisateur ou communauté
/// [isMe] : utilisateur courant ou non
/// [avatarUrl] : photo de profil associée
/// [actionsCount] : nombre total d'actions effectuées
/// [streakDays] : nombre de jours de streak
/// [membersCount] : nombre de membres actifs de la communauté si !isUser
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

  /// Classement des utilisateurs
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
    );
  }

  /// Classement des communautés
  factory LeaderboardEntryModel.fromCommunityView(Map<String, dynamic> json, String myCommunityCode) {
    return LeaderboardEntryModel(
      id: json['community_code']?.toString() ?? '',
      label: (json['community_name'] as String?) ?? 'Communauté',
      value: (json['total_xp'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      isUser: false,
      isMe: json['community_code'] == myCommunityCode,
      avatarUrl: json['logo_url'],
      actionsCount: (json['total_actions'] as num?)?.toInt() ?? 0,
      membersCount: (json['members_count'] as num?)?.toInt() ?? 0,
      streakDays: 0,
    );
  }

  LeaderboardEntryModel copyWith({
    String? id, String? label, int? value, int? rank, bool? isUser, bool? isMe,
    String? avatarUrl, int? actionsCount, int? streakDays, int? membersCount,
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