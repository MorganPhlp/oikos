import 'package:flutter/material.dart';
import 'package:oikos/core/common/presentation/widgets/confirm_modal.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import '../../domain/entities/action_entity.dart';

class ActionDetailBottomBar extends StatelessWidget {
  final ActionEntity action;
  final bool isAlreadyAdded;
  final Color categoryColor;
  final Function(ActionEntity) onAdd;
  final Function(String)? onEcarter;

  const ActionDetailBottomBar({
    super.key,
    required this.action,
    required this.isAlreadyAdded,
    required this.categoryColor,
    required this.onAdd,
    this.onEcarter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isAlreadyAdded)
            _buildAlreadyAddedBadge(theme, colorScheme)
          else ...[
            GradientButton(
              onPressed: () => onAdd(action),
              label: 'Ajouter à mes actions',
            ),
            if (onEcarter != null) ...[
              const SizedBox(height: 9),
              TextButton(
                onPressed: () => _showDismissDialog(context),
                child: Text(
                  'Pas pour moi',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildAlreadyAddedBadge(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 22, color: categoryColor),
          const SizedBox(width: 10),
          Text(
            'Déjà dans mes actions',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  void _showDismissDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => OikosConfirmModal(
        confirmColor: Theme.of(context).colorScheme.primary,
        title: 'Écarter cette action ?',
        message: 'Elle ne sera plus visible dans votre catalogue.',
        confirmLabel: 'Oui, écarter',
        onConfirm: () {
          onEcarter?.call(action.id);
        },
      ),
    );
  }
}
