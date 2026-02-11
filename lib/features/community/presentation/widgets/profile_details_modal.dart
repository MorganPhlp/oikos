import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/leaderboard_entry_model.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';
import '../../../../core/common/presentation/widgets/gradient_button.dart';
import '../../domain/entities/leaderboard_entry.dart';

// Widget de modal pour afficher les détails d'un profil utilisateur ou d'une communauté
class ProfileDetailsModal extends StatefulWidget {
  final LeaderboardEntry entry;

  const ProfileDetailsModal({super.key, required this.entry});

  @override
  State<ProfileDetailsModal> createState() => _ProfileDetailsModalState();
}

class _ProfileDetailsModalState extends State<ProfileDetailsModal> {
  List<LeaderboardEntryModel> _contributors = [];
  bool _isLoadingContributors = true;

  @override
  void initState() {
    super.initState();
    // Si c'est une communauté, on charge ses top membres
    if (!widget.entry.isUser) {
      _loadContributors();
    } else {
      setState(() => _isLoadingContributors = false);
    }
  }

  Future<void> _loadContributors() async {
    final dataSource = CommunityRemoteDataSource(Supabase.instance.client);
    
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

    // Calculs pour les badges dynamiques
    // TODO : Affiner les critères de badges et les seuils
    final int treesPlanted = (entry.value / 1000).floor(); 
    final bool isSuperActive = (entry.actionsCount ?? 0) > 100; // Seuil arbitraire

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        height: 600,
        width: double.infinity, // <--- AJOUT IMPORTANT pour le centrage horizontal
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // --- HEADER GRADIENT ---
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
            
            Positioned(top: 10, right: 10, child: IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => Navigator.of(context).pop())),

            // Bouton Fermer
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // --- CONTENU PRINCIPAL ---
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  Text(
                    entry.label,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    isCommunity ? "Communauté" : "Membre actif",
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatBox(context, Icons.emoji_events, "${entry.value}", "XP Total"),
                      _buildStatBox(context, Icons.flash_on, "${entry.actionsCount}", "Actions"),
                      if (isCommunity)
                        _buildStatBox(context, Icons.group, "${entry.membersCount}", "Membres")
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Titre liste
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
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
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: isCommunity
                          ? _buildFakeCommunityContributors(context)
                          : _buildFakeUserAchievements(context),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GradientButton(
                      label: "Lancer un défi avec ${entry.label}",
                      icon: const Icon(Icons.sports_kabaddi, color: Colors.white),
                      onPressed: () => print("Défi lancé"),
                    ),
                  ),
                ],
              ),
            ),

            // --- AVATAR ---
            Positioned(
              // Calcul: (140 hauteur bandeau - 88 hauteur avatar) / 2 = 26
              top: 26,
              left: 0,
              right: 0,
              child: Center(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
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
      _buildListItem(
        context,
        Icons.lightbulb,
        Colors.yellow,
        "Économe d'énergie",
        "100 kWh économisés",
      ),
    ];
  }

  List<Widget> _buildFakeCommunityContributors(BuildContext context) {
    return [
      _buildListItem(
        context,
        Icons.person,
        Colors.blue,
        "Sophie M.",
        "450 points cette semaine",
      ),
      _buildListItem(
        context,
        Icons.person,
        Colors.red,
        "Thomas D.",
        "420 points cette semaine",
      ),
      _buildListItem(
        context,
        Icons.person,
        Colors.purple,
        "Marie L.",
        "385 points cette semaine",
      ),
    ];
  }

  Widget _buildListItem(
    BuildContext context,
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
