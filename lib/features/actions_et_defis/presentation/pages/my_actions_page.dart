import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/actions_event.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/habitudes_cubit.dart';
import 'package:oikos/features/actions_et_defis/presentation/pages/my_habitudes_tab.dart';
import 'package:oikos/features/actions_et_defis/presentation/widgets/promote_to_habitude_popup.dart';
import 'package:oikos/init_dependencies.dart';
import '../bloc/actions_bloc.dart';
import '../bloc/actions_state.dart';
import '../pages/my_actions_tab.dart';

class MyActionsPage extends StatefulWidget {
  const MyActionsPage({super.key});

  @override
  State<MyActionsPage> createState() => _MyActionsPageState();
}

class _MyActionsPageState extends State<MyActionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userId = switch (context.watch<AppUserCubit>().state) {
      AppUserLoggedIn(user: var u) => u.id,
      _ => '',
    };
    return MultiBlocListener(
      listeners: [
        BlocListener<ActionsBloc, ActionsState>(
          // On ne déclenche le dialogue QUE si l'état change et contient des actions
          listenWhen: (previous, current) =>
              current is ActionsLoaded &&
              current.mesActions.where((a) => a.isPromotable()).isNotEmpty,
          listener: (context, state) {
            if (state is ActionsLoaded) {
              final promotableActions = state.mesActions
                  .where((a) => a.isPromotable())
                  .toList();

              if (promotableActions.isNotEmpty) {
                final actionBloc = context.read<ActionsBloc>();
                showDialog(
                  context: context,
                  builder: (context) => BlocProvider.value(
                    value: actionBloc,
                    child: PromoteToHabitudeOverlay(
                      promotableActions: promotableActions,
                    ),
                  ),
                );
              }
            }
          },
        ),
      ],
      child: BlocBuilder<ActionsBloc, ActionsState>(
        buildWhen: (previous, current) => current is! ActionsLoading,
        builder: (context, state) {
          if (state is ActionsLoading) {
            return Scaffold(
              backgroundColor: colorScheme.surface,
              body: Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              ),
            );
          }
          if (state is ActionsError) {
            return Scaffold(
              backgroundColor: colorScheme.surface,
              body: Center(
                child: Text(
                  'Erreur : ${state.message}',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            );
          }
          if (state is ActionsLoaded) {
            return Scaffold(
              backgroundColor: colorScheme.surface,
              body: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedBuilder(
                      animation: _tabController.animation!,
                      builder: (context, child) {
                        final color = Color.lerp(
                          colorScheme.primary,
                          colorScheme.tertiary,
                          _tabController.animation!.value,
                        );
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: colorScheme.outline),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            dividerColor: Colors.transparent,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorPadding: EdgeInsets.zero,
                            indicator: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.25,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            labelColor: colorScheme.onPrimary,
                            unselectedLabelColor: colorScheme.onSurfaceVariant,
                            tabs: const [
                              Tab(text: 'Mes actions en cours'),
                              Tab(text: 'Mes habitudes'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        MyActionsTab(
                          activeActions: state.mesActions,
                          onValidate: (actionId) {
                            context.read<ActionsBloc>().add(
                              ValidateActionEvent(
                                userId: userId,
                                actionId: actionId,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Action validée ! Continue comme ça !',
                                ),
                                backgroundColor: colorScheme.primary,
                                duration: const Duration(milliseconds: 1500),
                              ),
                            );
                          },
                          onDelete: (actionId) {
                            context.read<ActionsBloc>().add(
                              RemoveFromMyActionsEvent(
                                userId: userId,
                                actionId: actionId,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Action supprimée de mes actions.',
                                ),
                                backgroundColor: colorScheme.primary,
                                duration: const Duration(milliseconds: 1500),
                              ),
                            );
                          },
                        ),
                        MyHabitudesTab(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
