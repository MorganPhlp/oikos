import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_state.dart';
// ============================================================================
// CARTES COMMUNAUTÉ
// ============================================================================

/// Carte communauté pour desktop (affichée dans une grille)
///
/// Affiche toutes les informations de la communauté avec des boutons d'action.
class CommunityCard extends StatelessWidget {
  final int index;
  final VoidCallback onEditCode;
  final VoidCallback onViewMembers;
  final VoidCallback onDelete;

  const CommunityCard({
    super.key,
    required this.index,
    required this.onEditCode,
    required this.onViewMembers,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CommunityBloc>().state as CommunityLoaded;
    final community = state.data.communities[index];
    final rank = index + 1;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec nom et bouton supprimer
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    community.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, size: 20, color: Colors.grey[600]),
                  onPressed: onDelete,
                  tooltip: 'Supprimer',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Code d'accès
            _buildInfoRow(
              icon: Icons.vpn_key,
              child: _CodeBadge(code: community.code),
            ),
            const SizedBox(height: 8),

            // Nombre de membres
            _buildInfoRow(
              icon: Icons.people,
              child: Text(
                '${community.membersCount ?? 0} membre${(community.membersCount ?? 0) > 1 ? 's' : ''}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 8),

            // Rang
            _buildInfoRow(
              icon: Icons.emoji_events,
              iconColor: _getRankColor(rank),
              child: Text(
                'Rang $rank',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _getRankColor(rank),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Score CO2
            _buildInfoRow(
              icon: Icons.eco,
              child: Text(
                'Score ${community.avgScore?.toStringAsFixed(2) ?? '-'} kg CO2e',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),

            const Spacer(),

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
    Color? iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor ?? Colors.grey[500]),
        const SizedBox(width: 8),
        child,
      ],
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Or
      case 2:
        return const Color(0xFFA0A0A0); // Argent
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey[600]!;
    }
  }
}

/// Carte communauté compacte pour mobile (affichée dans une liste)
///
/// Version simplifiée avec navigation au tap.
class MobileCommunityCard extends StatelessWidget {
  final Community community;
  final int rank;
  final VoidCallback onViewMembers;
  final VoidCallback onEditCode;
  final VoidCallback onDelete;

  const MobileCommunityCard({
    super.key,
    required this.community,
    required this.rank,
    required this.onViewMembers,
    required this.onEditCode,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onViewMembers,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Informations principales
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Code et membres
                      Row(
                        children: [
                          _CodeBadge(code: community.code, small: true),
                          const SizedBox(width: 12),
                          Icon(Icons.people, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            '${community.membersCount ?? 0}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Rang et Score
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            size: 14,
                            color: _getRankColor(rank),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Rang $rank',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getRankColor(rank),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.eco, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            'Score ${community.avgScore?.toStringAsFixed(2) ?? '-'} kg CO2e',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
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
                  icon: const Icon(Icons.edit, size: 20),
                  color: Colors.grey[600],
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete, size: 20, color: Colors.grey[600]),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Or
      case 2:
        return const Color(0xFFA0A0A0); // Argent
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey[600]!;
    }
  }
}

/// Badge affichant le code d'accès
class _CodeBadge extends StatelessWidget {
  final String code;
  final bool small;

  const _CodeBadge({required this.code, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(small ? 4 : 6),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontSize: small ? 11 : 13,
          fontFamily: 'monospace',
          color: Colors.grey[700],
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
    return Column(
      children: [
        // Modifier le code
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onEditCode,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Modifier le code'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Voir les membres
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onViewMembers,
            icon: const Icon(Icons.visibility, size: 16),
            label: const Text('Voir les membres'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDCFCE7),
              foregroundColor: const Color(0xFF16A34A),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne supérieure : nom, email, actions
          Row(
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
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Boutons d'action
              Row(
                children: [
                  _ActionIconButton(
                    icon: Icons.swap_horiz,
                    color: Colors.blue,
                    onTap: onChangeCommunity,
                    tooltip: 'Changer de communauté',
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.delete, size: 18, color: Colors.grey[600]),
                    onPressed: onRemoveFromCommunity,
                    tooltip: 'Retirer de la communauté',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  // _ActionIconButton(
                  //   icon: Icons.delete,
                  //   color: Colors.red,
                  //   onTap: null,
                  //   tooltip: 'Supprimer',
                  // ),
                ],
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
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
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
// RADIO TILE POUR SÉLECTION DE COMMUNAUTÉ
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected ? const Color(0xFFDCFCE7) : Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Icône radio
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? const Color(0xFF16A34A)
                      : Colors.grey[400],
                ),
                const SizedBox(width: 12),

                // Informations
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF16A34A)
                              : Colors.grey[900],
                        ),
                      ),
                      Text(
                        community.code,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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

// ============================================================================
// RADIO TILE POUR SÉLECTION D'ENTREPRISE
// ============================================================================

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected ? const Color(0xFFDCFCE7) : Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Icône radio
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? const Color(0xFF16A34A)
                      : Colors.grey[400],
                ),
                const SizedBox(width: 12),

                // Informations
                Expanded(
                  child: Text(
                    company.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF16A34A)
                          : Colors.grey[900],
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
