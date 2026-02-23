import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/notifications/data/datasources/notifications_datasource.dart';
import 'package:oikos/features/notifications/domain/entities/notification_entity.dart';
import 'package:oikos/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl extends NotificationsRepository {
  final NotificationsDatasource datasource;

  NotificationsRepositoryImpl({required this.datasource});

  @override
  Stream<List<NotificationEntity>> getNotificationsForUser(String userId) {
    return datasource
        .getNotificationsForUser(userId)
        .map(
          (list) => list
              .map((map) => NotificationEntity.fromMap(map))
              .filter((notif) => notif.isRead == false)
              .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await datasource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
