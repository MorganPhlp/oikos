import 'package:oikos/features/notifications/domain/entities/notification_entity.dart';

class NotificationsState {
  final List<NotificationEntity> notifications;
  final bool isLoading;

  NotificationsState({required this.notifications, this.isLoading = false});

  factory NotificationsState.initial() =>
      NotificationsState(notifications: [], isLoading: false);

  NotificationsState copyWith({
    List<NotificationEntity>? notifications,
    bool? isLoading,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
