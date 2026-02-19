import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../bloc/actions_bloc.dart';
import '../bloc/actions_event.dart';
import '../bloc/actions_state.dart';
import '../pages/my_actions_tab.dart';

class MyActionsPage extends StatelessWidget {
  const MyActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userId = context.read<AppUserCubit>().state is AppUserLoggedIn
        ? (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id
        : '';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ActionsBloc, ActionsState>(
              buildWhen: (previous, current) => current is! ActionsLoading,
              builder: (context, state) {
                if (state is ActionsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  );
                }

                if (state is ActionsLoaded) {
                  return MyActionsTab(
                    activeActions: state.mesActions,
                    onValidate: (actionId, xp) {
                      context.read<ActionsBloc>().add(
                        ValidateActionEvent(
                          userId: userId,
                          actionId: actionId,
                          xp: xp,
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
                          content: const Text('Action retirée.'),
                          backgroundColor: colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      );
                    },
                  );
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
}
