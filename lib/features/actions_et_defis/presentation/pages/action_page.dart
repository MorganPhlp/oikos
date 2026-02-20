import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
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
  String searchQuery = '';
  FilterData _filters = FilterData();

  bool get _hasActiveFilters =>
      _filters.frequency != null ||
      _filters.category != null ||
      _filters.tags.isNotEmpty ||
      _filters.sortBy != 'default';

  @override
  void didUpdateWidget(covariant ActionsCataloguePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final userId = switch (context.read<AppUserCubit>().state) {
      AppUserLoggedIn(user: var u) => u.id,
      _ => '',
    };
    if (oldWidget.openedActionId != widget.openedActionId &&
        widget.openedActionId != null) {
      final state = context.read<ActionsBloc>().state;
      if (state is ActionsLoaded) {
        final action = state.catalogue.firstWhere(
          (a) => a.id == widget.openedActionId,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showDetailModal(context, action, userId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUserState = context.read<AppUserCubit>().state;
    final String userId = (appUserState is AppUserLoggedIn)
        ? appUserState.user.id
        : '';

    return BlocListener<ActionsBloc, ActionsState>(
      listener: (BuildContext context, ActionsState state) {
        if (state is ActionsLoaded && widget.openedActionId != null) {
          final action = state.catalogue.firstWhere(
            (a) => a.id == widget.openedActionId,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showDetailModal(context, action, userId);
          });
        }
      },
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ActionsBloc, ActionsState>(
              builder: (context, state) {
                if (state is ActionsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
                if (state is ActionsLoaded) {
                  return _buildCatalogueList(context, state, userId);
                }
                if (state is ActionsError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ActionEntity> _applyFilters(List<ActionEntity> catalogue) {
    var list = catalogue.where((action) {
      if (_filters.frequency != null &&
          action.frequency != _filters.frequency) {
        return false;
      }
      if (_filters.category != null &&
          action.categoryName != _filters.category) {
        return false;
      }
      if (_filters.tags.isNotEmpty) {
        final tags = action.tags.toSet();
        if (!_filters.tags.any((t) => tags.contains(t))) return false;
      }
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        return action.title.toLowerCase().contains(q) ||
            action.categoryName.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    switch (_filters.sortBy) {
      case 'points_desc':
        list.sort((a, b) => b.impactScore.compareTo(a.impactScore));
        break;
      case 'points_asc':
        list.sort((a, b) => a.impactScore.compareTo(b.impactScore));
        break;
      case 'difficulty':
        const order = {'Facile': 0, 'Moyen': 1, 'Difficile': 2};
        list.sort(
          (a, b) =>
              (order[a.difficulty] ?? 3).compareTo(order[b.difficulty] ?? 3),
        );
        break;
    }
    return list;
  }

  Widget _buildCatalogueList(
    BuildContext context,
    ActionsLoaded state,
    String userId,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayList = _applyFilters(state.catalogue);
    final activeIds = state.activeActionIds;

    return Column(
      children: [
        const SizedBox(height: 16),

        // Search bar + filter icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color:
                          theme
                              .inputDecorationTheme
                              .enabledBorder
                              ?.borderSide
                              .color ??
                          colorScheme.outline,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Rechercher une action...',
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      icon: Icon(Icons.search, color: colorScheme.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Funnel filter button
              GestureDetector(
                onTap: () => _openFilterModal(context, state.catalogue),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _hasActiveFilters
                        ? colorScheme.primary
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _hasActiveFilters
                          ? Colors.transparent
                          : colorScheme.outline,
                    ),
                    boxShadow: _hasActiveFilters
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: _hasActiveFilters
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface.withValues(alpha: 0.5),
                        size: 22,
                      ),
                      if (_hasActiveFilters)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colorScheme.tertiary,
                              shape: BoxShape.circle,
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

        const SizedBox(height: 8),

        // Active filter summary + clear
        if (_hasActiveFilters)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${displayList.length} résultat${displayList.length > 1 ? 's' : ''}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() {
                    _filters = FilterData();
                  }),
                  child: Text(
                    'Effacer les filtres',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 4),

        // List
        Expanded(
          child: displayList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: colorScheme.onSurface.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aucune action trouvée',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final action = displayList[index];
                    final alreadyAdded = activeIds.contains(action.id);
                    return ActionCard(
                      action: action,
                      onTap: () => _showDetailModal(
                        context,
                        action,
                        userId,
                        isAlreadyAdded: alreadyAdded,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _openFilterModal(BuildContext context, List<ActionEntity> catalogue) {
    final allCategories = catalogue.map((a) => a.categoryName).toSet().toList()
      ..sort();

    final allTags = <String>{};
    for (final a in catalogue) {
      allTags.addAll(a.tags);
    }
    final sortedTags = allTags.toList()..sort();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSortModal(
        currentFilters: _filters,
        allCategories: allCategories,
        allTags: sortedTags,
        onApply: (newFilters) => setState(() => _filters = newFilters),
      ),
    );
  }

  // ── Detail modal ───────────────────────────────────────────────────────────

  void _showDetailModal(
    BuildContext context,
    ActionEntity action,
    String userId, {
    bool isAlreadyAdded = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ActionDetailModal(
        action: action,
        isAlreadyAdded: isAlreadyAdded,
        onJoin: (freq) {
          Navigator.pop(context);
          context.read<ActionsBloc>().add(
            AddToMyActionsEvent(userId: userId, actionId: action.id),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Action ajoutée !'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}
