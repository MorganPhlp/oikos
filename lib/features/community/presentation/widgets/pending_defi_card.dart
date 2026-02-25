import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/presentation/widgets/animated_progress_bar.dart';
import 'package:oikos/features/community/presentation/widgets/vote_button.dart'
    show VoteButton;

class PendingDefiCard extends StatelessWidget {
  final DefiEntity defi;
  final bool hasVoted;
  final bool? voteValue;
  final Function(String defiId, bool isFavorable)? onVote;

  const PendingDefiCard({
    super.key, // Ajout de la clé ici pour le diffing
    required this.defi,
    required this.hasVoted,
    this.onVote,
    this.voteValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionTheme = theme.extension<ActionCardTheme>()!;
    final categoryColor = actionTheme.getCategoryColor(defi.categorieNom);

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(20), // Padding un peu plus généreux
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(28), // Bordures plus arrondies
        border: Border.all(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header : Plus aéré
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DUEL CONTRE",
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.2,
                        color: theme.hintColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      defi.nomCommu2,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Badge de catégorie moderne
              _buildCategoryBadge(defi.categorieNom, categoryColor, theme),
            ],
          ),
          const SizedBox(height: 24),

          // Section Progrès avec icônes indicatives
          _buildProgressSection(
            label: "Votre communauté",
            progress: defi.progress1,
            color: theme.colorScheme.primary,
            icon: Icons.shield_outlined,
          ),
          const SizedBox(height: 16),
          _buildProgressSection(
            label: defi.nomCommu2,
            progress: defi.progress2,
            color: theme.colorScheme.tertiary,
            icon: Icons
                .people_alt_outlined, // Ou Icons.bolt si Swords n'existe pas
          ),

          const Spacer(),

          // Section Boutons (Logique conservée pour l'animation)
          Row(
            children: [
              if (!hasVoted) ...[
                Expanded(
                  child: VoteButton(
                    label: "Refuser",
                    icon: Icons.close_rounded,
                    color: theme.colorScheme.error,
                    onTap: () => onVote?.call(defi.id, false),
                    alreadyVoted: false,
                    voteValue: voteValue,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: VoteButton(
                  label: "Accepter",
                  icon: Icons.check_rounded,
                  color: theme.colorScheme.primary,
                  onTap: () => onVote?.call(defi.id, true),
                  alreadyVoted: hasVoted,
                  voteValue: voteValue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(String label, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: color,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildProgressSection({
    required String label,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color.withValues(alpha: 0.7)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCirc,
              builder: (context, value, _) => Text(
                "${(value * 100).toInt()}%",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        AnimatedProgressBar(progress: progress, color: color),
      ],
    );
  }
}
