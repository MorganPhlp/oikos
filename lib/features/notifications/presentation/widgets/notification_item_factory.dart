import 'package:flutter/material.dart';
import 'package:oikos/features/notifications/domain/entities/notification_entity.dart';
import 'package:oikos/features/notifications/presentation/widgets/bilan_notification.dart';
import 'package:oikos/features/notifications/presentation/widgets/defi_collectif_notification.dart';
import 'package:oikos/features/notifications/presentation/widgets/streak_loss_notification.dart';

class NotificationItemFactory extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onDismiss;

  const NotificationItemFactory({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    switch (notification.type) {
      case NotificationType.streakLoss:
        return StreakLossNotification(
          notification: notification,
          onDismiss: onDismiss,
        );
      case NotificationType.bilan:
        return BilanNotification(
          notification: notification,
          onDismiss: onDismiss,
        );
      case NotificationType.voteDefiCollectif:
      case NotificationType.nouveauDefiCollectif:
        return CollectiveChallengeNotification(
          notification: notification,
          onDismiss: onDismiss,
        );
      case NotificationType.nouvelleActionCommunautaire:
        return BilanNotification(
          notification: notification,
          onDismiss: onDismiss,
        );
    }
  }
}
