import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';
import '../widgets/community_challenges_sheet.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/leaderboard_entry_model.dart';
import '../../data/models/community_action_model.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../widgets/ranking_action_modal.dart';
import '../widgets/profile_details_modal.dart';
import 'community_selection_screen.dart'; 
import '../widgets/setup_duel_modal.dart';
import '../widgets/community_defi_list_widget.dart';
import '../widgets/defi_vote_widget.dart';

/// Ecran pour le dashboard de communautés
class CommunityDashboardScreen extends StatefulWidget {
  const CommunityDashboardScreen({Key? key}) : super(key: key);

  @override
  State<CommunityDashboardScreen> createState() =>
      _CommunityDashboardScreenState();
}

/// Etat de l'écran de classement communautaire
class _CommunityDashboardScreenState extends State<CommunityDashboardScreen>
    with SingleTickerProviderStateMixin {
  late CommunityRemoteDataSource _dataSource;
  late TabController _tabController;
  List<dynamic> _communityDefis = [];
  int _requiredVotes = 1; /// Nombre de votes requis pour lancer un défi

  bool _isLoading = true;
  String? _error;

  List<LeaderboardEntryModel> _userList = []; /// Liste des utilisateurs
  List<LeaderboardEntryModel> _communityList = []; /// Liste des communautés
  List<CommunityActionModel> _actions = []; /// Liste des actions

  String? _myCommunityCode; /// Code de l'a communauté de l'utilisateur connecté
  String? _myEntrepriseId; /// ID de l'entreprise de l'utilisateur connecté

  int get _notificationCount {
    /// Invitations reçues pour un défi en attente de vote
    final incomingCount = _communityDefis.where((d) => 
      d['communaute_cible_code'] == _myCommunityCode && 
      d['statut'] == 'EN_ATTENTE_CIBLE'
    ).length;

    /// Votes pour lancer le défi
    final votingCount = _communityDefis.where((d) => 
      d['statut'] == 'VOTE_LANCEMENT' && 
      d['is_joined'] == false /// L'utilisateur n'a pas encore voté
    ).length;

    return incomingCount + votingCount;
  }

  @override
  void initState() {
    super.initState();
    _dataSource = CommunityRemoteDataSource(Supabase.instance.client);
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  /// Chargement des données
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("Utilisateur non connecté");

      final userRes = await Supabase.instance.client
          .from('utilisateur')
          .select('code_communaute, entreprise_id')
          .eq('id', userId)
          .maybeSingle();

      if (userRes == null || userRes['code_communaute'] == null) {
        setState(() {
          _isLoading = false;
          _error = "Rejoins une communauté d'abord.";
        });
        return;
      }

      _myCommunityCode = userRes['code_communaute'];
      _myEntrepriseId = userRes['entreprise_id'];

      /// On récupère les membres actifs
      final activeUsersRes = await Supabase.instance.client
          .from('utilisateur')
          .select('id')
          .eq('code_communaute', _myCommunityCode!)
          .eq('est_compte_valide', true)
          .eq('est_actif', true)
          .neq('etat_compte', 'ANONYMISE');
          
      int activeMembersCount = activeUsersRes.length;
      int required = (activeMembersCount * 0.6).ceil(); // .ceil() arrondit au chiffre supérieur
      if (required < 1) required = 1;

      /// On récupère les données
      final results = await Future.wait([
        _dataSource.getUserLeaderboard(_myCommunityCode!),
        _dataSource.getCommunityLeaderboard(_myEntrepriseId ?? '', _myCommunityCode!),
        _dataSource.getActions(),
        _dataSource.getMyCommunityDefis(_myCommunityCode!), 
      ]);

      if (!mounted) return;

      setState(() {
        _requiredVotes = required;
        _userList = (results[0] as List<LeaderboardEntryModel>).map((entry) {
          final isMe = entry.id == Supabase.instance.client.auth.currentUser?.id;
          return entry.copyWith(isMe: isMe, label: isMe ? "Moi" : entry.label);
        }).toList();
        _communityList = results[1] as List<LeaderboardEntryModel>;
        _actions = results[2] as List<CommunityActionModel>;
        _communityDefis = results[3]; 
        
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _isLoading = false; });
    }
  }

  /// Affichage du classement
  void _showRankingInfo(BuildContext context, LeaderboardEntry entry) {
    showDialog(
      context: context,
      builder: (context) => RankingActionModal(
        name: entry.label,
        avatarUrl: entry.avatarUrl ?? '',
        isCommunity: !entry.isUser,
        targetCommunity: entry as LeaderboardEntryModel, 
        myCommunityCode: _myCommunityCode!,              
        entrepriseId: _myEntrepriseId!,
        onSeeProfile: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => ProfileDetailsModal(entry: entry, myCommunityCode: _myCommunityCode!, entrepriseId: _myEntrepriseId!,),
          );
        },
        onDuel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Gestion des réponses au défi
  Future<void> _handleChallengeResponse(String challengeId, bool accept) async {
    try {
      await _dataSource.respondToChallenge(challengeId, accept);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(accept ? "Défi accepté ! Bonne chance !" : "Défi décliné."),
            backgroundColor: accept ? Colors.green : Colors.red,
          )
        );
        _loadData();
      }
    } catch (e) {
      debugPrint("Erreur réponse défi: $e");
    }
  }

  /// Widget d'affichage de l'invitation reçue
  Widget _buildIncomingChallengeSection() {
    final incomingDefis = _communityDefis.where((d) => 
      d['communaute_cible_code'] == _myCommunityCode && 
      d['statut'] == 'EN_ATTENTE_CIBLE'
    ).toList();

    if (incomingDefis.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12, top: 10),
          child: Text("Nouveau défi reçu !", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16)),
        ),
        ...incomingDefis.map((defi) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            children: [
              const Icon(Icons.flash_on, color: Colors.orange, size: 30),
              const SizedBox(height: 12),
              Text(
                "Une communauté défie la tienne sur ${defi['titre'] ?? ''} !",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _handleChallengeResponse(defi['id'], true),
                      child: const Text("J'accepte"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _handleChallengeResponse(defi['id'], false),
                      child: const Text("Je refuse"),
                    ),
                  ),
                ],
              )
            ],
          ),
        )).toList(),
      ],
    );
  }

  // Widget pour les votes actifs
  Widget _buildActiveVotesSection() {
    final votingDefis = _communityDefis.where((d) => d['statut'] == 'VOTE_LANCEMENT').toList();

    if (votingDefis.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- On utilise un Row (Ligne) pour aligner l'icône et le texte ---
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.bolt, color: Colors.orange, size: 20),
              const SizedBox(width: 8), // Petit espace entre l'éclair et le texte
              const Text(
                "Vote pour le prochain défi", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        // -------------------------------------------------------------------
        
        ...votingDefis.map((defi) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DefiVoteWidget(
            title: defi['titre'] ?? "Défi",
            currentVotes: (defi['participants_count'] as num?)?.toInt() ?? 0,
            totalRequired: _requiredVotes,
            hasVoted: defi['is_joined'] ?? false,
            onVote: () async {
              await _dataSource.voteForDefiLaunch(defi['id'], _myCommunityCode!);
              _loadData();
            },
          ),
        )).toList(),
      ],
    );
  }

  /// Sélection parmi les communautés de l'entreprise
  Future<void> _openCommunitySelection() async {
    if (_myEntrepriseId == null || _myCommunityCode == null) return;

    final adversary = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunitySelectionScreen(
          entrepriseId: _myEntrepriseId!,
          myCommunityCode: _myCommunityCode!,
        ),
      ),
    );

    if (adversary != null && mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SetupDuelModal(
          targetCommunity: adversary,
          myCommunityCode: _myCommunityCode!,
          entrepriseId: _myEntrepriseId!,
        ),
      );
    }
  }

  /// Sélection parmi les actions communautaires actives
  void _openCommunityActions() {
    if (_myEntrepriseId == null || _myCommunityCode == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommunityChallengesSheet(
        actions: _actions,
        entrepriseId: _myEntrepriseId!,
        myCommunityCode: _myCommunityCode!,
      ),
    );
  }

  /// Mise à jour de la section Défis
  Widget _buildChallengesSection(bool isCommunity) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIncomingChallengeSection(), 
        _buildActiveVotesSection(), 
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.bolt, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text("Défis actifs", 
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        CommunityDefisListWidget(entrepriseId: _myEntrepriseId ?? '', communityCode: _myCommunityCode ?? ''),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.orange, size: 20),
                Text("Défis et actions communautaires", 
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            )
        ),

        _ChallengeCard(
          title: "Propose un défi",
          subtitle: "Affronte une autre équipe",
          icon: Icons.flash_on,
          color: AppColors.lightPrimary,
          onTap: () => _openCommunitySelection(),
        ),

        const SizedBox(height: 12),

        _ChallengeCard(
          title: "Actions communautaires",
          subtitle: "Lance-toi dans un défi collectif",
          icon: Icons.emoji_events,
          color: Colors.orange,
          onTap: () => _openCommunityActions(),
        ),
      ],
    );
  }

  /// Construction de la fenêtre
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error != null) return Scaffold(body: Center(child: Text(_error!)));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            height: 45,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkInput : AppColors.lightInput,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? Colors.grey : AppColors.lightMutedForeground,
              tabs: [
                const Tab(text: "Individuel"),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Communautés"),
                      if (_notificationCount > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$_notificationCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            )
          ),

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

  /// Widget d'affichage du classement
  Widget _buildLeaderboardView(List<LeaderboardEntry> list, {required bool isCommunity}) {
    if (list.isEmpty) return const Center(child: Text("Aucun classement disponible"));

    List<LeaderboardEntry> displayList = [];
    final top10 = list.take(10).toList();
    displayList.addAll(top10);

    bool amIInTop10 = top10.any((e) => e.isMe);

    if (!amIInTop10) {
      try {
        final myEntry = list.firstWhere((e) => e.isMe);
        displayList.add(myEntry);
      } catch (_) {}
    }

    /// Podium
    final top3 = displayList.take(3).toList();
    /// Reste du classement
    final rest = displayList.length > 3 ? displayList.sublist(3) : <LeaderboardEntry>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      child: Column(
        children: [
          if (top3.isNotEmpty) _buildPodium(top3, isCommunity),
          const SizedBox(height: 20),

          ...rest.map((entry) {
            final isMeAndFar = entry.isMe && !amIInTop10;

            return Column(
              children: [
                if (isMeAndFar)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Theme.of(context).hintColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.more_horiz, color: Theme.of(context).hintColor),
                        ),
                        Expanded(child: Divider(color: Theme.of(context).hintColor)),
                      ],
                    ),
                  ),
                _LeaderboardCard(
                  entry: entry,
                  onTap: () => _showRankingInfo(context, entry),
                ),
              ],
            );
          }).toList(),

          const SizedBox(height: 30),
          if (isCommunity) _buildChallengesSection(isCommunity),
        ],
      ),
    );
  }

  /// Widget de création du podium
  Widget _buildPodium(List<LeaderboardEntry> top3, bool isCommunity) {
    if (top3.isEmpty) return const SizedBox();

    LeaderboardEntry? first = top3.isNotEmpty ? top3[0] : null;
    LeaderboardEntry? second = top3.length > 1 ? top3[1] : null;
    LeaderboardEntry? third = top3.length > 2 ? top3[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null)
          _buildPodiumStep(second, 2, const Color(0xFFC0C0C0), 110),
        if (first != null)
          _buildPodiumStep(first, 1, const Color(0xFFFFD700), 140),
        if (third != null)
          _buildPodiumStep(third, 3, const Color(0xFFCD7F32), 90),
      ],
    );
  }

  /// Widget de création des marches du podium
  Widget _buildPodiumStep(LeaderboardEntry entry, int rank, Color color, double height) {
    final theme = Theme.of(context);

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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 3),
                  ),
                  child: OikosAvatar(
                    avatarUrl: entry.avatarUrl,
                    label: entry.label,
                    radius: rank == 1 ? 35 : 28,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "#$rank",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            Text(
              entry.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${entry.value}",
              style: const TextStyle(
                color: AppColors.lightPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              height: rank == 1 ? 60 : (rank == 2 ? 40 : 25),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withOpacity(0.3), color.withOpacity(0.05)],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Classe représentant le classement
class _LeaderboardCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final VoidCallback onTap;

  const _LeaderboardCard({required this.entry, required this.onTap});

  /// Création de la page
  @override
  Widget build(BuildContext context) {
    final isMe = entry.isMe;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.lightPrimary.withOpacity(0.1)
              : (isDark ? AppColors.darkInput : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: isMe
              ? Border.all(color: AppColors.lightPrimary)
              : Border.all(color: Colors.transparent),
          boxShadow: isMe
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Text(
              "#${entry.rank}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.hintColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 12),
            OikosAvatar(
              avatarUrl: entry.avatarUrl,
              label: entry.label,
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkForeground
                          : AppColors.lightTextPrimary,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    entry.isUser
                        ? "${entry.actionsCount} action(s)"
                        : "${entry.actionsCount} membre(s)",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
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
                    color: AppColors.lightPrimary,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "pts",
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
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

  /// Création de la page
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark
                              ? AppColors.darkForeground
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
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
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
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