import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';
import '../../../../core/common/presentation/widgets/gradient_button.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/leaderboard_entry_model.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../widgets/setup_duel_modal.dart';

class ProfileDetailsModal extends StatefulWidget {
  final LeaderboardEntry entry;
  final String myCommunityCode;
  final String entrepriseId;

  const ProfileDetailsModal({super.key, required this.entry, required this.myCommunityCode, required this.entrepriseId});

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
    final dataSource = CommunityRemoteDataSource(Supabase.instance.client);
    // Utilise l'ID de l'entry pour charger les membres de cette communauté
    final users = await dataSource.getCommunityTopContributors(widget.entry.id); 
    
    if (mounted) {
      setState(() {
        _contributors = users;
        _isLoadingContributors = false;
      });
    }
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
        constraints: const BoxConstraints(maxHeight: 650), // Utilise maxHeight plutôt qu'une hauteur fixe
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
                  colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
            ),
            
            // Bouton Fermer (Unique)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // Contenu principal scrollable
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60), // Espace pour l'avatar qui dépasse

                    Text(
                      entry.label,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      isCommunity ? "Communauté" : "Membre actif",
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                    ),
                    const SizedBox(height: 24),

                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatBox(context, Icons.emoji_events, "${entry.value}", "XP Total"),
                        _buildStatBox(context, Icons.flash_on, "${entry.actionsCount}", "Action(s)"),
                        if (isCommunity)
                          _buildStatBox(context, Icons.group, "${entry.membersCount}", "Membre(s)"),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Titre (Contributeurs ou Réalisations)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(Icons.bookmark_border, size: 20, color: AppColors.lightPrimary),
                          const SizedBox(width: 8),
                          Text(
                            isCommunity ? "Top contributeurs" : "Réalisations récentes",
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Liste dynamique
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: isCommunity
                          ? _buildContributorsList(context)
                          : Column(children: _buildFakeUserAchievements(context)),
                    ),
                    if (isCommunity)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: GradientButton(
                          label: "Lancer un défi à ${entry.label}",
                          icon: const Icon(Icons.sports_kabaddi, color: Colors.white),
                          onPressed: () {
                            // 1. Fermer le profil actuel
                            Navigator.pop(context);

                            // 2. Ouvrir la configuration du duel
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => SetupDuelModal(
                                targetCommunity: entry as LeaderboardEntryModel, // L'entrée actuelle est l'adversaire
                                myCommunityCode: widget.myCommunityCode,
                                entrepriseId: widget.entrepriseId,
                              ),
                            );
                          },
                        ),
                      ),
                      
                    // Espacement si c'est un profil utilisateur (pas de bouton)
                    if (!isCommunity)
                      const SizedBox(height: 20),
                  ]
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

  Widget _buildContributorsList(BuildContext context) {
    if (_isLoadingContributors) {
      return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
    }
    if (_contributors.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: Text("Aucun membre actif pour le moment.", style: TextStyle(color: Colors.grey)),
      );
    }
    return Column(
      children: _contributors.map((u) => _buildListItem(
        context,
        Icons.person,
        Colors.blue,
        u.label,
        "${u.value} XP",
        avatarUrl: u.avatarUrl,
      )).toList(),
    );
  }

  Widget _buildStatBox(BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  List<Widget> _buildFakeUserAchievements(BuildContext context) {
    return [
      _buildListItem(context, Icons.directions_bike, Colors.green, "Champion du vélo", "30 jours consécutifs"),
      _buildListItem(context, Icons.restaurant, Colors.orange, "Végé-warrior", "50 repas végé"),
      _buildListItem(context, Icons.lightbulb, Colors.yellow, "Économe d'énergie", "100 kWh économisés"),
    ];
  }

  Widget _buildListItem(BuildContext context, IconData icon, Color color, String title, String subtitle, {String? avatarUrl}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: avatarUrl != null && avatarUrl.isNotEmpty
                ? OikosAvatar(avatarUrl: avatarUrl, label: title, radius: 20)
                : Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}