import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/leaderboard_entry_model.dart';
import '../../data/models/community_action_model.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../widgets/ranking_action_modal.dart';
import '../widgets/profile_details_modal.dart';

// Couleurs utilisées dans la page
class AppColors {
  static const greenPrimary = Color(0xFFBDEE63); // Boutons/Fond avatar
  static const greenDark = Color(0xFF37401C);    // extes
  static const greenAccent = Color(0xFF65BA74);  // Icônes/Bordures
  static const bgCream = Color(0xFFFAFAFA);      // Fond
  static const cardWhite = Colors.white;
  
  // Couleurs du podium
  static const gold = Color(0xFFFFD700);
  static const silver = Color(0xFFC0C0C0);
  static const bronze = Color(0xFFCD7F32);
}

// Écran principal de la section Classement avec les classements et défis
class CommunityDashboardScreen extends StatefulWidget {
  const CommunityDashboardScreen({Key? key}) : super(key: key);

  @override
  State<CommunityDashboardScreen> createState() => _CommunityDashboardScreenState();
}

// Etat de l'écran de classement communautaire
class _CommunityDashboardScreenState extends State<CommunityDashboardScreen> with SingleTickerProviderStateMixin {
  late CommunityRemoteDataSource _dataSource;
  late TabController _tabController;
  
  bool _isLoading = true;
  String? _error;
  
  // Données
  List<LeaderboardEntryModel> _userList = [];
  List<LeaderboardEntryModel> _communityList = [];
  List<CommunityActionModel> _actions = []; 
  
  String? _myCommunityCode;
  String? _myEntrepriseId;

  // Méthode pour ouvrir la modale
  void _showRankingInfo(BuildContext context, LeaderboardEntry entry) {
    showDialog(
      context: context,
      builder: (context) => RankingActionModal(
        name: entry.label,
        avatarUrl: entry.avatarUrl ?? '',
        isCommunity: !entry.isUser, // Si ce n'est pas un user, c'est une communauté
        onSeeProfile: () {
          Navigator.pop(context);
          print("Navigation vers le profil de ${entry.label}");
          showDialog(
            context: context,
            builder: (context) => ProfileDetailsModal(entry: entry),
          );
          },
        onDuel: () {
          Navigator.pop(context);
          print("Défi lancé contre ${entry.label}");
        },
      ),
    );
  }

  // Fonction utilitaire pour gérer les avatars (Web vs Local)
  ImageProvider? _getAvatarProvider(String? url) {
    if (url == null || url.isEmpty) return null;
    
    if (url.startsWith('http') || url.startsWith('https')) {
      // Cas URL Internet (Supabase)
      return NetworkImage(url);
    } else {
      // Cas fichier Local (Asset)
      String cleanPath = url
          .replaceAll('file:///', '')
          .replaceAll('C:/src/projet/oikos/', '');
      return AssetImage(cleanPath);
    }
  }

