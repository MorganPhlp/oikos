import 'package:oikos/features/notifications/domain/entities/notification_entity.dart';
import 'package:oikos/features/notifications/domain/repositories/notifications_repository.dart';

class WatchNotificationsUseCase {
  final NotificationsRepository repository;

  WatchNotificationsUseCase({required this.repository});

  Stream<List<NotificationEntity>> call(String userId) {
    return repository.getNotificationsForUser(userId);
  }
}
