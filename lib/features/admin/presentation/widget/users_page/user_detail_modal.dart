import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/features/admin/presentation/bloc/users_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/users_event.dart';
import 'package:oikos/features/admin/presentation/widget/users_page/user_status_badge.dart';

/// Affiche les détails complets d'un utilisateur dans un bottom sheet.
void showUserDetailModal(
  BuildContext context,
  Utilisateurs user,
  String? communityName,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<UsersBloc>(),
      child: _UserDetailSheet(
        user: user,
        communityName: communityName,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SHEET PRINCIPALE
// ─────────────────────────────────────────────────────────────────────────────

class _UserDetailSheet extends StatelessWidget {
  final Utilisateurs user;
  final String? communityName;

  const _UserDetailSheet({
    required this.user,
    required this.communityName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AdminTheme.radiusXxl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Poignée de glissement
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AdminTheme.spacingMd),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AdminTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, colors),
                  const SizedBox(height: AdminTheme.spacingLg),
                  _buildInfoSection(context, colors),
                  const SizedBox(height: AdminTheme.spacingLg),
                  _buildStatsSection(context, colors),
                  if (user.etatCompte == EtatCompte.actif && !user.isAdmin) ...[
                    const SizedBox(height: AdminTheme.spacingLg),
                    _buildAnonymizeButton(context),
                  ],
                  const SizedBox(height: AdminTheme.spacingMd),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── En-tête ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, AdminColors colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(user.avatarNetworkUrl),
          backgroundColor: colors.muted,
        ),
        const SizedBox(width: AdminTheme.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.pseudo,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AdminTheme.spacingXs),
              Text(
                user.email,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colors.mutedForeground),
              ),
            ],
          ),
        ),
        UserStatusBadge(etatCompte: user.etatCompte),
      ],
    );
  }

  // ── Informations ──────────────────────────────────────────────────────────

  Widget _buildInfoSection(BuildContext context, AdminColors colors) {
    final community = communityName ?? 'N/A';

    return Container(
      decoration: colors.cardDecoration,
      padding: const EdgeInsets.all(AdminTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informations', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AdminTheme.spacingMd),
          _InfoRow(
            icon: Icons.group_rounded,
            label: 'Communauté',
            value: community,
            colors: colors,
          ),
          _InfoRow(
            icon: Icons.verified_user_rounded,
            label: 'Rôle',
            value: user.isAdmin ? 'Administrateur' : 'Utilisateur',
            colors: colors,
          ),
          _InfoRow(
            icon: Icons.how_to_reg_rounded,
            label: 'CGU acceptées',
            value: user.aAccepteCgu ? 'Oui' : 'Non',
            colors: colors,
          ),
          _InfoRow(
            icon: Icons.assignment_turned_in_rounded,
            label: 'Bilan complété',
            value: user.hasCompletedBilan ? 'Oui' : 'Non',
            colors: colors,
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ── Statistiques ──────────────────────────────────────────────────────────

  Widget _buildStatsSection(BuildContext context, AdminColors colors) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.bolt_rounded,
            label: 'XP Impact',
            value: '${user.impactScoreXp}',
            unit: 'XP',
            colors: colors,
          ),
        ),
        const SizedBox(width: AdminTheme.spacingMd),
        Expanded(
          child: _StatCard(
            icon: Icons.eco_rounded,
            label: 'CO₂ économisé',
            value: user.co2EconomiseTotal.toStringAsFixed(1),
            unit: 'kg',
            colors: colors,
          ),
        ),
      ],
    );
  }

  // ── Bouton d'anonymisation ────────────────────────────────────────────────

  Widget _buildAnonymizeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AdminTheme.errorForeground,
          side: const BorderSide(color: AdminTheme.errorForeground),
          padding: const EdgeInsets.symmetric(vertical: AdminTheme.spacingMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
          ),
        ),
        icon: const Icon(Icons.person_remove_rounded, size: 18),
        label: const Text('Anonymiser cet utilisateur'),
        onPressed: () => _confirmAnonymize(context),
      ),
    );
  }

  void _confirmAnonymize(BuildContext context) {
    final colors = AdminColors.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminTheme.radiusXl),
        ),
        title: const Text('Anonymiser l\'utilisateur'),
        content: Text(
          'Êtes-vous sûr de vouloir anonymiser "${user.pseudo}" ?\n\n'
          'Cette action est irréversible. Les données personnelles de l\'utilisateur seront effacées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AdminTheme.errorForeground,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
              context.read<UsersBloc>().add(
                UsersAnonymizeRequested(user: user),
              );
            },
            child: const Text('Anonymiser'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPOSANTS INTERNES
// ─────────────────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final AdminColors colors;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AdminTheme.spacingSm),
          child: Row(
            children: [
              Icon(icon, size: 18, color: colors.mutedForeground),
              const SizedBox(width: AdminTheme.spacingSm),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colors.mutedForeground),
              ),
              const Spacer(),
              Text(value, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
        if (!isLast) Divider(color: colors.border, height: 1),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final AdminColors colors;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: colors.cardDecoration,
      padding: const EdgeInsets.all(AdminTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AdminTheme.actionGreen),
          const SizedBox(height: AdminTheme.spacingSm),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: AdminTheme.spacingXs),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: AdminTheme.fontWeightSemibold,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
