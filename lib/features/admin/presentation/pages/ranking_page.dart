import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_event.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_state.dart';
import 'package:oikos/features/admin/presentation/widget/ranking_page/ranking_filter_bar.dart';
import 'package:oikos/features/admin/presentation/widget/ranking_page/ranking_item_card.dart';
import 'package:oikos/features/admin/presentation/widget/ranking_page/ranking_stats_row.dart';

class RankingPage extends StatefulWidget {
  final Utilisateurs user;
  final Company company;

  const RankingPage({super.key, required this.user, required this.company});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  void initState() {
    super.initState();
    context.read<RankingBloc>().add(
      RankingDataFetched(companyId: widget.company.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RankingBloc, RankingState>(
      builder: (context, state) {
        if (state is RankingLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RankingError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AdminTheme.errorForeground,
                  size: 48,
                ),
                const SizedBox(height: AdminTheme.spacingMd),
                Text(
                  state.message,
                  style: const TextStyle(color: AdminTheme.errorForeground),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AdminTheme.spacingMd),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AdminTheme.actionGreen,
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Réessayer'),
                  onPressed: () => context.read<RankingBloc>().add(
                    RankingDataFetched(companyId: widget.company.id),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is RankingLoaded) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = Breakpoints.isMobile(constraints.maxWidth);
              return _RankingContent(state: state, isMobile: isMobile);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTENU PRINCIPAL
// ─────────────────────────────────────────────────────────────────────────────

class _RankingContent extends StatelessWidget {
  final RankingLoaded state;
  final bool isMobile;

  const _RankingContent({required this.state, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AdminTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────────────
          _buildHeader(context),
          const SizedBox(height: AdminTheme.spacingLg),

          // ── KPI cards ─────────────────────────────────────────────────
          RankingStatsRow(state: state, isMobile: isMobile),
          const SizedBox(height: AdminTheme.spacingLg),

          // ── Liste du classement ───────────────────────────────────────
          _buildRankingList(context),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      decoration: colors.cardDecoration,
      padding: const EdgeInsets.all(AdminTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: AdminTheme.actionGreen,
                size: 28,
              ),
              const SizedBox(width: AdminTheme.spacingSm),
              Text(
                'Classements',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              if (isMobile)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AdminTheme.actionGreen,
                    side: const BorderSide(color: AdminTheme.actionGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
                    ),
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 16),
                  label: const Text('Filtres'),
                  onPressed: () => showRankingFilterSheet(context, state),
                ),
            ],
          ),

          const SizedBox(height: AdminTheme.spacingMd),

          // Desktop → filtres inline ; Mobile → résumé compact
          if (!isMobile)
            RankingFilterBar(state: state)
          else
            RankingFilterSummary(state: state),
        ],
      ),
    );
  }

  // ── Liste ────────────────────────────────────────────────────────────────

  Widget _buildRankingList(BuildContext context) {
    if (state.rankingType == RankingType.communities) {
      return _buildCommunityList(context);
    }
    return _buildUserList(context);
  }

  Widget _buildCommunityList(BuildContext context) {
    final communities = state.sortedCommunities;

    if (communities.isEmpty) {
      return _EmptyState(
        icon: Icons.emoji_events_outlined,
        title: 'Aucune communauté à classer',
        subtitle:
            'Les communautés apparaîtront ici une fois créées avec des membres actifs.',
      );
    }

    final sortBy = state.communitySortBy;
    final isLowerBetter = sortBy == CommunitySortBy.avgScore;

    // Valeur max pour la barre de progression
    final values = communities.map((c) {
      return sortBy == CommunitySortBy.avgScore
          ? (c.avgScore ?? 0.0)
          : (c.plantXp ?? 0).toDouble();
    }).toList();
    final maxValue = values.isEmpty
        ? 1.0
        : values.reduce((a, b) => a > b ? a : b);

    return Column(
      children: communities.asMap().entries.map((entry) {
        final rank = entry.key + 1;
        final c = entry.value;
        final rawValue = sortBy == CommunitySortBy.avgScore
            ? (c.avgScore ?? 0.0)
            : (c.plantXp ?? 0).toDouble();
        final metricDisplay = sortBy == CommunitySortBy.avgScore
            ? '${rawValue.toStringAsFixed(1)} kg CO₂'
            : '${c.plantXp ?? 0} XP';

        return Padding(
          padding: const EdgeInsets.only(bottom: AdminTheme.spacingMd),
          child: RankingItemCard(
            rank: rank,
            name: c.name,
            details: [
              RankChip(
                icon: Icons.people_rounded,
                label: '${c.membersCount ?? 0} membre(s)',
              ),
              RankChip(
                icon: Icons.eco_rounded,
                label: '${(c.avgScore ?? 0.0).toStringAsFixed(1)} kg CO₂ moy.',
              ),
              RankChip(
                icon: Icons.local_florist_rounded,
                label: '${c.plantXp ?? 0} XP plantes',
              ),
            ],
            metricLabel: sortBy == CommunitySortBy.avgScore
                ? 'Score CO₂ moyen'
                : 'XP Plantes',
            metricDisplay: metricDisplay,
            progressRatio: RankingBloc.progressPercent(
              value: rawValue,
              maxValue: maxValue,
              isLowerBetter: isLowerBetter,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUserList(BuildContext context) {
    final users = state.sortedUsers;

    if (users.isEmpty) {
      return _EmptyState(
        icon: Icons.people_outline_rounded,
        title: 'Aucun utilisateur à classer',
        subtitle:
            'Les utilisateurs apparaîtront ici une fois inscrits dans une communauté.',
      );
    }

    final sortBy = state.userSortBy;
    final isLowerBetter = sortBy == UserSortBy.carbonScore;

    final values = users.map((u) {
      if (sortBy == UserSortBy.impactScoreXp) {
        return u.impactScoreXp.toDouble();
      }
      final s = RankingBloc.getLatestCarbonScore(
        u.id,
        state.data.carbonFootPrints,
      );
      return s == double.infinity ? 0.0 : s;
    }).toList();
    final maxValue = values.isEmpty
        ? 1.0
        : values.reduce((a, b) => a > b ? a : b);

    return Column(
      children: users.asMap().entries.map((entry) {
        final rank = entry.key + 1;
        final u = entry.value;

        final communityName = state.data.communities
            .where((c) => c.code == u.codeCommunaute)
            .firstOrNull
            ?.name;

        final rawValue = sortBy == UserSortBy.impactScoreXp
            ? u.impactScoreXp.toDouble()
            : () {
                final s = RankingBloc.getLatestCarbonScore(
                  u.id,
                  state.data.carbonFootPrints,
                );
                return s == double.infinity ? 0.0 : s;
              }();

        final metricDisplay = sortBy == UserSortBy.impactScoreXp
            ? '${u.impactScoreXp} XP'
            : '${rawValue.toStringAsFixed(1)} kg CO₂';

        final latestCo2 = RankingBloc.getLatestCarbonScore(
          u.id,
          state.data.carbonFootPrints,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: AdminTheme.spacingMd),
          child: RankingItemCard(
            rank: rank,
            name: u.pseudo,
            avatarUrl: u.avatarUrl != null && u.avatarUrl!.isNotEmpty
                ? u.avatarNetworkUrl
                : null,
            details: [
              if (communityName != null)
                RankChip(icon: Icons.group_rounded, label: communityName),
              RankChip(
                icon: Icons.bolt_rounded,
                label: '${u.impactScoreXp} XP',
              ),
              if (latestCo2 != double.infinity)
                RankChip(
                  icon: Icons.eco_rounded,
                  label: '${latestCo2.toStringAsFixed(1)} kg CO₂',
                ),
            ],
            metricLabel: sortBy == UserSortBy.impactScoreXp
                ? 'XP Impact'
                : 'Score CO₂',
            metricDisplay: metricDisplay,
            progressRatio: RankingBloc.progressPercent(
              value: rawValue,
              maxValue: maxValue,
              isLowerBetter: isLowerBetter,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ÉTAT VIDE
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      decoration: colors.cardDecoration,
      padding: const EdgeInsets.all(AdminTheme.spacingXxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: colors.mutedForeground),
          const SizedBox(height: AdminTheme.spacingMd),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AdminTheme.spacingSm),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.mutedForeground),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
