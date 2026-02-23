import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/common/presentation/widgets/snackbar.dart';
import 'package:oikos/features/actions/domain/util/ActionsFilterHandler.dart';
import 'package:oikos/features/actions/presentation/bloc/habitudes_cubit.dart';
import 'package:oikos/features/actions/presentation/bloc/habitudes_state.dart';
import 'package:oikos/features/actions/presentation/widgets/catalog_empty_state.dart';
import 'package:oikos/features/actions/presentation/widgets/catalog_search_bar.dart';
import '../../domain/entities/action_entity.dart';
import '../bloc/actions_bloc.dart';
import '../bloc/actions_event.dart';
import '../bloc/actions_state.dart';
import '../widgets/action_card.dart';
import '../widgets/action_detail_modal.dart';
import '../widgets/filter_sort_modal.dart';

class ActionsCataloguePage extends StatefulWidget {
  final String? openedActionId;
  const ActionsCataloguePage({super.key, this.openedActionId});

  @override
  State<ActionsCataloguePage> createState() => _ActionsCataloguePageState();
}

class _ActionsCataloguePageState extends State<ActionsCataloguePage> {
  String _searchQuery = '';
  FilterData _filters = FilterData();

  bool get _hasActiveFilters =>
      _filters.frequency != null ||
      _filters.category != null ||
      _filters.tags.isNotEmpty ||
      _filters.sortBy != 'default';

  void _onActionsStateChanged(BuildContext context, ActionsState state) {
    final theme = Theme.of(context);

    if (state is ActionsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: theme.colorScheme.errorContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: OikosSnackBarContent(message: state.message, isError: true),
        ),
      );
    }

    if (state is ActionOperationSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: theme.colorScheme.primaryContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: OikosSnackBarContent(message: state.message, isError: false),
        ),
      );
    }

    if (state is ActionsLoaded && widget.openedActionId != null) {
      _checkAndOpenInitialAction();
    }
  }

  @override
  void didUpdateWidget(covariant ActionsCataloguePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.openedActionId != widget.openedActionId &&
        widget.openedActionId != null) {
      _checkAndOpenInitialAction();
    }
  }

  void _checkAndOpenInitialAction() {
    final actionsBloc = context.read<ActionsBloc>();
    final habitudesBloc = context.read<HabitudeCubit>();
    final actionsState = actionsBloc.state;
    final habitudeState = habitudesBloc.state;

    if (actionsState is ActionsLoaded) {
      try {
        final action = actionsState.catalogue.firstWhere(
          (a) => a.id == widget.openedActionId,
        );
        final userId = _getUserId();
        final alreadyAdded =
            actionsState.activeActionIds.contains(action.id) ||
            (habitudeState is HabitudeLoaded &&
                habitudeState.habitueActionIds.contains(action.id));

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showDetailModal(
              context,
              action,
              userId,
              isAlreadyAdded: alreadyAdded,
            );
          }
        });
      } catch (_) {}
    }
  }

  String _getUserId() {
    final state = context.read<AppUserCubit>().state;
    return state is AppUserLoggedIn ? state.user.id : '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionsBloc, ActionsState>(
      listener: _onActionsStateChanged,
      child: Scaffold(
        body: BlocBuilder<ActionsBloc, ActionsState>(
          buildWhen: (previous, current) => current is! ActionOperationSuccess,
          builder: (context, state) {
            if (state is ActionsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ActionsLoaded) {
              return _buildCatalogueContent(context, state);
            }

            if (state is ActionsError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCatalogueContent(BuildContext context, ActionsLoaded state) {
    final userId = _getUserId();
    final habitudeState = context.watch<HabitudeCubit>().state;

    if (habitudeState is HabitudeLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final habitudesIds = habitudeState is HabitudeLoaded
        ? habitudeState.habitueActionIds
        : <String>[];
    final displayList = state.catalogue.applyFilters(
      searchQuery: _searchQuery,
      filters: _filters,
    );

    return Column(
      children: [
        const SizedBox(height: 16),
        CatalogueSearchBar(
          onSearchChanged: (val) => setState(() => _searchQuery = val),
          onFilterTap: () => _openFilterModal(context, state.catalogue),
          hasActiveFilters: _hasActiveFilters,
        ),
        if (_hasActiveFilters) _buildFilterSummary(displayList.length),
        Expanded(
          child: displayList.isEmpty
              ? const CatalogueEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final action = displayList[index];
                    final alreadyAdded =
                        state.activeActionIds.contains(action.id) ||
                        habitudesIds.contains(action.id);
                    return ActionCard(
                      action: action,
                      onTap: () => _showDetailModal(
                        context,
                        action,
                        userId,
                        isAlreadyAdded: alreadyAdded,
                      ),
                      isInMyActions: alreadyAdded,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterSummary(int count) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          Text(
            '$count résultat${count > 1 ? 's' : ''}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() => _filters = FilterData()),
            child: Text(
              'Effacer les filtres',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFilterModal(BuildContext context, List<ActionEntity> catalogue) {
    final allCategories = catalogue.map((a) => a.categoryName).toSet().toList()
      ..sort();
    final allTags = catalogue.expand((a) => a.tags).toSet().toList()..sort();
    final allFrequencies = catalogue.map((a) => a.frequency).toSet().toList()
      ..sort();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSortModal(
        currentFilters: _filters,
        allCategories: allCategories,
        allTags: allTags,
        allFrequencies: allFrequencies,
        onApply: (newFilters) => setState(() => _filters = newFilters),
      ),
    );
  }

  void _showDetailModal(
    BuildContext context,
    ActionEntity action,
    String userId, {
    bool isAlreadyAdded = false,
  }) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ActionDetailModal(
        action: action,
        isAlreadyAdded: isAlreadyAdded,
        onAdd: (actionToAdd) {
          Navigator.pop(context);
          context.read<ActionsBloc>().add(
            AddToMyActionsEvent(userId: userId, actionId: actionToAdd.id),
          );
        },
        onEcarter: (actionId) {
          context.read<ActionsBloc>().add(
            EcarterActionEvent(userId: userId, actionId: actionId),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
