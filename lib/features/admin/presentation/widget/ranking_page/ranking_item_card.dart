import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DONNÉES DU CHIP
// ─────────────────────────────────────────────────────────────────────────────

class RankChip {
  final IconData icon;
  final String label;
  const RankChip({required this.icon, required this.label});
}

// ─────────────────────────────────────────────────────────────────────────────
// STYLE PAR RANG
// ─────────────────────────────────────────────────────────────────────────────

class _RankStyle {
  final Color? bgColor;
  final Color? borderColor;
  final Color badgeColor;
  final Color badgeTextColor;

  const _RankStyle({
    this.bgColor,
    this.borderColor,
    required this.badgeColor,
    required this.badgeTextColor,
  });
}

_RankStyle _rankStyle(int rank) {
  switch (rank) {
    case 1:
      return const _RankStyle(
        bgColor: Color(0xFFFEFCE8),
        borderColor: Color(0xFFFDE047),
        badgeColor: Color(0xFFFEF08A),
        badgeTextColor: Color(0xFF713F12),
      );
    case 2:
      return const _RankStyle(
        bgColor: Color(0xFFF9FAFB),
        borderColor: Color(0xFFD1D5DB),
        badgeColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF1F2937),
      );
    case 3:
      return const _RankStyle(
        bgColor: Color(0xFFFFFBEB),
        borderColor: Color(0xFFFCD34D),
        badgeColor: Color(0xFFFDE68A),
        badgeTextColor: Color(0xFF92400E),
      );
    default:
      return const _RankStyle(
        badgeColor: Color(0xFFDCFCE7),
        badgeTextColor: Color(0xFF166534),
      );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARTE D'ÉLÉMENT DU CLASSEMENT
// ─────────────────────────────────────────────────────────────────────────────

/// Carte d'un élément du classement (communauté ou utilisateur).
class RankingItemCard extends StatelessWidget {
  final int rank;
  final String name;
  final String? avatarUrl;

  /// Puces d'informations secondaires affichées sous le nom
  final List<RankChip> details;

  /// Libellé du critère de tri affiché au-dessus de la barre
  final String metricLabel;

  /// Valeur formatée affichée à droite de la barre
  final String metricDisplay;

  /// Ratio de remplissage de la barre [0.0 – 1.0]
  final double progressRatio;

  const RankingItemCard({
    super.key,
    required this.rank,
    required this.name,
    this.avatarUrl,
    required this.details,
    required this.metricLabel,
    required this.metricDisplay,
    required this.progressRatio,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    final style = _rankStyle(rank);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: style.bgColor ?? colors.card,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: style.borderColor ?? colors.border,
          width: rank <= 3 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Icône de rang ────────────────────────────────────────────────
          SizedBox(width: 44, child: _RankIcon(rank: rank)),
          const SizedBox(width: AppTheme.spacingMd),

          // ── Contenu ──────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom + badge Top N
                Row(
                  children: [
                    if (avatarUrl != null) ...[
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(avatarUrl!),
                        backgroundColor: colors.muted,
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                    ],
                    Expanded(
                      child: Text(
                        name,
                        style: rank <= 3
                            ? Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.black,
                              )
                            : Theme.of(context).textTheme.labelLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (rank <= 3)
                      Container(
                        margin: const EdgeInsets.only(left: AppTheme.spacingSm),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: style.badgeColor,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusXxl,
                          ),
                        ),
                        child: Text(
                          'Top $rank',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: style.badgeTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppTheme.spacingSm),

                // Puces de détails
                Wrap(
                  spacing: AppTheme.spacingMd,
                  runSpacing: AppTheme.spacingXs,
                  children: details.map((d) => _ChipWidget(chip: d,rank: rank,)).toList(),
                ),

                const SizedBox(height: AppTheme.spacingMd),

                // Barre de progression
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          metricLabel,
                          style: rank <= 3
                              ? Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.black,
                                )
                              : Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          metricDisplay,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppTheme.actionGreen,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusXxl),
                      child: LinearProgressIndicator(
                        value: progressRatio,
                        minHeight: 8,
                        backgroundColor: Colors.grey.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _barColor(rank),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _barColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFF16A34A);
      case 2:
        return const Color(0xFF22C55E);
      case 3:
        return const Color(0xFF4ADE80);
      default:
        return const Color(0xFF86EFAC);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ICÔNE DE RANG
// ─────────────────────────────────────────────────────────────────────────────

class _RankIcon extends StatelessWidget {
  final int rank;
  const _RankIcon({required this.rank});

  @override
  Widget build(BuildContext context) {
    switch (rank) {
      case 1:
        return const Icon(
          Icons.emoji_events_rounded,
          color: Color(0xFFEAB308),
          size: 36,
        );
      case 2:
        return const Icon(
          Icons.military_tech_rounded,
          color: Color(0xFF9CA3AF),
          size: 36,
        );
      case 3:
        return const Icon(
          Icons.workspace_premium_rounded,
          color: Color(0xFFB45309),
          size: 36,
        );
      default:
        return Center(
          child: Text(
            '$rank',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.mutedForeground,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGET DE PUCE
// ─────────────────────────────────────────────────────────────────────────────

class _ChipWidget extends StatelessWidget {
  final RankChip chip;
  final int rank;
  const _ChipWidget({required this.chip, required this.rank });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          chip.icon,
          size: 14,
          color: AdminColors.of(context).mutedForeground,
        ),
        const SizedBox(width: 3),
        Text(chip.label, style: rank <= 3
            ? Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black,
              )
            : Theme.of(context).textTheme.bodySmall)
      ],
    );
  }
}
