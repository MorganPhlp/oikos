import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/entities/user_active_action_entity.dart';
import '../../domain/entities/action_entity.dart';
import '../widgets/action_detail_modal.dart';
import '../widgets/active_action_card.dart';

class MyActionsTab extends StatefulWidget {
  final List<UserActiveActionEntity> activeActions;
  final Function(String actionId) onValidate;
  final Function(String actionId) onDelete;

  const MyActionsTab({
    super.key,
    required this.activeActions,
    required this.onValidate,
    required this.onDelete,
  });

  @override
  State<MyActionsTab> createState() => _MyActionsTabState();
}

class _MyActionsTabState extends State<MyActionsTab> {
  String selectedFilter = 'quotidienne';

  String _getFilterTitle(String filter) {
    switch (filter) {
      case 'quotidienne':
        return 'Quotidien';
      case 'hebdomadaire':
        return 'Hebdo';
      case 'mensuelle':
        return 'Mensuel';
      case 'unique':
        return 'Bonus';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // si pas d'actions
    if (widget.activeActions.isEmpty) {}
    final filteredList = widget.activeActions.where((e) {
      if (e.action.frequency == selectedFilter) return true;
      return false;
    }).toList();
    filteredList.sort((a, b) {
      if (a.isCompletedForPeriod == b.isCompletedForPeriod) return 0;
      return a.isCompletedForPeriod ? 1 : -1;
    });

    final totalActions = filteredList.length;
    final actionsDone = filteredList
        .where((e) => e.isCompletedForPeriod)
        .length;
    final globalProgress = (selectedFilter == 'lifestyle')
        ? 1.0
        : (totalActions == 0 ? 0.0 : actionsDone / totalActions);

    return Column(
      children: [
        _buildGlobalProgressCard(
          context,
          globalProgress,
          actionsDone,
          totalActions,
        ),

        // Filtres
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildTabFilter(context, 'Quotidien', 'quotidienne'),
              const SizedBox(width: 10),
              _buildTabFilter(context, 'Hebdo', 'hebdomadaire'),
              const SizedBox(width: 10),
              _buildTabFilter(context, 'Mensuel', 'mensuelle'),
              const SizedBox(width: 10),
              _buildTabFilter(context, 'Bonus', 'unique'),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Liste des actions
        Expanded(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );

              final scaleAnimation = Tween<double>(
                begin: 0.9,
                end: 1.0,
              ).animate(curved);

              return ScaleTransition(
                scale: scaleAnimation,
                child: FadeTransition(opacity: curved, child: child),
              );
            },
            child: filteredList.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    key: ValueKey(selectedFilter),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final entry = filteredList[index];
                      final action = entry.action;
                      final isLifestyle = selectedFilter == 'lifestyle';

                      return ActiveActionCard(
                        action: action,
                        frequency: action.frequency,
                        isCompleted: isLifestyle || entry.isCompletedForPeriod,
                        streakCount: entry.streakCount,
                        onValidate: () {
                          widget.onValidate(action.id);
                        },
                        onDelete: () => _confirmDelete(context, action.id),
                        onTap: () => _showActionDetail(context, action),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  void _showActionDetail(BuildContext context, ActionEntity action) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ActionDetailModal(
        action: action,
        onJoin: (_) => Navigator.pop(context),
        isAlreadyAdded: true,
      ),
    );
  }

  Widget _buildGlobalProgressCard(
    BuildContext context,
    double globalProgress,
    int actionsDoneToday,
    int totalActions,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLifestyle = selectedFilter == 'lifestyle';

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isLifestyle
                      ? 'Mes habitudes acquises'
                      : 'Ma progression (${_getFilterTitle(selectedFilter)})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                isLifestyle ? Icons.favorite : Icons.emoji_events,
                color: isLifestyle ? colorScheme.error : colorScheme.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!isLifestyle)
            Text(
              '$actionsDoneToday/$totalActions actions avancées aujourd\'hui',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: globalProgress,
              backgroundColor: colorScheme.onSurface.withValues(alpha: 0.05),
              color: isLifestyle ? colorScheme.primary : colorScheme.tertiary,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabFilter(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedFilter == value;
    final activeColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : (colorScheme.outline),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLifestyle = selectedFilter == 'lifestyle';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isLifestyle ? LucideIcons.trophy : Icons.inventory_2_outlined,
            size: 60,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            isLifestyle
                ? 'Pas encore de trophées.'
                : 'Aucune action ${(selectedFilter).toLowerCase()}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24), // Un peu plus d'espace pour le bouton
          TextButton.icon(
            onPressed: () => context.goNamed('catalogue'),
            icon: const Text('Découvrir le catalogue'),
            label: const Icon(LucideIcons.arrowRight, size: 16),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String actionId) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Retirer cette action ?'),
        content: const Text('Tu pourras la reprendre plus tard.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Annuler',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDelete(actionId);
            },
            style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
            child: const Text('Arrêter'),
          ),
        ],
      ),
    );
  }
}
