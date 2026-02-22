import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/actions/presentation/bloc/actions_bloc.dart';
import 'package:oikos/features/actions/presentation/bloc/actions_event.dart';
import 'package:oikos/features/actions/presentation/widgets/category_chip.dart';
import 'package:oikos/features/actions/presentation/widgets/ecarter_Actions_Modal.dart';
import 'package:oikos/features/actions/presentation/widgets/tag.dart';
import '../../domain/entities/action_entity.dart';

class ActionCard extends StatelessWidget {
  final ActionEntity action;
  final VoidCallback onTap;

  const ActionCard({super.key, required this.action, required this.onTap});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de couleur supérieure utilisant la couleur de catégorie
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icône stylisée avec CategoryChip en mode icône seule
                      _buildActionIcon(categoryColor),
                      const SizedBox(width: 14),

                      // Titre + description
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
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                CategoryChip(
                                  categoryName: action.categoryName,
                                  onTap: () => _handleCategoryTap(
                                    context,
                                    action.categoryName,
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
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Utilisation de CategoryChip pour afficher la catégorie sur la carte
                  CategoryChip(
                    categoryName: action.categoryName,
                    style: CategoryChipStyle.minimalist,
                  ),
                  const SizedBox(height: 8),

                  // Utilisation de OikosTag pour les tags (sous-catégories)
                  if (action.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: action.tags
                          .take(3)
                          .map(
                            (tag) => OikosTag(
                              label: tag,
                              onTap: () => _handleTagTap(context, tag),
                            ),
                          )
                          .toList(),
                    ),

                  if (action.tags.isNotEmpty) const SizedBox(height: 12),

                  Divider(
                    height: 1,
                    color: colorScheme.outline.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 12),

                  // Statistiques (Stats Chips)
                  Row(
                    children: [
                      _buildStatChip(
                        context,
                        Icons.bolt,
                        '${action.impactScore} pts',
                        colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      _buildStatChip(
                        context,
                        Icons.speed,
                        action.difficulty,
                        colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                      const SizedBox(width: 10),
                      _buildStatChip(
                        context,
                        Icons.schedule,
                        _getFreqLabel(action.frequency),
                        colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget interne pour l'icône, utilisant la logique de couleur de catégorie
  Widget _buildActionIcon(Color categoryColor) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withValues(alpha: 0.15),
            categoryColor.withValues(alpha: 0.30),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: categoryColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Icon(action.icon, color: categoryColor, size: 26),
    );
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

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _handleCategoryTap(BuildContext context, String category) {
    final userState = context.read<AppUserCubit>().state;
    final String userId = switch (userState) {
      AppUserLoggedIn(:final user) => user.id,
      _ => '',
    };
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => EcarterActionsModal(
        title: "Thématique : $category",
        message:
            "Cette catégorie t'intéresse moins ? Tu peux choisir de ne plus voir les actions de cette thématique.",
        onConfirm: () {
          context.read<ActionsBloc>().add(
            EcarterCategorieEvent(userId: userId, categorieNom: category),
          );
          Navigator.pop(context);
        },
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  void _handleTagTap(BuildContext context, String tag) {
    final userState = context.read<AppUserCubit>().state;

    final String userId = switch (userState) {
      AppUserLoggedIn(:final user) => user.id,
      _ => '', // Cas par défaut (AppUserInitial, AppUserLoading, etc.)
    };
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => EcarterActionsModal(
        title: "Tag : $tag",
        message:
            "Ce tag t'intéresse moins ? Tu peux choisir de ne plus voir les actions liées à ce tag.",
        onConfirm: () {
          context.read<ActionsBloc>().add(
            EcarterTagEvent(userId: userId, tagNom: tag),
          );
          Navigator.pop(context);
        },
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }
}
