import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_event.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESKTOP : barre de filtres inline
// ─────────────────────────────────────────────────────────────────────────────

/// Affiche les toggles de type + dropdowns de tri, intégrés dans le header.
class RankingFilterBar extends StatelessWidget {
  final RankingLoaded state;

  const RankingFilterBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Toggle Communautés / Utilisateurs ────────────────────────────
        Row(
          children: [
            _TypeButton(
              label: 'Communautés',
              icon: Icons.group_rounded,
              selected: state.rankingType == RankingType.communities,
              onTap: () => context.read<RankingBloc>().add(
                    RankingTypeChanged(
                        rankingType: RankingType.communities),
                  ),
            ),
            const SizedBox(width: AdminTheme.spacingSm),
            _TypeButton(
              label: 'Utilisateurs',
              icon: Icons.person_rounded,
              selected: state.rankingType == RankingType.users,
              onTap: () => context.read<RankingBloc>().add(
                    RankingTypeChanged(rankingType: RankingType.users),
                  ),
            ),
          ],
        ),

        const SizedBox(height: AdminTheme.spacingMd),

        // ── Dropdowns de tri ─────────────────────────────────────────────
        if (state.rankingType == RankingType.communities)
          _SortDropdown<CommunitySortBy>(
            label: 'Trier par',
            icon: Icons.sort_rounded,
            value: state.communitySortBy,
            items: const [
              DropdownMenuItem(
                value: CommunitySortBy.avgScore,
                child: Text('Score CO₂ moyen'),
              ),
              DropdownMenuItem(
                value: CommunitySortBy.plantXp,
                child: Text('XP Plantes'),
              ),
            ],
            onChanged: (v) {
              if (v == null) return;
              context
                  .read<RankingBloc>()
                  .add(CommunitySortChanged(sortBy: v));
            },
          )
        else
          Row(
            children: [
              Expanded(
                child: _SortDropdown<UserSortBy>(
                  label: 'Trier par',
                  icon: Icons.sort_rounded,
                  value: state.userSortBy,
                  items: const [
                    DropdownMenuItem(
                      value: UserSortBy.impactScoreXp,
                      child: Text('XP Impact'),
                    ),
                    DropdownMenuItem(
                      value: UserSortBy.carbonScore,
                      child: Text('Score CO₂'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    context
                        .read<RankingBloc>()
                        .add(UserSortChanged(sortBy: v));
                  },
                ),
              ),
              const SizedBox(width: AdminTheme.spacingMd),
              Expanded(
                child: _SortDropdown<String>(
                  label: 'Filtrer par communauté',
                  icon: Icons.filter_list_rounded,
                  value: state.selectedCommunityCode ?? 'all',
                  items: [
                    const DropdownMenuItem(
                      value: 'all',
                      child: Text('Toutes les communautés'),
                    ),
                    ...state.data.communities.map(
                      (c) => DropdownMenuItem(
                        value: c.code,
                        child: Text(c.name, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    context.read<RankingBloc>().add(
                          CommunityFilterChanged(
                            communityCode: v == 'all' ? null : v,
                          ),
                        );
                  },
                ),
              ),
            ],
          ),

        const SizedBox(height: AdminTheme.spacingSm),

        // ── Texte résumé ─────────────────────────────────────────────────
        Text(
          _summaryText(state),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  String _summaryText(RankingLoaded s) {
    final sortLabel = s.rankingType == RankingType.communities
        ? _communitySortLabel(s.communitySortBy)
        : _userSortLabel(s.userSortBy);
    final type =
        s.rankingType == RankingType.communities ? 'communautés' : 'utilisateurs';
    return 'Les $type sont classé(e)s par $sortLabel';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MOBILE : résumé des filtres actifs
// ─────────────────────────────────────────────────────────────────────────────

/// Affiche un résumé compact des filtres actifs (version mobile).
class RankingFilterSummary extends StatelessWidget {
  final RankingLoaded state;

  const RankingFilterSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryRow(
          label: 'Type',
          value: state.rankingType == RankingType.communities
              ? 'Communautés'
              : 'Utilisateurs',
          color: AdminTheme.actionGreenLight,
          textColor: AdminTheme.actionGreen,
        ),
        const SizedBox(height: AdminTheme.spacingXs),
        _SummaryRow(
          label: 'Tri',
          value: state.rankingType == RankingType.communities
              ? _communitySortLabel(state.communitySortBy)
              : _userSortLabel(state.userSortBy),
          color: colors.accent,
          textColor: colors.accentForeground,
        ),
        if (state.rankingType == RankingType.users &&
            state.selectedCommunityCode != null) ...[
          const SizedBox(height: AdminTheme.spacingXs),
          _SummaryRow(
            label: 'Communauté',
            value: state.data.communities
                    .where((c) => c.code == state.selectedCommunityCode)
                    .firstOrNull
                    ?.name ??
                state.selectedCommunityCode!,
            color: colors.accent,
            textColor: colors.accentForeground,
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MOBILE : bottom sheet de filtres
// ─────────────────────────────────────────────────────────────────────────────

/// Affiche la feuille de filtres pour mobile.
void showRankingFilterSheet(BuildContext context, RankingLoaded state) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<RankingBloc>(),
      child: _FilterSheet(state: state),
    ),
  );
}

class _FilterSheet extends StatelessWidget {
  final RankingLoaded state;
  const _FilterSheet({required this.state});

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
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            AdminTheme.spacingLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Poignée
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AdminTheme.spacingMd),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(AdminTheme.radiusXxl),
              ),
            ),
          ),

          // Titre + fermeture
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AdminTheme.spacingLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtres et options',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(AdminTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Type ────────────────────────────────────────────────
                Text('Type de classement',
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: AdminTheme.spacingMd),
                Row(
                  children: [
                    _MobileTypeCard(
                      label: 'Communautés',
                      icon: Icons.group_rounded,
                      selected:
                          state.rankingType == RankingType.communities,
                      onTap: () {
                        context.read<RankingBloc>().add(
                              RankingTypeChanged(
                                  rankingType: RankingType.communities),
                            );
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: AdminTheme.spacingMd),
                    _MobileTypeCard(
                      label: 'Utilisateurs',
                      icon: Icons.person_rounded,
                      selected: state.rankingType == RankingType.users,
                      onTap: () {
                        context.read<RankingBloc>().add(
                              RankingTypeChanged(
                                  rankingType: RankingType.users),
                            );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AdminTheme.spacingLg),

                // ── Tri ─────────────────────────────────────────────────
                Text('Trier par',
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: AdminTheme.spacingSm),
                if (state.rankingType == RankingType.communities)
                  _SortDropdown<CommunitySortBy>(
                    value: state.communitySortBy,
                    items: const [
                      DropdownMenuItem(
                        value: CommunitySortBy.avgScore,
                        child: Text('Score CO₂ moyen'),
                      ),
                      DropdownMenuItem(
                        value: CommunitySortBy.plantXp,
                        child: Text('XP Plantes'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      context
                          .read<RankingBloc>()
                          .add(CommunitySortChanged(sortBy: v));
                    },
                  )
                else ...[
                  _SortDropdown<UserSortBy>(
                    value: state.userSortBy,
                    items: const [
                      DropdownMenuItem(
                        value: UserSortBy.impactScoreXp,
                        child: Text('XP Impact'),
                      ),
                      DropdownMenuItem(
                        value: UserSortBy.carbonScore,
                        child: Text('Score CO₂'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      context
                          .read<RankingBloc>()
                          .add(UserSortChanged(sortBy: v));
                    },
                  ),
                  const SizedBox(height: AdminTheme.spacingMd),
                  Text('Filtrer par communauté',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: AdminTheme.spacingSm),
                  _SortDropdown<String>(
                    value: state.selectedCommunityCode ?? 'all',
                    items: [
                      const DropdownMenuItem(
                        value: 'all',
                        child: Text('Toutes les communautés'),
                      ),
                      ...state.data.communities.map(
                        (c) => DropdownMenuItem(
                          value: c.code,
                          child: Text(c.name,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      context.read<RankingBloc>().add(
                            CommunityFilterChanged(
                              communityCode: v == 'all' ? null : v,
                            ),
                          );
                    },
                  ),
                ],

                const SizedBox(height: AdminTheme.spacingLg),

                // ── Bouton appliquer ─────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AdminTheme.actionGreen,
                      padding: const EdgeInsets.symmetric(
                          vertical: AdminTheme.spacingMd),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AdminTheme.radiusMd),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Appliquer les filtres'),
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

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS LOCAUX
// ─────────────────────────────────────────────────────────────────────────────

String _communitySortLabel(CommunitySortBy s) {
  switch (s) {
    case CommunitySortBy.avgScore:
      return 'score CO₂ moyen';
    case CommunitySortBy.plantXp:
      return 'XP plantes';
  }
}

String _userSortLabel(UserSortBy s) {
  switch (s) {
    case UserSortBy.impactScoreXp:
      return 'XP impact';
    case UserSortBy.carbonScore:
      return 'score CO₂';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SOUS-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor:
            selected ? AdminTheme.actionGreen : AdminTheme.actionGreenLight,
        foregroundColor:
            selected ? Colors.white : AdminTheme.actionGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AdminTheme.spacingMd,
          vertical: AdminTheme.spacingSm,
        ),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}

class _MobileTypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _MobileTypeCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AdminTheme.spacingMd),
          decoration: BoxDecoration(
            color: selected
                ? AdminTheme.actionGreenLight
                : AdminColors.of(context).accent,
            borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
            border: Border.all(
              color: selected
                  ? AdminTheme.actionGreen
                  : AdminColors.of(context).border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected
                    ? AdminTheme.actionGreen
                    : AdminColors.of(context).mutedForeground,
                size: 28,
              ),
              const SizedBox(height: AdminTheme.spacingXs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: selected
                          ? AdminTheme.actionGreen
                          : AdminColors.of(context).foreground,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? label;
  final IconData? icon;

  const _SortDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              if (icon != null)
                Icon(icon, size: 14, color: colors.mutedForeground),
              if (icon != null) const SizedBox(width: 4),
              Text(
                label!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.mutedForeground,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AdminTheme.spacingXs),
        ],
        // DropdownButton dans un Container stylisé pour éviter le
        // DropdownButtonFormField.value déprécié (Flutter ≥ 3.33).
        Container(
          decoration: BoxDecoration(
            color: colors.inputBackground,
            borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
            border: Border.all(color: colors.border),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AdminTheme.spacingMd,
          ),
          child: DropdownButton<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
            style: Theme.of(context).textTheme.bodyMedium,
            dropdownColor: colors.card,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color textColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label : ',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: AdminTheme.fontWeightMedium)),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AdminTheme.radiusXxl),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontWeight: AdminTheme.fontWeightMedium,
                ),
          ),
        ),
      ],
    );
  }
}
