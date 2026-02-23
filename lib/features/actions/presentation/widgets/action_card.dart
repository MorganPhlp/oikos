import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/actions/presentation/bloc/actions_bloc.dart';
import 'package:oikos/features/actions/presentation/bloc/actions_event.dart';
import 'package:oikos/features/actions/presentation/widgets/action_stats_chip.dart';
import 'package:oikos/features/actions/presentation/widgets/category_chip.dart';
import 'package:oikos/features/actions/presentation/widgets/ecarter_Actions_Modal.dart';
import 'package:oikos/features/actions/presentation/widgets/tag.dart';
import '../../domain/entities/action_entity.dart';

class ActionCard extends StatelessWidget {
  final ActionEntity action;
  final VoidCallback onTap;
  final bool? isInMyActions;

  const ActionCard({
    super.key,
    required this.action,
    required this.onTap,
    this.isInMyActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final actionTheme = theme.extension<ActionCardTheme>()!;
    final categoryColor = actionTheme.getCategoryColor(action.categoryName);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildTopIndicator(categoryColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(context, theme, colorScheme, categoryColor),
                  const SizedBox(height: 12),
                  _buildChips(context),
                  const SizedBox(height: 12),
                  Divider(
                    height: 1,
                    color: colorScheme.outline.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 12),
                  _buildFooter(context, colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIndicator(Color color) => Container(
    height: 4,
    decoration: BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    ),
  );

  Widget _buildMainInfo(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIconBox(color),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      action.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CategoryChip(
                    categoryName: action.categoryName,
                    onTap: () => _showEcarterModal(
                      context,
                      "Thématique : ${action.categoryName}",
                      true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                action.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconBox(Color color) => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.30)],
      ),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
    ),
    child: Icon(action.icon, color: color, size: 26),
  );

  Widget _buildChips(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (action.tags.isNotEmpty) ...[
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: action.tags
              .take(3)
              .map(
                (tag) => OikosTag(
                  label: tag,
                  onTap: () => _showEcarterModal(
                    context,
                    "Tag : $tag",
                    false,
                    tagName: tag,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ],
  );

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) => Row(
    children: [
      ActionStatChip(
        icon: Icons.bolt,
        text: '${action.impactScore} pts',
        color: colorScheme.primary,
      ),
      const SizedBox(width: 16),
      ActionStatChip(
        icon: Icons.speed,
        text: action.difficulty,
        color: colorScheme.onSurface.withValues(alpha: 0.55),
      ),
      const SizedBox(width: 16),
      ActionStatChip(
        icon: Icons.schedule,
        text: _getFreqLabel(action.frequency),
        color: colorScheme.onSurface.withValues(alpha: 0.55),
      ),
      const Spacer(),
      if (isInMyActions == true) _buildMyActionsLink(context, colorScheme),
    ],
  );

  Widget _buildMyActionsLink(BuildContext context, ColorScheme colorScheme) =>
      GestureDetector(
        onTap: () => context.goNamed('my_actions'),
        child: Column(
          children: [
            Icon(Icons.arrow_forward_ios, size: 12, color: colorScheme.primary),
            Text(
              'Mes actions',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 9,
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  void _showEcarterModal(
    BuildContext context,
    String title,
    bool isCategory, {
    String? tagName,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => EcarterActionsModal(
        title: title,
        message:
            "Tu peux choisir de ne plus voir ce contenu s'il t'intéresse moins.",
        onConfirm: () {
          final userState = context.read<AppUserCubit>().state;
          final userId = userState is AppUserLoggedIn ? userState.user.id : '';
          final event = isCategory
              ? EcarterCategorieEvent(
                  userId: userId,
                  categorieNom: action.categoryName,
                )
              : EcarterTagEvent(userId: userId, tagNom: tagName!);
          context.read<ActionsBloc>().add(event);
          Navigator.pop(context);
        },
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  String _getFreqLabel(String freq) => switch (freq) {
    'journalier' => 'Quotidien',
    'hebdomadaire' => 'Hebdo',
    'mensuel' => 'Mensuel',
    'unique' => 'Bonus',
    _ => freq,
  };
}
