import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Imports Core & Theme
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';

// Imports Features
import 'package:oikos/features/community/domain/entities/community_entity.dart';
import 'package:oikos/features/community/domain/entities/leaderboard_entry.dart';
import 'package:oikos/features/community/domain/use_cases/lancer_defi.dart';
import 'package:oikos/features/community/presentation/bloc/defis_cubit.dart';
import 'package:oikos/features/community/data/models/leaderboard_entry_model.dart';
import 'package:oikos/features/community/data/datasources/community_remote_datasource.dart';
import 'package:oikos/features/community/presentation/widgets/setup_duel_modal.dart';

class ProfileDetailsModal extends StatefulWidget {
  final LeaderboardEntry entry;
  final String myCommunityCode;
  final String entrepriseId;

  const ProfileDetailsModal({
    super.key,
    required this.entry,
    required this.myCommunityCode,
    required this.entrepriseId,
  });

  @override
  State<ProfileDetailsModal> createState() => _ProfileDetailsModalState();
}

class _ProfileDetailsModalState extends State<ProfileDetailsModal> {
  List<LeaderboardEntryModel> _contributors = [];
  bool _isLoadingContributors = true;

  @override
  void initState() {
    super.initState();
    if (!widget.entry.isUser) {
      _loadContributors();
    } else {
      setState(() => _isLoadingContributors = false);
    }
  }

  Future<void> _loadContributors() async {
    try {
      final dataSource = CommunityRemoteDataSource(Supabase.instance.client);
      final users = await dataSource.getCommunityTopContributors(
        widget.entry.id,
      );
      if (mounted) {
        setState(() {
          _contributors = users;
          _isLoadingContributors = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingContributors = false);
    }
  }

  /// Logique pour lancer le duel
  void _handleDuelLaunch(BuildContext context) {
    // 1. On récupère l'utilisateur connecté
    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) return;

    final currentUser = userState.user;

    // 2. On prépare l'entité de la communauté cible
    final targetCommunity = CommunityEntity(
      nom: widget.entry.label,
      code: widget.entry.id, // ID du leaderboard utilisé comme code
      entrepriseId: widget.entrepriseId,
      couleurHEX: '',
    );

    // 3. Fermer le profil
    Navigator.pop(context);

    // 4. Ouvrir le SetupDuelModal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => SetupDuelModal(
        targetCommunity: targetCommunity,
        myCommunity: currentUser.communityCode,
        userId: currentUser.id,
        onConfirm: (category, duration, creatorId) {
          // Déclenche l'appel API via le Cubit
          context.read<DefisCubit>().proposeDuel(
            LancerDefiParams(
              userId: creatorId,
              targetCommunityCode: targetCommunity.code,
              categorieNom: category,
              durationDays: duration,
            ),
            currentUser.communityCode,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final bool isCommunity = !entry.isUser;
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 650),
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Header dégradé
            Container(
              height: 140,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.gradientGreenStart,
                    AppColors.gradientGreenEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
            ),

            // Bouton Fermer
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // Contenu
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      entry.label,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isCommunity ? "Communauté" : "Membre actif",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatBox(
                          context,
                          Icons.emoji_events,
                          "${entry.value}",
                          "XP Total",
                        ),
                        _buildStatBox(
                          context,
                          Icons.flash_on,
                          "${entry.actionsCount}",
                          "Action(s)",
                        ),
                        if (isCommunity)
                          _buildStatBox(
                            context,
                            Icons.group,
                            "${entry.membersCount}",
                            "Membre(s)",
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Dynamique
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bookmark_border,
                            size: 20,
                            color: AppColors.lightPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isCommunity
                                ? "Top contributeurs"
                                : "Réalisations récentes",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: isCommunity
                          ? _buildContributorsList(context)
                          : Column(
                              children: _buildFakeUserAchievements(context),
                            ),
                    ),

                    if (isCommunity)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: GradientButton(
                          label: "Lancer un défi à ${entry.label}",
                          icon: const Icon(
                            Icons.sports_kabaddi,
                            color: Colors.white,
                          ),
                          onPressed: () => _handleDuelLaunch(context),
                        ),
                      ),

                    if (!isCommunity) const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Avatar flottant
            Positioned(
              top: 26,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: OikosAvatar(
                  avatarUrl: entry.avatarUrl,
                  label: entry.label,
                  radius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helpers UI ---

  Widget _buildContributorsList(BuildContext context) {
    if (_isLoadingContributors) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_contributors.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Aucun membre actif.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return Column(
      children: _contributors
          .map(
            (u) => _buildListItem(
              context,
              Icons.person,
              Colors.blue,
              u.label,
              "${u.value} XP",
              avatarUrl: u.avatarUrl,
            ),
          )
          .toList(),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.lightPrimary, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  List<Widget> _buildFakeUserAchievements(BuildContext context) {
    return [
      _buildListItem(
        context,
        Icons.directions_bike,
        Colors.green,
        "Champion du vélo",
        "30 jours consécutifs",
      ),
      _buildListItem(
        context,
        Icons.restaurant,
        Colors.orange,
        "Végé-warrior",
        "50 repas végé",
      ),
    ];
  }

  Widget _buildListItem(
    BuildContext context,
    IconData icon,
    Color color,
    String title,
    String subtitle, {
    String? avatarUrl,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.lightInputBorder.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          OikosAvatar(avatarUrl: avatarUrl ?? '', label: title, radius: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
