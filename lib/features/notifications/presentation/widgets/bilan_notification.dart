import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/features/notifications/presentation/widgets/notification_dissmissible_background.dart';
import 'package:oikos/features/notifications/presentation/widgets/streak_notification_icon_container.dart';
import 'package:oikos/features/notifications/domain/entities/notification_entity.dart';

class BilanNotification extends StatelessWidget {
  final VoidCallback onDismiss;
  final NotificationEntity notification;

  const BilanNotification({
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
          leading: NotificationIconContainer(
            icon: LucideIcons.clipboardCheck,
            color: colors.primary,
            backgroundColor: colors.primaryContainer,
          ),
          title: Text(
            notification.data['title'] ?? "Bilan à compléter",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            notification.data['message'] ??
                "Il est temps de mettre à jour ton impact.",
            style: theme.textTheme.bodySmall,
          ),
          trailing: notification.isRead ? null : const UnreadIndicator(),
        ),
      ),
    );
  }
}
