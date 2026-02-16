import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/profile/presentation/bloc/profile_bilan_cubit.dart';
import 'package:oikos/features/profile/presentation/bloc/profile_bilan_state.dart';
import 'package:oikos/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:oikos/init_dependencies.dart';

class ProfileBilanSection extends StatelessWidget {

  const ProfileBilanSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String userId = context.read<AppUserCubit>().state is AppUserLoggedIn
        ? (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id
        : '';

    return BlocProvider(
      create: (context) => serviceLocator<ProfileBilanCubit>()
        ..updateQuestionsRestantes(userId),
      child: BlocBuilder<ProfileBilanCubit, ProfileBilanState>(
        builder: (context, state) {
          final remainingQuestions = state.questionsRestantes;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (remainingQuestions > 0)
                      ProfileActionButton(
                        title: 'Compléter mon bilan',
                        subtitle:  '$remainingQuestions questions restantes',
                        icon: LucideIcons.checkSquare,
                        iconColor: colorScheme.primary,
                        onTap: () {
                          context.go('/bilan', extra: 'continuer');
                        },
                        showBorder: true,
                      ),
                      ProfileActionButton(
                        title: 'Modifier mon bilan',
                        subtitle: 'Prêt pour un nouveau départ ?',
                        icon: LucideIcons.rotateCcw,
                        iconColor: colorScheme.tertiary,
                        onTap: () {
                          context.go('/bilan', extra: 'modifier');
                        },
                        showBorder: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ProfileActionButton(
                  title: 'Actions écartées',
                  icon: LucideIcons.ban,
                  iconColor: colorScheme.onSurface.withValues(alpha: 0.5),
                  onTap: () {
                    // TODO: Modale actions écartées
                  },
                  showBorder: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}