  @override
  void initState() {
    super.initState();
    _dataSource = CommunityRemoteDataSource(Supabase.instance.client);
    // 2 onglets : Individuel et Communautés
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _error = null; });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("Utilisateur non connecté");

      // Récupération des infos utilisateur
      final userRes = await Supabase.instance.client
          .from('utilisateur')
          .select('code_communaute, entreprise_id')
          .eq('id', userId)
          .maybeSingle();

      if (userRes == null || userRes['code_communaute'] == null) {
        setState(() { _isLoading = false; _error = "Rejoins une communauté d'abord."; });
        return;
      }

      _myCommunityCode = userRes['code_communaute'];
      _myEntrepriseId = userRes['entreprise_id'];

      // Chargement des données
      final results = await Future.wait([
        _dataSource.getUserLeaderboard(_myCommunityCode!),
        _dataSource.getCommunityLeaderboard(_myEntrepriseId ?? '', _myCommunityCode!),
        _dataSource.getActions(),
      ]);

      if (!mounted) return;

      setState(() {
        _userList = (results[0] as List<LeaderboardEntryModel>).map((entry){
          final isMe = entry.id == userId;
             return entry.copyWith(
               isMe: isMe,
               // Si c'est l'utilisateur connecté, on affiche "Toi", sinon on garde le vrai nom
               label: isMe ? "Toi" : entry.label, 
             );
        }).toList();
        _communityList = results[1] as List<LeaderboardEntryModel>;
        _actions = results[2] as List<CommunityActionModel>;
        _isLoading = false;
      });

    } catch (e) {
      if (!mounted) return;
    }
  }

  // Nettoyage du controller
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Classement", style: TextStyle(color: AppColors.greenDark, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.greenDark),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Onglets
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
              ),
              labelColor: AppColors.greenAccent,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: "Individuel"),
                Tab(text: "Communautés"),
              ],
            ),
          ),

          // Le contenu de chaque onglet (classements + défis)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardView(_userList, isCommunity: false),
                _buildLeaderboardView(_communityList, isCommunity: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Vue principale du classement (utilisateurs ou communautés)
  Widget _buildLeaderboardView(List<LeaderboardEntry> list, {required bool isCommunity}) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (list.isEmpty) return const Center(child: Text("Aucun classement disponible"));

    // Séparation du Top 3 du reste
    final top3 = list.take(3).toList();
    final rest = list.length > 3 ? list.sublist(3) : <LeaderboardEntry>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      child: Column(
        children: [
          // Podium pour les 3 premiers
          if (top3.isNotEmpty) _buildPodium(top3, isCommunity),

          const SizedBox(height: 20),

          // Liste pour les rangs 4 et suivants
          ...rest.map((entry) => InkWell(
            onTap: () => _showRankingInfo(context, entry),
            child: _LeaderboardCard(entry: entry),
          )).toList(),

          const SizedBox(height: 30),

          // Défis collectifs (uniquement dans l'onglet Communautés)
          _buildChallengesSection(isCommunity),
        ],
      ),
    );
  }

  // Widget podium
  Widget _buildPodium(List<LeaderboardEntry> top3, bool isCommunity) {
    if (top3.isEmpty) return const SizedBox();

    // Organisation de l'affichage du podium
    LeaderboardEntry? first = top3.isNotEmpty ? top3[0] : null;
    LeaderboardEntry? second = top3.length > 1 ? top3[1] : null;
    LeaderboardEntry? third = top3.length > 2 ? top3[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end, // Aligner en bas
      children: [
        if (second != null) _buildPodiumStep(second, 2, AppColors.silver, 110),
        if (first != null) _buildPodiumStep(first, 1, AppColors.gold, 140),
        if (third != null) _buildPodiumStep(third, 3, AppColors.bronze, 90),
      ],
    );
  }

  Widget _buildPodiumStep(LeaderboardEntry entry, int rank, Color color, double height) {
    // On calcule le bon provider d'image avec notre fonction
    final imageProvider = _getAvatarProvider(entry.avatarUrl);

    return Expanded(
      child: GestureDetector(
        onTap: () => _showRankingInfo(context, entry),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 3)),
                  child: CircleAvatar(
                    radius: rank == 1 ? 35 : 28,
                    backgroundColor: AppColors.bgCream,
                    
                    backgroundImage: imageProvider,
                    
                    // On affiche l'initiale seulement si pas d'image
                    child: imageProvider == null
                      ? Text(
                          entry.label.isNotEmpty ? entry.label[0].toUpperCase() : "?",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                        )
                      : null,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                    child: Text("#$rank", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            
            Text(entry.label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text("${entry.value}", style: const TextStyle(color: AppColors.greenAccent, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 8),
            
            Container(
              height: rank == 1 ? 60 : (rank == 2 ? 40 : 25),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: rank == 1 ? const Color(0xFFFFF9C4) : const Color(0xFFF5F5F5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Section des défis
  Widget _buildChallengesSection(bool isCommunity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Actions Collectives", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
        const SizedBox(height: 10),
        
        _ChallengeCard(
          title: "Défi communautaire",
          subtitle: "Lance-toi dans un défi collectif avec ta communauté",
          icon: Icons.flash_on,
          buttonText: "Lancer une action",
          color: AppColors.greenPrimary,
        ),
        
        const SizedBox(height: 10),
        
        /*Carte Défi 2
        _ChallengeCard(
          title: "Défi de communautés",
          subtitle: "Affronte une autre équipe",
          icon: Icons.emoji_events,
          buttonText: "Créer un défi",
          color: AppColors.greenAccent,
          isInverse: true,
        ),*/
      ],
    );
  }
}

// Widget pour une carte de classement (utilisateur ou communauté)
class _LeaderboardCard extends StatelessWidget {
  final LeaderboardEntry entry;
  const _LeaderboardCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isMe = entry.isMe;

    ImageProvider? imageProvider;
    final url = entry.avatarUrl;

    if (url != null && url.isNotEmpty) {
      if (url.startsWith('http') || url.startsWith('https')) {
        // Cas Internet (Supabase)
        imageProvider = NetworkImage(url);
      } else {
        // Cas Local (Asset)
        String cleanPath = url
            .replaceAll('file:///', '')
            .replaceAll('C:/src/projet/oikos/', ''); 
        imageProvider = AssetImage(cleanPath);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isMe ? Border.all(color: AppColors.greenAccent) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Text(
            "#${entry.rank}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 12),
          
          CircleAvatar(
            radius: 20,
            backgroundColor: isMe ? AppColors.greenPrimary : Colors.grey[200],
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Text(
                    entry.label.isNotEmpty ? entry.label[0].toUpperCase() : "?",
                    style: TextStyle(
                      color: isMe ? AppColors.greenDark : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenDark,
                    fontSize: 15,
                  ),
                ),
                Text(
                  entry.isUser
                      ? "${entry.actionsCount ?? 0} actions"
                      : "${entry.actionsCount ?? 0} membres",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${entry.value}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.greenAccent,
                  fontSize: 16,
                ),
              ),
              const Text(
                "points",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Widget pour une carte de défi communautaire
class _ChallengeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String buttonText;
  final Color color;
  final bool isInverse;

  const _ChallengeCard({
    required this.title, 
    required this.subtitle, 
    required this.icon, 
    required this.buttonText, 
    required this.color,
    this.isInverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isInverse ? color.withOpacity(0.2) : color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isInverse ? color : Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.greenDark)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInverse ? color : AppColors.greenAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    minimumSize: const Size(0, 30),
                    elevation: 0,
                  ),
                  child: Text(buttonText, style: const TextStyle(fontSize: 12)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}