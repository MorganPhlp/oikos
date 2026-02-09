import 'package:flutter/material.dart';
import '../../domain/entities/leaderboard_entry.dart';

class ProfileDetailsModal extends StatelessWidget {
  final LeaderboardEntry entry;

  const ProfileDetailsModal({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCommunity = !entry.isUser;
    
    // Couleurs locales pour ce widget
    final greenHeader = const Color(0xFF81C784); // Vert clair du header
    final greenButton = const Color(0xFFAED581); // Vert bouton
    final textDark = const Color(0xFF37401C);

    return Dialog(
      backgroundColor: Colors.transparent, // Important pour le design custom
      insetPadding: const EdgeInsets.all(16), // Marge autour de la fenêtre
      child: Container(
        height: 600, // Hauteur fixe ou utilise constraints
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // --- 1. Header Vert ---
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: greenHeader,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
            ),

            // --- 2. Bouton Fermer (X) ---
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // --- 3. Contenu Principal (Scrollable) ---
            Positioned.fill(
              top: 80, // On commence sous le header pour laisser la place à l'avatar
              child: Column(
                children: [
                  // Espace pour l'avatar (il est géré par le Stack, mais on pousse le contenu)
                  const SizedBox(height: 60),

                  // Nom & Titre
                  Text(
                    entry.label,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textDark),
                  ),
                  Text(
                    isCommunity ? "Communauté" : "Membre actif",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Stats (3 blocs)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatBox(Icons.emoji_events, "${entry.value}", "Points"),
                      _buildStatBox(Icons.flash_on, "${entry.actionsCount ?? 0}", "Actions"),
                      _buildStatBox(Icons.trending_down, entry.impactStats ?? "0kg", "Réduction"),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // Titre de la liste
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.bookmark_border, size: 20, color: textDark),
                          const SizedBox(width: 8),
                          Text(
                            isCommunity ? "Top contributeurs" : "Réalisations récentes",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  // Liste scrollable des réalisations
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: isCommunity 
                        ? _buildFakeCommunityContributors() 
                        : _buildFakeUserAchievements(),
                    ),
                  ),

                  // Bouton Lancer un duel (Sticky bottom)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                           // Logique de duel ici
                           print("Duel lancé depuis le profil complet");
                        },
                        icon: const Icon(Icons.sports_kabaddi),
                        label: Text("Lancer un duel avec ${entry.label}"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenButton,
                          foregroundColor: textDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 4. L'Avatar (Qui chevauche) ---
            Positioned(
              top: 70, // Position calculée pour être à cheval sur le vert et le blanc
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: isCommunity ? Colors.green.shade100 : const Color(0xFFBDEE63),
                  backgroundImage: (entry.avatarUrl != null && entry.avatarUrl!.isNotEmpty)
                      ? NetworkImage(entry.avatarUrl!)
                      : null,
                  child: (entry.avatarUrl == null || entry.avatarUrl!.isEmpty)
                      ? Text(entry.label[0], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black54))
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper pour les boites de stats
  Widget _buildStatBox(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF65BA74), size: 24),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // Fausses données pour simuler la liste des réalisations (comme sur tes screens)
  List<Widget> _buildFakeUserAchievements() {
    return [
      _buildListItem(Icons.directions_bike, Colors.green, "Champion du vélo", "30 jours consécutifs"),
      _buildListItem(Icons.restaurant, Colors.orange, "Végé-warrior", "50 repas végé"),
      _buildListItem(Icons.lightbulb, Colors.yellow, "Économe d'énergie", "100 kWh économisés"),
    ];
  }

  List<Widget> _buildFakeCommunityContributors() {
     return [
      _buildListItem(Icons.person, Colors.blue, "Sophie M.", "450 points cette semaine"),
      _buildListItem(Icons.person, Colors.red, "Thomas D.", "420 points cette semaine"),
      _buildListItem(Icons.person, Colors.purple, "Marie L.", "385 points cette semaine"),
    ];
  }

  Widget _buildListItem(IconData icon, Color color, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}