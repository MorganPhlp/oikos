import 'package:flutter/material.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/features/admin/data/models/core/community.dart';

import 'package:oikos/features/admin/presentation/widget/users_page/user_detail_modal.dart';
import 'package:oikos/features/admin/presentation/widget/users_page/user_status_badge.dart';

/// Tableau desktop affichant la liste des utilisateurs avec colonnes triables.
class UsersDesktopTable extends StatelessWidget {
  final List<Utilisateurs> users;
  final List<Community> communities;

  const UsersDesktopTable({
    super.key,
    required this.users,
    required this.communities,
  });

  String? _communityName(String code) =>
      communities.where((c) => c.code == code).firstOrNull?.name;



  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      decoration: colors.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _TableHeader(colors: colors),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (_, _) =>
                Divider(color: colors.border, height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              return _TableRow(
                user: user,
                communityName: _communityName(user.codeCommunaute),
                colors: colors,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EN-TÊTE DU TABLEAU
// ─────────────────────────────────────────────────────────────────────────────

class _TableHeader extends StatelessWidget {
  final AdminColors colors;

  const _TableHeader({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.secondary,
      padding: const EdgeInsets.symmetric(
        horizontal: AdminTheme.spacingMd,
        vertical: AdminTheme.spacingSm,
      ),
      child: Row(
        children: [
          const SizedBox(width: 44), // espace avatar
          Expanded(
            flex: 3,
            child: _HeaderCell(label: 'Utilisateur', colors: colors),
          ),
          Expanded(
            flex: 3,
            child: _HeaderCell(label: 'Email', colors: colors),
          ),
          Expanded(
            flex: 2,
            child: _HeaderCell(label: 'Communauté', colors: colors),
          ),
          SizedBox(
            width: 90,
            child: _HeaderCell(label: 'XP', colors: colors),
          ),
          SizedBox(
            width: 100,
            child: _HeaderCell(label: 'État', colors: colors),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final AdminColors colors;

  const _HeaderCell({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: colors.mutedForeground,
        fontWeight: AdminTheme.fontWeightSemibold,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LIGNE DU TABLEAU
// ─────────────────────────────────────────────────────────────────────────────

class _TableRow extends StatefulWidget {
  final Utilisateurs user;
  final String? communityName;
  final AdminColors colors;

  const _TableRow({
    required this.user,
    required this.communityName,
    required this.colors,
  });

  @override
  State<_TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => showUserDetailModal(
          context,
          widget.user,
          widget.communityName,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: _hovered ? colors.accent : Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AdminTheme.spacingMd,
            vertical: AdminTheme.spacingMd,
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.user.avatarNetworkUrl),
                backgroundColor: colors.muted,
              ),
              const SizedBox(width: AdminTheme.spacingSm),

              // Pseudo
              Expanded(
                flex: 3,
                child: Text(
                  widget.user.pseudo,
                  style: Theme.of(context).textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Email
              Expanded(
                flex: 3,
                child: Text(
                  widget.user.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.mutedForeground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Communauté
              Expanded(
                flex: 2,
                child: Text(
                  widget.communityName ?? 'N/A',
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // XP
              SizedBox(
                width: 90,
                child: Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      size: 14,
                      color: AdminTheme.actionGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.user.impactScoreXp}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              // État
              SizedBox(
                width: 100,
                child: UserStatusBadge(etatCompte: widget.user.etatCompte),
              ),

              // Flèche
              SizedBox(
                width: 40,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
