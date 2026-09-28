import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/features/notifications/domain/entities/notification_entity.dart';
import 'package:oikos/features/notifications/presentation/widgets/notification_dissmissible_background.dart';
import 'package:oikos/features/notifications/presentation/widgets/streak_notification_icon_container.dart';

class StreakLossNotification extends StatelessWidget {
  final VoidCallback onDismiss;
  final NotificationEntity notification;

  const StreakLossNotification({
    super.key,
    required this.onDismiss,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: const NotificationDismissibleBackground(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 0,
        color: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.outlineVariant, width: 0.5),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: NotificationIconContainer(
            icon: LucideIcons.flame,
            color: colors.error,
            backgroundColor: colors.errorContainer,
          ),
          title: Text(
            notification.data['title'] ?? "Mince, ta streak !",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            notification.data['message'] ?? "Recommence dès aujourd'hui !",
            style: theme.textTheme.bodySmall,
          ),
          trailing: notification.isRead ? null : const UnreadIndicator(),
        ),
      ),
    );
  }
}
