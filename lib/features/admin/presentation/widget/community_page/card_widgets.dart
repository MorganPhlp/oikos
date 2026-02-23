import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_state.dart';

// ============================================================================
// CARTES COMMUNAUTÉ
// ============================================================================

/// Carte communauté pour desktop (affichée dans une grille)
class CommunityCard extends StatelessWidget {
  final int index;
  final VoidCallback onEditCode;
  final VoidCallback onViewMembers;
  final VoidCallback onDelete;
  final VoidCallback onEditLogo;

  const CommunityCard({
    super.key,
    required this.index,
    required this.onEditCode,
    required this.onViewMembers,
    required this.onDelete,
    required this.onEditLogo,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    final state = context.watch<CommunityBloc>().state as CommunityLoaded;
    final community = state.data.communities[index];
    final rank = index + 1;

    return Container(
      decoration: colors.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AdminTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header : logo + nom + supprimer
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CommunityLogo(
                  logoUrl: community.logoFullUrl,
                  size: 40,
                  onTap: onEditLogo,
                ),
                const SizedBox(width: AdminTheme.spacingSm),
                Expanded(
                  child: Text(
                    community.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: colors.mutedForeground,
                  ),
                  onPressed: onDelete,
                  tooltip: 'Supprimer',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: AdminTheme.spacingMd),

            // Code d'accès
            _buildInfoRow(
              icon: Icons.vpn_key_rounded,
              child: _CodeBadge(code: community.code),
              colors: colors,
            ),
            const SizedBox(height: AdminTheme.spacingSm),

            // Nombre de membres
            _buildInfoRow(
              icon: Icons.people_rounded,
              child: Text(
                '${community.membersCount ?? 0} membre${(community.membersCount ?? 0) > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.mutedForeground,
                ),
              ),
              colors: colors,
            ),
            const SizedBox(height: AdminTheme.spacingSm),

            // Rang
            _buildInfoRow(
              icon: Icons.emoji_events_rounded,
              iconColor: _getRankColor(rank, colors),
              child: Text(
                'Rang $rank',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _getRankColor(rank, colors),
                ),
              ),
              colors: colors,
            ),
            const SizedBox(height: AdminTheme.spacingSm),

            // Boutons d'action
            _ActionButtons(
              onEditCode: onEditCode,
              onViewMembers: onViewMembers,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Widget child,
    required AdminColors colors,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor ?? colors.mutedForeground,
        ),
        const SizedBox(width: AdminTheme.spacingSm),
        child,
      ],
    );
  }

  Color _getRankColor(int rank, AdminColors colors) {
    switch (rank) {
      case 1:
        return const Color(0xFFD97706); // Ambre (or)
      case 2:
        return const Color(0xFF6B7280); // Gris (argent)
      case 3:
        return const Color(0xFFB45309); // Bronze
      default:
        return colors.mutedForeground;
    }
  }
}

/// Carte communauté compacte pour mobile
class MobileCommunityCard extends StatelessWidget {
  final Community community;
  final int rank;
  final VoidCallback onViewMembers;
  final VoidCallback onEditCode;
  final VoidCallback onDelete;
  final VoidCallback onEditLogo;

