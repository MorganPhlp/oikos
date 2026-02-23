import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/widgets/separator.dart';
import 'package:oikos/core/theme/action_card_theme.dart';

class ActionCardToPromote extends StatelessWidget {
  final dynamic action;
  const ActionCardToPromote({required this.action});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final actionTheme = theme.extension<ActionCardTheme>()!;
    final categoryColor = actionTheme.getCategoryColor(action.categoryName);

    return IntrinsicHeight(
      child: Container(
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
      ),
    );
  }

  Widget _buildImageHeader(Color categoryColor, ColorScheme colorScheme) {
    return Container(
      height: 125,
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
                action.icon,
                size: 130,
                color: colorScheme.onPrimary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Center(
            child: Icon(action.icon, color: colorScheme.onPrimary, size: 55),
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
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 50),
      child: Column(
        children: [
          _buildBadge(theme, categoryColor),
          const SizedBox(height: 16),
          Text(
            action.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            action.description,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 25),
          _buildStats(colorScheme),
          const SizedBox(height: 25),
          const DecorativeSeparator(),
          const SizedBox(height: 12),
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
        action.categoryName.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: categoryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStats(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _stat(
          LucideIcons.zap,
          "${action.impactScore} pts",
          colorScheme.primary,
        ),
        _stat(LucideIcons.gauge, action.difficulty, colorScheme.secondary),
        _stat(LucideIcons.calendar, action.frequency, colorScheme.tertiary),
      ],
    );
  }

  Widget _stat(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.sparkles, size: 14, color: colorScheme.primary),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              "Swipe à droite pour m'adopter !",
              style: theme.textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
