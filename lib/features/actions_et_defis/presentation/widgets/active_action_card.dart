import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/user_active_action_entity.dart';
import 'package:oikos/features/actions_et_defis/presentation/widgets/animated_progress_bar.dart';
import 'package:oikos/features/actions_et_defis/presentation/widgets/tag.dart'; // Import du nouveau widget

class ActiveActionCard extends StatelessWidget {
  final UserActiveActionEntity activeAction;
  final VoidCallback onValidate;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const ActiveActionCard({
    super.key,
    required this.activeAction,
    required this.onValidate,
    required this.onDelete,
    this.onTap,
  });

  int get _targetForFrequency {
    switch (activeAction.action.frequency.toLowerCase()) {
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
    switch (activeAction.action.frequency.toLowerCase()) {
      case 'quotidienne':
        return 'Reviens demain !';
      case 'hebdomadaire':
        return 'Reviens la semaine prochaine !';
      case 'mensuelle':
        return 'Reviens le mois prochain !';
      default:
        return 'Déjà validée !';
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
    final isCompleted = activeAction.isCompleted();

    final bgColor = isCompleted
        ? colorScheme.onSurface.withValues(alpha: 0.03)
        : colorScheme.surface;
    final actionColorScheme = Theme.of(context).extension<ActionCardTheme>()!;
    final actionCategoryColor = actionColorScheme.getCategoryColor(
      activeAction.action.categoryName,
    );

    return Dismissible(
      key: Key('active_action_${activeAction.action.id}'),
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
          margin: const EdgeInsets.only(top: 4),
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
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: actionCategoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        activeAction.action.icon,
                        color: actionCategoryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeAction.action.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCompleted
                                  ? colorScheme.onSurface.withValues(alpha: 0.4)
                                  : colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // --- UTILISATION DES WIDGETS REUTILISABLES ---
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              OikosTag(
                                label: _getFreqLabel(
                                  activeAction.action.frequency,
                                ),
                                color: colorScheme.primary,
                              ),
                              OikosTag(
                                label:
                                    '+${activeAction.action.impactScore} pts',
                                color: colorScheme.tertiary,
                              ),
                              if (activeAction.streakCount > 0)
                                OikosTag(
                                  label: '${activeAction.streakCount}',
                                  icon: Icons.local_fire_department,
                                  color: Colors.orange,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildCheckButton(context),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: _buildProgressSection(context, theme, colorScheme),
              ),
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
    final current = activeAction.streakCount.clamp(0, target);
    final progress = target > 0 ? current / target : 0.0;
    final progressColor = activeAction.isCompleted()
        ? colorScheme.primary.withValues(alpha: 0.5)
        : colorScheme.primary;
    final actionCategoryColor = Theme.of(context)
        .extension<ActionCardTheme>()!
        .getCategoryColor(activeAction.action.categoryName);

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
          child: AnimatedProgressBar(
            backgroundColor: actionCategoryColor.withValues(alpha: 0.1),
            valueColor: actionCategoryColor,
            activeAction: activeAction,
            start: true,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCheckButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = activeAction.isCompleted();

    AnimationController? animController;

    return GestureDetector(
      onTap: () {
        if (!isCompleted) {
          animController?.forward(from: 0);
          onValidate();
        }
      },
      child:
          AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [
                            colorScheme.primary.withValues(alpha: 0.15),
                            colorScheme.primary.withValues(alpha: 0.15),
                          ]
                        : [
                            colorScheme.primary,
                            colorScheme.primary.withValues(alpha: 0.7),
                          ],
                  ),
                  boxShadow: isCompleted
                      ? []
                      : [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: isCompleted
                        ? colorScheme.primary
                        : colorScheme.onPrimary,
                    size: 22,
                  ),
                ),
              )
              .animate(autoPlay: false, onInit: (c) => animController = c)
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.3, 1.3),
                duration: 250.ms,
                curve: Curves.easeOut,
              )
              .then()
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(0.77, 0.77),
                duration: 200.ms,
                curve: Curves.bounceOut,
              )
              .shimmer(
                delay: 150.ms,
                duration: 500.ms,
                color: colorScheme.onPrimary.withValues(alpha: 0.4),
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
