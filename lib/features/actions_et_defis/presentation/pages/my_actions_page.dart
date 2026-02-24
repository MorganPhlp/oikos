import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:oikos/features/actions_et_defis/data/datasources/action_remote_data_source.dart';
import 'package:oikos/features/actions_et_defis/data/repositories/action_repository_impl.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/actions_bloc.dart';
import 'package:oikos/features/actions_et_defis/presentation/pages/my_actions_tab.dart';

class MyActionsPage extends StatefulWidget {
  const MyActionsPage({super.key});

  @override
  State<MyActionsPage> createState() => _MyActionsPageState();
}

class _MyActionsPageState extends State<MyActionsPage> {
  late final String userId;
  late final ActionRepositoryImpl repo;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    userId = supabase.auth.currentUser!.id;
    final dataSource = ActionRemoteDataSourceImpl(supabase);
    repo = ActionRepositoryImpl(dataSource);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => ActionsBloc(repository: repo)..add(LoadAllDataEvent(userId)),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ActionsBloc, ActionsState>(
                builder: (context, state) {
                  if (state is ActionsLoading) {
                    return Center(child: CircularProgressIndicator(color: colors.primary));
                  }

                  if (state is ActionsLoaded) {
                    return MyActionsTab(
                      challenges: state.mesDefis,

                      // Validation action et refresh
                      onValidate: (actionId) async {
                        await repo.validateAction(userId, actionId, 10, 0.5);
                        if (!context.mounted) return;
                        context.read<ActionsBloc>().add(LoadAllDataEvent(userId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Action validée !", style: TextStyle(color: colors.onPrimary)),
                              backgroundColor: colors.primary,
                              duration: const Duration(milliseconds: 1500)
                          ),
                        );
                      },

                      // Passage en mode lifestyle
                      onSetLifestyle: (actionId, isLifestyle) async {
                        await repo.setLifestyle(userId, actionId, isLifestyle);
                        if (!context.mounted) return;
                        context.read<ActionsBloc>().add(LoadAllDataEvent(userId));
                      },

                      // Suppression d'un défi
                      onDelete: (actionId) async {
                        await repo.removeChallenge(userId, actionId);
                        if (!context.mounted) return;
                        context.read<ActionsBloc>().add(LoadAllDataEvent(userId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Défi arrêté.", style: TextStyle(color: colors.onSurface)), backgroundColor: colors.surface),
                        );
                      },

                      // Logique bonus : remove et refresh pour retour catalogue
                      onCompleteBonus: (actionId) async {
                        await repo.removeChallenge(userId, actionId);
                        if (!context.mounted) return;

                        context.read<ActionsBloc>().add(LoadAllDataEvent(userId));

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Bonus terminé ! Bien joué !", style: TextStyle(color: colors.onPrimary)),
                              backgroundColor: colors.primary
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}