  const MobileCommunityCard({
    super.key,
    required this.community,
    required this.rank,
    required this.onViewMembers,
    required this.onEditCode,
    required this.onDelete,
    required this.onEditLogo,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      decoration: colors.cardDecorationCompact,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onViewMembers,
          borderRadius: BorderRadius.circular(AdminTheme.radiusXl),
          child: Padding(
            padding: const EdgeInsets.all(AdminTheme.spacingMd),
            child: Row(
              children: [
                _CommunityLogo(
                  logoUrl: community.logoFullUrl,
                  size: 48,
                  onTap: onEditLogo,
                ),
                const SizedBox(width: AdminTheme.spacingMd),

                // Informations
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.foreground,
                        ),
                      ),
                      const SizedBox(height: AdminTheme.spacingSm),
                      Row(
                        children: [
                          _CodeBadge(code: community.code, small: true),
                          const SizedBox(width: AdminTheme.spacingMd),
                          Icon(
                            Icons.people_rounded,
                            size: 14,
                            color: colors.mutedForeground,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${community.membersCount ?? 0}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AdminTheme.spacingSm),
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events_rounded,
                            size: 14,
                            color: _getRankColor(rank, colors),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Rang $rank',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getRankColor(rank, colors),
                            ),
                          ),
                          const SizedBox(width: AdminTheme.spacingMd),
                          Icon(
                            Icons.eco_rounded,
                            size: 14,
                            color: colors.mutedForeground,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${community.avgScore?.toStringAsFixed(1) ?? '-'} kg',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.mutedForeground,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Boutons d'action
                IconButton(
                  onPressed: onEditCode,
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  color: colors.mutedForeground,
                  tooltip: 'Modifier le code',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  color: colors.mutedForeground,
                  tooltip: 'Supprimer',
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.mutedForeground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank, AdminColors colors) {
    switch (rank) {
      case 1:
        return const Color(0xFFD97706);
      case 2:
        return const Color(0xFF6B7280);
      case 3:
        return const Color(0xFFB45309);
      default:
        return colors.mutedForeground;
    }
  }
}

// ============================================================================
// WIDGET LOGO COMMUNAUTÉ
// ============================================================================

/// Avatar du logo d'une communauté avec icône d'édition superposée
class _CommunityLogo extends StatelessWidget {
  final String logoUrl;
  final double size;
  final VoidCallback onTap;

  const _CommunityLogo({
    required this.logoUrl,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    final editSize = size * 0.38;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Image.network(
              logoUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: colors.pageBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.groups_rounded,
                  size: size * 0.5,
                  color: colors.mutedForeground,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: editSize,
              height: editSize,
              decoration: const BoxDecoration(
                color: AdminTheme.actionGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit_rounded,
                size: editSize * 0.55,
                color: AdminTheme.actionGreenForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge affichant le code d'accès
class _CodeBadge extends StatelessWidget {
  final String code;
  final bool small;

  const _CodeBadge({required this.code, this.small = false});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: colors.pageBackground,
        borderRadius: BorderRadius.circular(
          small ? AdminTheme.radiusSm : AdminTheme.radiusMd,
        ),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontSize: small ? 11 : 13,
          fontFamily: 'monospace',
          color: colors.mutedForeground,
        ),
      ),
    );
  }
}

/// Boutons d'action pour la carte communauté desktop
class _ActionButtons extends StatelessWidget {
  final VoidCallback onEditCode;
  final VoidCallback onViewMembers;

  const _ActionButtons({required this.onEditCode, required this.onViewMembers});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onEditCode,
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text('Modifier le code'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.mutedForeground,
              side: BorderSide(color: colors.border),
              padding: const EdgeInsets.symmetric(
                vertical: AdminTheme.spacingSm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
              ),
            ),
          ),
        ),
        const SizedBox(height: AdminTheme.spacingSm),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onViewMembers,
            icon: const Icon(Icons.visibility_rounded, size: 16),
            label: const Text('Voir les membres'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.actionGreenLight,
              foregroundColor: AdminTheme.actionGreen,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: AdminTheme.spacingSm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// CARTES MEMBRE
// ============================================================================

/// Carte affichant les informations d'un membre
class MemberCard extends StatelessWidget {
  final User user;
  final VoidCallback onChangeCommunity;
  final VoidCallback onRemoveFromCommunity;

  const MemberCard({
    super.key,
    required this.user,
    required this.onChangeCommunity,
    required this.onRemoveFromCommunity,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      padding: const EdgeInsets.all(AdminTheme.spacingMd),
      decoration: BoxDecoration(
        color: colors.pageBackground,
        borderRadius: BorderRadius.circular(AdminTheme.radiusXl),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.pseudo,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _ActionIconButton(
                icon: Icons.swap_horiz_rounded,
                color: Colors.blue,
                onTap: onChangeCommunity,
                tooltip: 'Changer de communauté',
              ),
              const SizedBox(width: AdminTheme.spacingSm),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: colors.mutedForeground,
                ),
                onPressed: onRemoveFromCommunity,
                tooltip: 'Retirer de la communauté',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bouton d'action circulaire avec icône
class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final String? tooltip;

  const _ActionIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AdminTheme.spacingSm),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}

// ============================================================================
// RADIO TILES
// ============================================================================

/// Tuile radio pour sélectionner une communauté
class CommunityRadioTile extends StatelessWidget {
  final Community community;
  final bool isSelected;
  final VoidCallback onTap;

  const CommunityRadioTile({
    super.key,
    required this.community,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AdminTheme.spacingSm),
      child: Material(
        color: isSelected ? AdminTheme.actionGreenLight : colors.pageBackground,
        borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? AdminTheme.actionGreen
                      : colors.mutedForeground,
                ),
                const SizedBox(width: AdminTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AdminTheme.actionGreen
                              : colors.foreground,
                        ),
                      ),
                      Text(
                        community.code,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tuile radio pour sélectionner une entreprise
class CompanyRadioTile extends StatelessWidget {
  final Company company;
  final bool isSelected;
  final VoidCallback onTap;

  const CompanyRadioTile({
    super.key,
    required this.company,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AdminTheme.spacingSm),
      child: Material(
        color: isSelected ? AdminTheme.actionGreenLight : colors.pageBackground,
        borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? AdminTheme.actionGreen
                      : colors.mutedForeground,
                ),
                const SizedBox(width: AdminTheme.spacingMd),
                Expanded(
                  child: Text(
                    company.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AdminTheme.actionGreen
                          : colors.foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
