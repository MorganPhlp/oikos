import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/widgets/separator.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/actions/domain/entities/user_active_action_entity.dart';
import 'package:oikos/features/actions/presentation/widgets/action_stats.dart';

class ActionCardToPromote extends StatelessWidget {
  final UserActiveActionEntity action;
  const ActionCardToPromote({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final actionTheme = theme.extension<ActionCardTheme>()!;
    final categoryColor = actionTheme.getCategoryColor(
      action.action.categoryName,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageHeader(categoryColor, colorScheme),
            _buildContent(theme, colorScheme, categoryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(Color categoryColor, ColorScheme colorScheme) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [categoryColor, categoryColor.withValues(alpha: 0.7)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Transform.rotate(
              angle: 0.2,
              child: Icon(
                action.action.icon,
                size: 110,
                color: colorScheme.onPrimary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Center(
            child: Icon(
              action.action.icon,
              color: colorScheme.onPrimary,
              size: 45, // Réduit de 55 à 45
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    ColorScheme colorScheme,
    Color categoryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBadge(theme, categoryColor),
          const SizedBox(height: 12),
          Text(
            action.action.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action.action.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _buildStats(colorScheme),
          const SizedBox(height: 16),
          const DecorativeSeparator(),
          const SizedBox(height: 10),
          _buildFooter(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildBadge(ThemeData theme, Color categoryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        action.action.categoryName.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: categoryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStats(ColorScheme colorScheme) {
    return OikosActionStats(
      impactScore: action.action.impactScore,
      difficulty: action.action.difficulty,
      frequencyLabel: action.action.frequency,
      primaryColor: colorScheme.primary,
    );
  }

  Widget _buildFooter(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.sparkles, size: 14, color: colorScheme.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              "Swipe à droite pour m'adopter !",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
