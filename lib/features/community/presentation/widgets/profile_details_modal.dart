import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/leaderboard_entry_model.dart';
import '../../domain/entities/leaderboard_entry.dart';

// Widget de modal pour afficher les détails d'un profil utilisateur ou d'une communauté
class ProfileDetailsModal extends StatefulWidget {
  final LeaderboardEntry entry;

  const ProfileDetailsModal({Key? key, required this.entry}) : super(key: key);

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
    
    // Couleurs
    final greenHeader = isCommunity ? const Color(0xFFA5D6A7) : const Color(0xFF81C784);
    final greenButton = const Color(0xFFAED581);
    final textDark = const Color(0xFF37401C);

    // Calculs pour les badges dynamiques
    // TODO : Affiner les critères de badges et les seuils
    final int treesPlanted = (entry.value / 1000).floor(); 
    final bool isSuperActive = (entry.actionsCount ?? 0) > 100; // Seuil arbitraire

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        height: 650, 
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Header
            Container(
              height: 140,
              decoration: BoxDecoration(color: greenHeader, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
            ),
            
            Positioned(top: 10, right: 10, child: IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => Navigator.of(context).pop())),

            Positioned.fill(
              top: 80,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  Text(entry.label, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textDark)),
                  Text(isCommunity ? "${entry.membersCount} membres" : "Membre actif", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatBox(Icons.emoji_events, "${entry.value}", "XP Total"),
                      _buildStatBox(Icons.flash_on, "${entry.actionsCount}", "Actions"),
                      if (isCommunity)
                        _buildStatBox(Icons.group, "${entry.membersCount}", "Membres")
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        
                        // Réalisations Collectives (Seulement pour Communautés)
                        if (isCommunity) ...[
                          const Text("Réalisations collectives", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade100),
                            ),
                            child: Column(
                              children: [
                                if (entry.rank == 1)
                                  _buildBadgeRow(Icons.emoji_events, Colors.amber, "Champion", "1ère place du classement"),
                                
                                _buildBadgeRow(Icons.forest, Colors.green, "Forêt plantée", "Équivalent $treesPlanted arbres"),
                                
                                if (isSuperActive)
                                  _buildBadgeRow(Icons.bolt, Colors.orange, "Super actifs", "Plus de 50 actions cumulées !"),
                                  
                                if (entry.rank > 1 && treesPlanted == 0 && !isSuperActive)
                                  const Text("Continuez vos efforts pour débloquer des badges !", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Titre Top Contributeurs
                        Row(
                          children: [
                            Icon(isCommunity ? Icons.group_add : Icons.bookmark_border, size: 20, color: textDark),
                            const SizedBox(width: 8),
                            Text(
                              isCommunity ? "Top contributeurs" : "Réalisations récentes",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Liste des Top Contributeurs 
                        if (isCommunity)
                           if (_isLoadingContributors)
                             const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                           else if (_contributors.isEmpty)
                             const Padding(padding: EdgeInsets.all(10), child: Text("Aucun membre actif pour le moment.", style: TextStyle(color: Colors.grey)))
                           else
                             ..._contributors.map((u) => _buildListItem(
                               title: u.label, 
                               subtitle: "${u.value} XP",
                               avatarUrl: u.avatarUrl,
                             )).toList()
                        else
                           // TODO Mock pour l'utilisateur individuel
                           ...[
                              _buildListItem(
                                title: "Champion du vélo", 
                                subtitle: "30 jours consécutifs",
                                icon: Icons.directions_bike,
                                color: Colors.green
                              ),
                           ],  
                      ],
                    ),
                  ),

                  // Bouton
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.sports_kabaddi),
                        label: Text(isCommunity ? "Lancer un défi à ${entry.label}" : "Défi avec ${entry.label}"),
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

            Positioned(
              top: 40,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: isCommunity ? Colors.green.shade100 : const Color(0xFFBDEE63),
                  backgroundImage: _getAvatarProvider(entry.avatarUrl),
                  child: (entry.avatarUrl == null || entry.avatarUrl!.isEmpty)
                      ? Text(entry.label.isNotEmpty ? entry.label[0] : "?", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black54))
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(IconData icon, String value, String label) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Icon(icon, color: const Color(0xFF65BA74), size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _buildBadgeRow(IconData icon, Color color, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
      ]),
    );
  }

  Widget _buildListItem({required String title, required String subtitle, String? avatarUrl, IconData? icon, Color? color}) {
    // On calcule l'image si une URL est fournie
    final imageProvider = _getAvatarProvider(avatarUrl);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        if (imageProvider != null)
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: imageProvider,
          )
        else
          CircleAvatar(
            backgroundColor: (color ?? Colors.blue).withOpacity(0.2), 
            radius: 20, 
            child: Icon(icon ?? Icons.person, color: color ?? Colors.blue, size: 20)
          ),
          
        const SizedBox(width: 12),
        
        // TEXTES
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
        ),
      ]),
    );
  }

  ImageProvider? _getAvatarProvider(String? url) {
    if (url == null || url.isEmpty) return null;

    // URL Web (Supabase Storage, Google...)
    if (url.startsWith('http') || url.startsWith('https')) {
      return NetworkImage(url);
    }

    // Fichier Local (Asset)
    if (url.contains('assets/')) {
      final cleanPath = 'assets/${url.split('assets/').last}';
      return AssetImage(cleanPath);
    }

    // Fallback
    return AssetImage('assets/avatars/$url');
  }
}