import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/limite_action_freq_entity.dart';
import 'package:oikos/features/actions_et_defis/presentation/widgets/count_widget.dart';
import '../../domain/entities/user_active_action_entity.dart';
import '../widgets/action_detail_modal.dart';
import '../widgets/active_action_card.dart';

class MyActionsTab extends StatefulWidget {
  final List<UserActiveActionEntity> activeActions;
  final List<LimiteActionFreqEntity> limiteActionsFreq;
  final Function(UserActiveActionEntity) onValidate;
  final Function(UserActiveActionEntity) onDelete;

  const MyActionsTab({
    super.key,
    required this.activeActions,
    required this.onValidate,
    required this.onDelete,
    required this.limiteActionsFreq,
  });

  @override
  State<MyActionsTab> createState() => _MyActionsTabState();
}

class _MyActionsTabState extends State<MyActionsTab> {
  late ScrollController _scrollController;
  String selectedFilter = 'quotidienne';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getFilterTitle(String filter) {
    switch (filter) {
      case 'quotidienne':
        return 'Quotidien';
      case 'hebdomadaire':
        return 'Hebdo';
      case 'mensuelle':
        return 'Mensuel';
      case 'bonus':
        return 'Bonus';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Stack(
      children: [
        Column(
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
                  _buildTabFilter(context, 'Bonus', 'bonus'),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, -0.2),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                        ),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                layoutBuilder: (currentChild, previousChildren) {
                  return currentChild!;
                },
                child: filteredList.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        controller: _scrollController,
                        key: ValueKey(selectedFilter),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final entry = filteredList[index];
                          return ActiveActionCard(
                            activeAction: entry,
                            onValidate: () => widget.onValidate(entry),
                            onDelete: () => _confirmDelete(context, entry),
                            onTap: () => _showActionDetail(context, entry),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child:
              CountWidget(
                    value: filteredList.length,
                    max: widget.activeActions.length,
                  )
                  .animate(adapter: ScrollAdapter(_scrollController))
                  .fade(begin: 1.0, end: 0.0),
        ),
      ],
    );
  }

  void _showActionDetail(BuildContext context, UserActiveActionEntity entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ActionDetailModal(
        action: entry.action,
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.star,
            size: 60,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune action ${(selectedFilter).toLowerCase()}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
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

  void _confirmDelete(BuildContext context, UserActiveActionEntity entry) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: colorScheme.surface,
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        title: const Center(
          child: Text(
            'Retirer cette action ?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: Text(
          'Tu pourras la reprendre plus tard dans le catalogue.',
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  isTertiary: true,
                  onPressed: () {
                    Navigator.pop(ctx);
                    widget.onDelete(entry);
                  },
                  label: 'Confirmer le retrait',
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
