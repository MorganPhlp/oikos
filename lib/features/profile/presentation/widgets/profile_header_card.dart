import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';

import 'avatar_modal.dart';

class ProfileHeaderCard extends StatelessWidget {
  // TODO : Connecter ces valeurs au Cubit ou BilanBloc si nécessaire
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        final user = (state is AppUserLoggedIn) ? state.user : null;
        final userName =
            user?.pseudo ?? user?.email.split('@')[0] ?? 'Utilisateur';
        final userEmail = user?.email ?? '';
        final communityName =
            'Ma Communauté'; // TODO : A récupérer depuis le profil utilisateur
        final currentAvatar = user?.avatar ?? 'assets/avatars/avatar_1.png';

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(
                  alpha: 0.08,
                ), // Ombre légèrement verte
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Zone supérieure avec léger dégradé vert
              Container(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.05),
                      colorScheme.surface,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar avec badge d'édition
                    GestureDetector(
                      onTap: () {
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
                            },
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 2,
                              ), // Bordure verte plus marquée
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                currentAvatar,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    LucideIcons.user,
                                    size: 40,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.3,
                                    ),
                                  );
                                }
                              ),
                            )
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                LucideIcons.camera,
                                size: 14,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      userName,
                      style: AppTypography.h2.copyWith(fontSize: 22),
                    ),
                    Text(
                      userEmail,
                      style: AppTypography.body.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Zone inférieure (Communauté + Tabs)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    // Tag Communauté
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(
                          alpha: 0.05,
                        ), // Fond vert très léger
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        ), // Bordure verte fine
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.users,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            communityName,
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: colorScheme.primary, // Texte vert
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tabs Profil / Stats
                    _buildTabs(context, colorScheme),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabs(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(
          alpha: 0.08,
        ), // Fond du container de tabs légèrement vert
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.user, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Profil',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w700, // Plus gras
                      fontSize: 14,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                // TODO: Navigation vers le Dashboard
                // context.pushNamed('dashboard');
              },
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.barChart3,
                      size: 18,
                      color: colorScheme.primary.withValues(
                        alpha: 0.5,
                      ), // Vert inactif
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Statistiques',
                      style: AppTypography.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary.withValues(
                          alpha: 0.5,
                        ), // Vert inactif
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
