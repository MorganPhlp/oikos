import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/widgets/confirm_modal.dart';
import 'package:oikos/features/actions/data/models/limite_actions_freq_model.dart';
import 'package:oikos/features/actions/domain/entities/limite_action_freq_entity.dart';
import 'package:oikos/features/actions/presentation/widgets/count_widget.dart';
import 'package:oikos/features/actions/presentation/widgets/my_actions_progress_card.dart';
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
  final Map<String, ScrollController> _controllers = {};
  String selectedFilter = 'quotidienne';

  List<UserActiveActionEntity> get _filteredList =>
      widget.activeActions
          .where((e) => e.action.frequency == selectedFilter)
          .toList()
        ..sort(
          (a, b) => a.periodCompletion == b.periodCompletion
              ? 0
              : (a.periodCompletion ? 1 : -1),
        );

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actions = _filteredList;
    final controller = _controllers.putIfAbsent(
      selectedFilter,
      () => ScrollController(),
    );
    final done = actions.where((e) => e.periodCompletion).length;
    final progress = (selectedFilter == 'lifestyle')
        ? 1.0
        : (actions.isEmpty ? 0.0 : done / actions.length);

    return Stack(
      children: [
        Column(
          children: [
            MyActionsProgressCard(
              progress: progress,
              done: done,
              total: actions.length,
              isLifestyle: selectedFilter == 'lifestyle',
            ),
            _buildFilterBar(),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                layoutBuilder: (currentChild, previousChildren) {
                  return currentChild ?? const SizedBox.shrink();
                },
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),

                    child: child,
                  ),
                ),
                duration: const Duration(milliseconds: 250),

                child: actions.isEmpty
                    ? _buildEmptyState()
                    : _buildList(actions, controller),
              ),
            ),
          ],
        ),
        _buildFloatingCounter(actions.length, controller),
      ],
    );
  }

  Widget _buildList(
    List<UserActiveActionEntity> actions,
    ScrollController controller,
  ) => ListView.builder(
    controller: controller,
    key: ValueKey(selectedFilter),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemCount: actions.length,
    itemBuilder: (context, index) => ActiveActionCard(
      activeAction: actions[index],
      onValidate: () => widget.onValidate(actions[index]),
      onDelete: () => _confirmDelete(actions[index]),
      onTap: () => _showDetail(actions[index]),
    ),
  );

  Widget _buildFilterBar() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        _filterChip('Quotidien', 'quotidienne'),
        const SizedBox(width: 10),
        _filterChip('Hebdo', 'hebdomadaire'),
        const SizedBox(width: 10),
        _filterChip('Mensuel', 'mensuelle'),
        const SizedBox(width: 10),
        _filterChip('Bonus', 'bonus'),
      ],
    ),
  );

  Widget _filterChip(String label, String value) {
    final isSelected = selectedFilter == value;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : theme.colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _confirmDelete(UserActiveActionEntity entry) {
    showDialog(
      context: context,
      builder: (ctx) => OikosConfirmModal(
        title: 'Retirer cette action ?',
        message: 'Tu pourras la reprendre plus tard dans le catalogue.',
        confirmLabel: 'Confirmer le retrait',
        onConfirm: () => widget.onDelete(entry),
      ),
    );
  }

  Widget _buildFloatingCounter(
    int count,
    ScrollController controller,
  ) => Positioned(
    bottom: 20,
    left: 0,
    right: 0,
    child: CountWidget(
      value: count,
      max:
          widget.limiteActionsFreq
              .firstWhere(
                (e) => e.frequence == selectedFilter,
                orElse: () => LimiteActionFreqModel(
                  frequence: selectedFilter,
                  value: count,
                ),
              )
              .value ??
          0,
    ).animate(adapter: ScrollAdapter(controller)).fade(begin: 1.0, end: 0.0),
  );

  void _showDetail(UserActiveActionEntity entry) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ActionDetailModal(
      action: entry.action,
      onAdd: (_) => Navigator.pop(context),
      onEcarter: (_) => Navigator.pop(context),
      isAlreadyAdded: true,
    ),
  );

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          LucideIcons.star,
          size: 60,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
        ),
        const SizedBox(height: 16),
        Text(
          'Aucune action $selectedFilter',
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 24),
        TextButton.icon(
          onPressed: () => context.goNamed('catalogue'),
          icon: const Text('Découvrir le catalogue'),
          label: const Icon(LucideIcons.arrowRight, size: 16),
        ),
      ],
    ),
  );
}
