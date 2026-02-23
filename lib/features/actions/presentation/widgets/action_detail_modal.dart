import 'package:flutter/material.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/actions/presentation/widgets/action_details_bottom_bar.dart';
import 'package:oikos/features/actions/presentation/widgets/action_details_content.dart';
import 'package:oikos/features/actions/presentation/widgets/action_details_header.dart';
import '../../domain/entities/action_entity.dart';

class ActionDetailModal extends StatelessWidget {
  final ActionEntity action;
  final Function(ActionEntity action) onAdd;
  final Function(String actionId)? onEcarter;
  final bool isAlreadyAdded;

  const ActionDetailModal({
    super.key,
    required this.action,
    required this.onAdd,
    this.onEcarter,
    this.isAlreadyAdded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionTheme = theme.extension<ActionCardTheme>()!;
    final categoryColor = actionTheme.getCategoryColor(action.categoryName);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Stack(
            children: [
              ListView(
                controller: controller,
                padding: EdgeInsets.zero,
                children: [
                  ActionDetailHeader(
                    action: action,
                    categoryColor: categoryColor,
                  ),
                  const SizedBox(height: 24),
                  ActionDetailContent(action: action),
                  const SizedBox(height: 140), // Espace pour la barre fixe
                ],
              ),
              Positioned(top: 16, right: 16, child: _buildCloseButton(context)),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ActionDetailBottomBar(
                  action: action,
                  isAlreadyAdded: isAlreadyAdded,
                  categoryColor: categoryColor,
                  onAdd: onAdd,
                  onEcarter: onEcarter,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.close, size: 20),
    );
  }
}
