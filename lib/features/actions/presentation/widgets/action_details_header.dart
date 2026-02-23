import 'package:flutter/material.dart';
import 'package:oikos/features/actions/domain/entities/action_entity.dart';
import 'package:oikos/features/actions/presentation/widgets/action_stats.dart';
import 'package:oikos/features/actions/presentation/widgets/category_chip.dart';

class ActionDetailHeader extends StatelessWidget {
  final ActionEntity action;
  final Color categoryColor;

  const ActionDetailHeader({
    super.key,
    required this.action,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  categoryColor.withValues(alpha: 0.15),
                  categoryColor.withValues(alpha: 0.35),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: categoryColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(action.icon, size: 32, color: categoryColor),
          ),
          const SizedBox(height: 16),
          Text(
            action.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          CategoryChip(
            categoryName: action.categoryName,
            style: CategoryChipStyle.filled,
          ),
          const SizedBox(height: 24),
          OikosActionStats(
            impactScore: action.impactScore,
            difficulty: action.difficulty,
            frequencyLabel: _getFreqLabel(action.frequency),
            primaryColor: categoryColor,
          ),
        ],
      ),
    );
  }

  String _getFreqLabel(String freq) {
    switch (freq.toLowerCase()) {
      case 'journalier':
        return 'Quotidien';
      case 'hebdomadaire':
        return 'Hebdo';
      case 'mensuel':
        return 'Mensuel';
      default:
        return 'Unique';
    }
  }
}
