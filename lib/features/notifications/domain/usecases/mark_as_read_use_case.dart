import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/notifications/domain/repositories/notifications_repository.dart';

class MarkAsReadUseCase {
  final NotificationsRepository repository;

  MarkAsReadUseCase({required this.repository});

  Future<Either<Failure, void>> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}
