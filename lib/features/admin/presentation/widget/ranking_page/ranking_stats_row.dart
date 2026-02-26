import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_state.dart';

/// Ligne de 3 cartes KPI en haut de la page de classement.
class RankingStatsRow extends StatelessWidget {
  final RankingLoaded state;
  final bool isMobile;

  const RankingStatsRow({
    super.key,
    required this.state,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final cards = state.rankingType == RankingType.communities
        ? _communityCards(context)
        : _userCards(context);

    if (isMobile) {
      return Column(
        children: cards
            .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                  child: c,
                ))
            .toList(),
      );
    }

    return Row(
      children: cards
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingXs,
                  ),
                  child: c,
                ),
              ))
          .toList(),
    );
  }

  // ── Communautés ────────────────────────────────────────────────────────────

  List<Widget> _communityCards(BuildContext context) {
    final communities = state.sortedCommunities;
    final totalMembers = state.data.users.length;
    final avgScore = communities.isEmpty
        ? 0.0
        : communities.fold<double>(0, (s, c) => s + (c.avgScore ?? 0)) /
            communities.length;

    return [
      _StatCard(
        icon: Icons.people_rounded,
        iconColor: const Color(0xFF2563EB),
        label: 'Membres actifs',
        value: '$totalMembers',
        context: context,
      ),
      _StatCard(
        icon: Icons.group_work_rounded,
        iconColor: AppTheme.actionGreen,
        label: 'Communautés',
        value: '${communities.length}',
        context: context,
      ),
      _StatCard(
        icon: Icons.trending_down_rounded,
        iconColor: const Color(0xFF7C3AED),
        label: 'Score CO₂ moyen',
        value: '${avgScore.toStringAsFixed(1)} kg',
        context: context,
      ),
    ];
  }

  // ── Utilisateurs ───────────────────────────────────────────────────────────

  List<Widget> _userCards(BuildContext context) {
    final users = state.sortedUsers;
    final totalXp = users.fold<int>(0, (s, u) => s + u.impactScoreXp);
    final validScores = users
        .map((u) => RankingBloc.getLatestCarbonScore(
              u.id,
              state.data.carbonFootPrints,
            ))
        .where((s) => s != double.infinity)
        .toList();
    final avgCo2 = validScores.isEmpty
        ? 0.0
        : validScores.fold<double>(0, (s, v) => s + v) / validScores.length;

    return [
      _StatCard(
        icon: Icons.people_rounded,
        iconColor: const Color(0xFF2563EB),
        label: 'Utilisateurs',
        value: '${users.length}',
        context: context,
      ),
      _StatCard(
        icon: Icons.bolt_rounded,
        iconColor: AppTheme.actionGreen,
        label: 'XP total',
        value: '$totalXp XP',
        context: context,
      ),
      _StatCard(
        icon: Icons.eco_rounded,
        iconColor: const Color(0xFF7C3AED),
        label: 'Score CO₂ moyen',
        value: '${avgCo2.toStringAsFixed(1)} kg',
        context: context,
      ),
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARTE KPI INDIVIDUELLE
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final BuildContext context;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    final colors = AdminColors.of(ctx);
    return Container(
      decoration: colors.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(ctx).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  value,
                  style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                        color: iconColor,
                        fontWeight: FontWeight.w700,
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
