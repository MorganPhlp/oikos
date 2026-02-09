import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:oikos/features/profile/presentation/widgets/update_pseudo_modal.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'avatar_modal.dart';

class ProfileAccountSection extends StatelessWidget {
  const ProfileAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'Paramètres du compte',
            style: AppTypography.h2.copyWith(
                color: colorScheme.primary,
                fontSize: 18
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.05), // Ombre très légère verte
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              ProfileActionButton(
                title: 'Modifier le pseudo',
                icon: LucideIcons.pencil,
                // L'icône sera verte par défaut grâce au widget ProfileActionButton
                onTap: () {
                  // Récupération du pseudo actuel
                  final currentState = context.read<AppUserCubit>().state;
                  final currentPseudo = (currentState is AppUserLoggedIn) ?
                      currentState.user.pseudo : 'Utilisateur';

                  // Ouverture du modal
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => UpdatePseudoModal(
                        currentPseudo: currentPseudo,
                        onPseudoValidated: (newPseudo) {
                          context.read<AuthBloc>().add(
                            AuthUpdateUser(pseudo: newPseudo)
                          );
                        },
                      ),
                  );
                },
              ),
              // Tous les autres boutons d'action du compte
              ProfileActionButton(
                title: 'Email & Sécurité',
                icon: LucideIcons.lock,
                onTap: () {}, // TODO
              ),
              ProfileActionButton(
                title: 'Statut',
                subtitle: 'Actif', // TODO: À dynamiser
                icon: LucideIcons.power,
                iconColor: const Color(0xFF4CAF50),
                onTap: () {}, // TODO
              ),
              ProfileActionButton(
                title: 'Notifications',
                icon: LucideIcons.bell,
                onTap: () {}, // TODO
              ),
              ProfileActionButton(
                title: 'Modifier l\'avatar',
                icon: LucideIcons.smile,
                onTap: () {
                  // Récupération de l'avatar actuel
                  final currentState = context.read<AppUserCubit>().state;
                  final currentAvatar = (currentState is AppUserLoggedIn) ?
                    (currentState.user.avatar ?? 'assets/avatars/avatar1.png') : 'assets/avatars/avatar1.png';

                  // Ouverture du modal
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AvatarModal(
                      currentAvatar: currentAvatar,
                      onAvatarSelected: (newAvatar) {
                        context.read<AuthBloc>().add(
                          AuthUpdateUser(avatar: newAvatar)
                        );
                      }
                    ),
                  );
                },
              ),
              ProfileActionButton(
                title: 'Centres d\'intérêt',
                icon: LucideIcons.tag,
                onTap: () {}, // TODO
                showBorder: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}