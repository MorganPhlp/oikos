import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/actions/presentation/bloc/actions_event.dart';
import 'package:oikos/features/actions/presentation/bloc/habitudes_cubit.dart';
import 'package:oikos/features/actions/presentation/pages/my_habitudes_tab.dart';
import 'package:oikos/features/actions/presentation/widgets/congrats_action_bonus_complete.dart';
import 'package:oikos/features/actions/presentation/widgets/promote_to_habitude_popup.dart';
import '../bloc/actions_bloc.dart';
import '../bloc/actions_state.dart';
import 'my_actions_tab.dart';
import '../../domain/entities/user_active_action_entity.dart';

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
          listenWhen: (previous, current) =>
              current is ActionsLoaded &&
              current.mesActions.where((a) => a.isCompleted()).isNotEmpty,
          listener: (context, state) async {
            if (state is ActionsLoaded) {
              final promotableActions = state.mesActions
                  .where((a) => a.isPromotable())
                  .toList();
              final actionBloc = context.read<ActionsBloc>();
              final habitudeCubit = context.read<HabitudeCubit>();

              if (promotableActions.isNotEmpty) {
                await showDialog(
                  context: context,
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: actionBloc),
                      BlocProvider.value(value: habitudeCubit),
                    ],
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
                              Tab(text: 'Mon mode de vie'),
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
                          limiteActionsFreq: state.limiteActionsFreq,
                          onValidate: (userActiveAction) {
                            _validateAction(context, userActiveAction);
                          },
                          onDelete: (userActiveAction) {
                            context.read<ActionsBloc>().add(
                              RemoveFromMyActionsEvent(
                                userId: userId,
                                actionId: userActiveAction.action.id,
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

  void _validateAction(
    BuildContext context,
    UserActiveActionEntity userActiveAction,
  ) {
    final userId = switch (context.read<AppUserCubit>().state) {
      AppUserLoggedIn(user: var u) => u.id,
      _ => '',
    };
    final actionBloc = context.read<ActionsBloc>();
    context.read<ActionsBloc>().add(
      ValidateActionEvent(userId: userId, actionId: userActiveAction.action.id),
    );
    // afficher les actions bonus validees
    if (userActiveAction.action.frequency.toLowerCase() == 'bonus') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => BlocProvider.value(
          value: actionBloc,
          child: CongratsActionBonusComplete(
            activeAction: userActiveAction.copyWith(
              streakCount: userActiveAction.streakCount + 1,
            ),
          ),
        ),
      );
    }
  }
}
