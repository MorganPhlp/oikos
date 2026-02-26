import 'package:flutter/material.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/features/admin/presentation/widget/users_page/user_detail_modal.dart';
import 'package:oikos/features/admin/presentation/widget/users_page/user_status_badge.dart';

/// Carte mobile affichant les informations essentielles d'un utilisateur.
/// Ouvre le détail complet au tap.
class UserMobileCard extends StatelessWidget {
  final Utilisateurs user;
  final String? communityName;

  const UserMobileCard({
    super.key,
    required this.user,
    required this.communityName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return InkWell(
      onTap: () =>
          showUserDetailModal(context, user, communityName),
      borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      child: Container(
        decoration: colors.cardDecoration,
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(user.avatarNetworkUrl),
              backgroundColor: colors.muted,
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.pseudo,
                          style: Theme.of(context).textTheme.labelLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingXs),
                      UserStatusBadge(etatCompte: user.etatCompte),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.mutedForeground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  ...[
                    const SizedBox(height: AppTheme.spacingXs),
                    Row(
                      children: [
                        Icon(
                          Icons.group_rounded,
                          size: 12,
                          color: colors.mutedForeground,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            communityName ?? 'N/A',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colors.mutedForeground),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.mutedForeground),
          ],
        ),
      ),
    );
  }
}
