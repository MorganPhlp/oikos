import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';
import '../../domain/entities/leaderboard_entry.dart';

class ProfileDetailsModal extends StatelessWidget {
  final LeaderboardEntry entry;

  const ProfileDetailsModal({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final bool isCommunity = !entry.isUser;
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        height: 600,
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

            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // --- CONTENU PRINCIPAL ---
            Positioned.fill(
              top: 80,
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
                      _buildStatBox(context, Icons.emoji_events, "${entry.value}", "Points"),
                      _buildStatBox(context, Icons.flash_on, "${entry.actionsCount ?? 0}", "Actions"),
                      _buildStatBox(context, Icons.trending_down, entry.impactStats ?? "0kg", "Réduction"),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.bookmark_border, size: 20, color: AppColors.lightPrimary),
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
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          print("Duel lancé");
                        },
                        icon: const Icon(Icons.sports_kabaddi),
                        label: Text("Lancer un duel avec ${entry.label}"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- AVATAR AVEC OIKOSAVATAR ---
            Positioned(
              top: 70,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                // Ici on utilise notre widget robuste
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

  Widget _buildStatBox(BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.lightPrimary, size: 24),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  List<Widget> _buildFakeCommunityContributors(BuildContext context) {
    return [
      _buildListItem(context, Icons.person, Colors.blue, "Sophie M.", "450 points cette semaine"),
      _buildListItem(context, Icons.person, Colors.red, "Thomas D.", "420 points cette semaine"),
      _buildListItem(context, Icons.person, Colors.purple, "Marie L.", "385 points cette semaine"),
    ];
  }

  Widget _buildListItem(BuildContext context, IconData icon, Color color, String title, String subtitle) {
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
          )
        ],
      ),
    );
  }
}