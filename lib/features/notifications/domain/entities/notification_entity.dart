enum NotificationType {
  voteDefiCollectif('vote_defi_collectif'),
  nouveauDefiCollectif('nouveau_defi_collectif'),
  streakLoss('streak_loss'),
  bilan('bilan'),
  nouvelleActionCommunautaire('nouvelle_action_communautaire');

  final String value;
  const NotificationType(this.value);

  factory NotificationType.fromString(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown notification type: $value'),
    );
  }
}

class NotificationEntity {
  final String id;
  final String userId;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.data,
  });

  static NotificationEntity fromMap(Map<String, dynamic> map) {
    return NotificationEntity(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: NotificationType.fromString(map['type'] as String),
      isRead: map['is_read'] as bool,
      createdAt: DateTime.parse(map['created_at'] as String),
      data: Map<String, dynamic>.from(map['data'] as Map),
    );
  }
}
