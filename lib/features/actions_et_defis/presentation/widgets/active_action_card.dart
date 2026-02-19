import 'package:flutter/material.dart';

import '../../domain/entities/action_entity.dart';

class ActiveActionCard extends StatelessWidget {
  final ActionEntity action;
  final String frequency;
  final bool isCompleted;
  final int streakCount;
  final VoidCallback onValidate;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const ActiveActionCard({
    super.key,
    required this.action,
    required this.frequency,
    required this.isCompleted,
    this.streakCount = 0,
    required this.onValidate,
    required this.onDelete,
    this.onTap,
  });

  int get _targetForFrequency {
    switch (frequency.toLowerCase()) {
      case 'quotidienne':
        return 7;
      case 'hebdomadaire':
        return 4;
      case 'mensuelle':
        return 3;
      default:
        return 1;
    }
  }

  String get _waitLabel {
    switch (frequency.toLowerCase()) {
      case 'quotidienne':
        return 'Reviens demain !';
      case 'hebdomadaire':
        return 'Reviens la semaine prochaine !';
      case 'mensuelle':
        return 'Reviens le mois prochain !';
      default:
        return 'D\u00e9j\u00e0 valid\u00e9e !';
    }
  }

  String _getFreqLabel(String freq) {
    switch (freq) {
      case 'journalier':
        return 'Quotidien';
      case 'hebdomadaire':
        return 'Hebdo';
      case 'mensuel':
        return 'Mensuel';
      case 'unique':
        return 'Bonus';
      default:
        return freq;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mainColor = isCompleted
        ? colorScheme.onSurface.withValues(alpha: 0.4)
        : colorScheme.primary;
    final bgColor = isCompleted
        ? colorScheme.onSurface.withValues(alpha: 0.03)
        : colorScheme.surface;

    return Dismissible(
      key: Key('active_action_${action.id}'),
      background: _buildSwipeBackground(
        context,
        alignment: Alignment.centerLeft,
        color: colorScheme.primary,
        icon: Icons.check_circle_outline,
        label: 'Valider',
      ),
      secondaryBackground: _buildSwipeBackground(
        context,
        alignment: Alignment.centerRight,
        color: colorScheme.error,
        icon: Icons.delete_outline,
        label: 'Supprimer',
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (!isCompleted) onValidate();
          return false;
        } else {
          onDelete();
          return false;
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (!isCompleted)
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
            border: isCompleted
                ? Border.all(color: colorScheme.outline.withValues(alpha: 0.15))
                : null,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(action.icon, color: mainColor, size: 24),
                    ),
                    const SizedBox(width: 14),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            action.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCompleted
                                  ? colorScheme.onSurface.withValues(alpha: 0.4)
                                  : colorScheme.onSurface,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildMiniTag(
                                context,
                                _getFreqLabel(action.frequency),
                                colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              _buildMiniTag(
                                context,
                                '+${action.impactScore} pts',
                                colorScheme.tertiary,
                              ),
                              if (streakCount > 0) ...[
                                const SizedBox(width: 6),
                                _buildMiniTag(
                                  context,
                                  '🔥 $streakCount',
                                  colorScheme.tertiary,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Check button
                    _buildCheckButton(context, mainColor),
                  ],
                ),
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: _buildProgressSection(context, theme, colorScheme),
              ),

              // Completion badge – wait message
              if (isCompleted)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _waitLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final target = _targetForFrequency;
    final current = streakCount.clamp(0, target);
    final progress = target > 0 ? current / target : 0.0;
    final progressColor = isCompleted
        ? colorScheme.primary.withValues(alpha: 0.5)
        : colorScheme.primary;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$current / $target',
              style: theme.textTheme.labelSmall?.copyWith(
                color: progressColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: colorScheme.onSurface.withValues(alpha: 0.06),
            color: progressColor,
            minHeight: 5,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCheckButton(BuildContext context, Color mainColor) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isCompleted ? null : onValidate,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          gradient: isCompleted
              ? null
              : LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
          color: isCompleted
              ? colorScheme.primary.withValues(alpha: 0.15)
              : null,
          shape: BoxShape.circle,
          boxShadow: isCompleted
              ? null
              : [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Icon(
          isCompleted ? Icons.check : Icons.check,
          color: isCompleted ? colorScheme.primary : colorScheme.onPrimary,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildMiniTag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(
    BuildContext context, {
    required AlignmentGeometry alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerRight) ...[
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Icon(icon, color: color, size: 24),
          if (alignment == Alignment.centerLeft) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
