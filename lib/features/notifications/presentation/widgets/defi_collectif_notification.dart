import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/features/notifications/domain/entities/notification_entity.dart';
import 'package:oikos/features/notifications/presentation/widgets/notification_dissmissible_background.dart';
import 'package:oikos/features/notifications/presentation/widgets/streak_notification_icon_container.dart';

class CollectiveChallengeNotification extends StatelessWidget {
  final VoidCallback onDismiss;
  final NotificationEntity notification;

  const CollectiveChallengeNotification({
    super.key,
    required this.onDismiss,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // On adapte l'icône selon le sous-type dans les data
    final bool isVote = notification.type == NotificationType.voteDefiCollectif;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: const NotificationDismissibleBackground(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 0,
        color: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: NotificationIconContainer(
            icon: isVote ? LucideIcons.checkSquare : LucideIcons.users,
            color: colors.tertiary,
            backgroundColor: colors.tertiaryContainer,
          ),
          title: Text(
            notification.data['title'] ??
                (isVote ? "Vote disponible" : "Nouveau défi !"),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            notification.data['message'] ?? "Rejoins ton équipe pour agir.",
            style: theme.textTheme.bodySmall,
          ),
          trailing: notification.isRead ? null : const UnreadIndicator(),
        ),
      ),
    );
  }
}
