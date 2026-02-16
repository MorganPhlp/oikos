import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:oikos/features/actions_et_defis/data/datasources/action_remote_data_source.dart';
import 'package:oikos/features/actions_et_defis/data/repositories/action_repository_impl.dart';
import 'package:oikos/features/actions_et_defis/presentation/bloc/actions_bloc.dart';
import 'package:oikos/features/actions_et_defis/presentation/pages/my_actions_tab.dart';
import 'package:oikos/core/theme/app_colors.dart';
import '../widgets/actions_header.dart';

class MyActionsPage extends StatelessWidget {
  const MyActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Initialisation
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;
    final dataSource = ActionRemoteDataSourceImpl(supabase);
    final repo = ActionRepositoryImpl(dataSource);

    return BlocProvider(
      create: (_) => ActionsBloc(repository: repo)..add(LoadAllDataEvent(userId)),
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Column(
          children: [
            // L'ENTÊTE
            const ActionsHeader(
              title: " Mes Actions ",      // Le titre change
              subtitle: " ", // Le sous-titre change
              userPoints: 1250,        // Garde la cohérence des points
            ),


            // LE CONTENU (TAB & LISTE)
            Expanded(
              child: BlocBuilder<ActionsBloc, ActionsState>(
                builder: (context, state) {
                  if (state is ActionsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ActionsLoaded) {
                    return MyActionsTab(
                      challenges: state.mesDefis,

                      // Validation simple (pas encore terminé)
                      onValidate: (actionId) async {
                        await repo.validateAction(userId, actionId, 10, 0.5);

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Action validée ! Continue comme ça ! 🌱"),
                              backgroundColor: Colors.green,
                              duration: Duration(milliseconds: 1500),
                            )
                        );
                      },

                      // Suppression
                      onDelete: (actionId) async {
                        await repo.removeChallenge(userId, actionId);
                        // ignore: use_build_context_synchronously
                        context.read<ActionsBloc>().add(LoadAllDataEvent(userId));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Défi arrêté."))
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