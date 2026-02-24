import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/community/data/datasources/community_remote_datasource.dart';
import 'package:oikos/features/community/domain/entities/leaderboard_entry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'avatar_modal.dart';

class ProfileHeaderCard extends StatefulWidget {
  const ProfileHeaderCard({super.key});

  @override
  State<ProfileHeaderCard> createState() => _ProfileHeaderCardState();
}

class _ProfileHeaderCardState extends State<ProfileHeaderCard> {
  LeaderboardEntry? _communityInfo;
  bool _isLoadingCommunity = true;

  @override
  void initState() {
    super.initState();
    _loadCommunityInfo();
  }

  Future<void> _loadCommunityInfo() async {
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      final communityCode = userState.user.communityCode;
      if (communityCode.isNotEmpty) {
        final dataSource = CommunityRemoteDataSource(Supabase.instance.client);
        try {
          final info = await dataSource.getCommunityDetails(communityCode);
          if (mounted) {
            setState(() {
              _communityInfo = info;
              _isLoadingCommunity = false;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _isLoadingCommunity = false;
            });
          }
        }
      } else {
        setState(() {
          _isLoadingCommunity = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        final user = (state is AppUserLoggedIn) ? state.user : null;
        final userName =
            user?.pseudo ?? user?.email.split('@')[0] ?? 'Utilisateur';
        final userEmail = user?.email ?? '';
        final currentAvatar = user?.avatar ?? 'assets/avatars/avatar_1.png';

        // Récupération des infos de la communauté
        final communityName = _communityInfo?.label ?? 'Ma Communauté';
        final communityLogo = _communityInfo?.avatarUrl;

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
                                AuthUpdateUser(avatar: newAvatar),
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
                                },
                              ),
                            ),
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
                          // Logo de la communauté (si disponible)
                          if (communityLogo != null && communityLogo.isNotEmpty) ...[
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.primary.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  communityLogo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      LucideIcons.users,
                                      size: 12,
                                      color: colorScheme.primary,
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: SizedBox(
                                        width: 10,
                                        height: 10,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ] else ...[
                            Icon(
                              LucideIcons.users,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                          ],
                          // Nom de la communauté avec gestion du débordement
                          Flexible(
                            child: Text(
                              _isLoadingCommunity ? 'Chargement...' : communityName,
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: colorScheme.primary, // Texte vert
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
