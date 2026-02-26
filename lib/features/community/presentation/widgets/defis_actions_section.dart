import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/community/data/models/community_model.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/domain/use_cases/lancer_defi.dart';
import 'package:oikos/features/community/presentation/bloc/defis_cubit.dart';
import 'package:oikos/features/community/presentation/bloc/defis_state.dart';
import 'package:oikos/features/community/presentation/pages/community_selection_screen.dart';
import 'package:oikos/features/community/presentation/widgets/defi_list_widget.dart';
import 'package:oikos/features/community/presentation/widgets/pending_defis_widget.dart';
import 'package:oikos/features/community/presentation/widgets/setup_duel_modal.dart';

class DefisActionsSection extends StatelessWidget {
  final VoidCallback onCommunityActionsTap;
  const DefisActionsSection({super.key, required this.onCommunityActionsTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userState = context.watch<AppUserCubit>().state;

    return BlocBuilder<DefisCubit, DefisState>(
      builder: (context, state) {
        if (state is DefisLoaded) {
          final activeDefis = state.defis.activeDefis;
          final hasActive = activeDefis.isNotEmpty;
          final hasPending = state.defis.pendingDefis.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION DÉFIS ACTIFS ---
              if (hasActive) ...[
                _buildSectionTitle(theme, Icons.bolt, "Défis actifs"),
                DefiListWidget(
                  defis: state.defis,
                  onValidate: (defiId) {
                    if (userState is AppUserLoggedIn) {
                      context.read<DefisCubit>().validateDefi(
                        defiId,
                        userState.user.id,
                        userState.user.communityCode,
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],

              // --- SECTION DÉFIS EN ATTENTE (VOTES) ---
              if (hasPending) ...[
                _buildSectionTitle(theme, Icons.pending, "Défis en attente"),
                PendingDefisWidget(
                  defis: state.defis.pendingDefis,
                  votes: state.votes ?? [],
                  participations: state.participations ?? [],
                  onVote: (defiId, isFavorable) {
                    if (userState is AppUserLoggedIn) {
                      context.read<DefisCubit>().voteForDefiLaunch(
                        defiId: defiId,
                        userId: userState.user.id,
                        isFavorable: isFavorable,
                        communityCode: userState.user.communityCode,
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],

              // --- SECTION ACTIONS COMMUNAUTAIRES (TOUJOURS VISIBLE) ---
              _buildSectionTitle(
                theme,
                Icons.flash_on,
                "Défis et actions communautaires",
              ),
              const SizedBox(height: 8),
              _ChallengeCard(
                title: "Propose un défi",
                subtitle: "Affronte une autre équipe",
                icon: Icons.flash_on,
                color: theme.colorScheme.primary,
                onTap: () => _handleProposeDuel(context, userState, state),
              ),
              const SizedBox(height: 12),
              _ChallengeCard(
                title: "Actions communautaires",
                subtitle: "Lance-toi dans un défi collectif",
                icon: Icons.emoji_events,
                color: theme.colorScheme.tertiary,
                onTap: onCommunityActionsTap,
              ),
            ],
          );
        } else if (state is DefisError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Erreur : ${state.message}",
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  // Méthode extraite pour la lisibilité
  Future<void> _handleProposeDuel(
    BuildContext context,
    AppUserState userState,
    DefisLoaded state,
  ) async {
    if (userState is! AppUserLoggedIn) return;
    final currentUser = userState.user;

    final selectedCommunity = await Navigator.push<CommunityModel>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CommunitySelectionScreen(communities: state.adversaries),
      ),
    );

    if (selectedCommunity != null && context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (modalContext) => SetupDuelModal(
          targetCommunity: selectedCommunity,
          myCommunity: currentUser.communityCode,
          userId: currentUser.id,
          onConfirm: (category, duration, creatorId) {
            context.read<DefisCubit>().proposeDuel(
              LancerDefiParams(
                userId: creatorId,
                targetCommunityCode: selectedCommunity.code,
                categorieNom: category,
                durationDays: duration,
              ),
              currentUser.communityCode,
            );
          },
        ),
      );
    }
  }

  Widget _buildSectionTitle(ThemeData theme, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ChallengeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.hintColor.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
