import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/features/community/domain/entities/community_entity.dart';
import 'package:oikos/features/community/domain/use_cases/lancer_defi.dart';
import 'package:oikos/features/community/presentation/bloc/defis_cubit.dart';
import 'package:oikos/features/community/presentation/bloc/defis_state.dart';
import 'setup_duel_modal.dart';
import '../../data/models/leaderboard_entry_model.dart';

class RankingActionModal extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final bool isCommunity;
  final VoidCallback onSeeProfile;
  final VoidCallback onDuel;
  final LeaderboardEntryModel targetCommunity;
  final String myCommunityCode;
  final String entrepriseId;
  final String?
  currentUserId; // Injecté par le parent pour éviter ProviderNotFound

  const RankingActionModal({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.isCommunity,
    required this.onSeeProfile,
    required this.onDuel,
    required this.targetCommunity,
    required this.myCommunityCode,
    required this.entrepriseId,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    print(targetCommunity);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.gradientGreenStart,
                    AppColors.gradientGreenEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: OikosAvatar(avatarUrl: avatarUrl, label: name, radius: 32),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCommunity ? Icons.groups_outlined : Icons.person_outline,
                  size: 16,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 4),
                Text(
                  isCommunity ? "Communauté" : "Utilisateur",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: onSeeProfile,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Voir le profil",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GradientButton(
              label: "Lance un défi",
              icon: const Icon(Icons.flash_on, color: Colors.white, size: 20),
              onPressed: () {
                // 1. CAPTURE : On récupère tout ce dont on a besoin AVANT le pop
                final navigator = Navigator.of(
                  context,
                ); // Le navigator du dashboard
                final defisCubit = context.read<DefisCubit>();
                final defiState = defisCubit.state;

                final userState = context.read<AppUserCubit>().state;
                final String? userId = userState is AppUserLoggedIn
                    ? userState.user.id
                    : currentUserId;

                final CommunityEntity? targetCommunityEntity =
                    switch (defiState) {
                      DefisLoaded(adversaries: final ads) =>
                        ads.cast<CommunityEntity?>().firstWhere(
                          (c) =>
                              c?.code.toLowerCase() ==
                              targetCommunity.id.toLowerCase(),
                          orElse: () => null,
                        ),
                      _ => null,
                    };

                // Si on ne trouve pas l'entité, on ne ferme même pas pour pouvoir débugger
                if (targetCommunityEntity == null || userId == null) {
                  return;
                }

                // 2. FERMETURE : On ferme le Dialog
                navigator.pop();

                // 3. OUVERTURE : On utilise le navigator capturé pour ouvrir le BottomSheet
                // On utilise rootNavigator: false pour rester dans le flow de l'app
                showModalBottomSheet(
                  context: navigator
                      .context, // <--- On utilise le contexte du Navigator parent
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (modalContext) => BlocProvider.value(
                    value: defisCubit,
                    child: SetupDuelModal(
                      targetCommunity: targetCommunityEntity,
                      myCommunity: myCommunityCode,
                      userId: userId,
                      onConfirm: (category, duration, creatorId) {
                        defisCubit.proposeDuel(
                          LancerDefiParams(
                            userId: creatorId,
                            targetCommunityCode: targetCommunityEntity.code,
                            categorieNom: category,
                            durationDays: duration,
                          ),
                          myCommunityCode,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Annuler",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
