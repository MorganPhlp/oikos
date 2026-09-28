import 'package:flutter/material.dart';
import 'package:oikos/core/theme/action_card_theme.dart';

enum CategoryChipStyle { filled, outlined, minimalist }

class CategoryChip extends StatelessWidget {
  final String categoryName;
  final CategoryChipStyle style;
  final bool showDot;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.categoryName,
    this.style = CategoryChipStyle.filled,
    this.showDot = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionTheme = theme.extension<ActionCardTheme>()!;
    final categoryColor = actionTheme.getCategoryColor(categoryName);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _getBgColor(categoryColor),
          borderRadius: BorderRadius.circular(20),
          border: style == CategoryChipStyle.outlined
              ? Border.all(color: categoryColor.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDot)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: categoryColor,
                  shape: BoxShape.circle,
                ),
              ),
            if (showDot) const SizedBox(width: 6),
            Text(
              categoryName,
              style: theme.textTheme.labelSmall?.copyWith(
                color: categoryColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBgColor(Color color) {
    switch (style) {
      case CategoryChipStyle.filled:
        return color.withValues(alpha: 0.12);
      case CategoryChipStyle.outlined:
        return Colors.transparent;
      case CategoryChipStyle.minimalist:
        return Colors.transparent;
    }
  }
}
