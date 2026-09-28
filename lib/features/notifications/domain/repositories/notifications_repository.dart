import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRepository {
  Stream<List<NotificationEntity>> getNotificationsForUser(String userId);
  Future<Either<Failure, void>> markAsRead(String notificationId);
}
