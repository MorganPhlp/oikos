import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';

// Plus besoin du GradientButton ici car on allège le design
// import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';

import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/leaderboard_entry_model.dart';
import '../../data/models/community_action_model.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../widgets/ranking_action_modal.dart';
import '../widgets/profile_details_modal.dart';

class CommunityDashboardScreen extends StatefulWidget {
  const CommunityDashboardScreen({Key? key}) : super(key: key);

  @override
  State<CommunityDashboardScreen> createState() => _CommunityDashboardScreenState();
}

class _CommunityDashboardScreenState extends State<CommunityDashboardScreen> with SingleTickerProviderStateMixin {
  late CommunityRemoteDataSource _dataSource;
  late TabController _tabController;

  bool _isLoading = true;
  String? _error;

  List<LeaderboardEntryModel> _userList = [];
  List<LeaderboardEntryModel> _communityList = [];
  List<CommunityActionModel> _actions = [];

  String? _myCommunityCode;
  String? _myEntrepriseId;

  void _showRankingInfo(BuildContext context, LeaderboardEntry entry) {
    showDialog(
      context: context,
      builder: (context) => RankingActionModal(
        name: entry.label,
        avatarUrl: entry.avatarUrl ?? '',
        isCommunity: !entry.isUser,
        onSeeProfile: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => ProfileDetailsModal(entry: entry),
          );
        },
        onDuel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _dataSource = CommunityRemoteDataSource(Supabase.instance.client);
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("Utilisateur non connecté");

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

      final results = await Future.wait([
        _dataSource.getUserLeaderboard(_myCommunityCode!),
        _dataSource.getCommunityLeaderboard(_myEntrepriseId ?? '', _myCommunityCode!),
        _dataSource.getActions(),
      ]);

      if (!mounted) return;

      setState(() {
        _userList = results[0] as List<LeaderboardEntryModel>;
        _communityList = results[1] as List<LeaderboardEntryModel>;
        _actions = results[2] as List<CommunityActionModel>;
        _isLoading = false;
      });

    } catch (e) {
      if (!mounted) return;
      _loadFakeDataFallback();
    }
  }

  void _loadFakeDataFallback() {
    setState(() {
      _userList = [
        LeaderboardEntryModel(id: '1', label: 'Sophie', value: 2450, rank: 1, isUser: true, isMe: false, impactStats: '-75kg', actionsCount: 42, streakDays: 5, avatarUrl: 'assets/avatars/avatar_1.png'),
        LeaderboardEntryModel(id: '2', label: 'Thomas', value: 2280, rank: 2, isUser: true, isMe: false, impactStats: '-60kg', actionsCount: 38, streakDays: 2, avatarUrl: 'assets/avatars/avatar_2.png'),
        LeaderboardEntryModel(id: '3', label: 'Marie', value: 2150, rank: 3, isUser: true, isMe: false, impactStats: '-55kg', actionsCount: 35, streakDays: 3, avatarUrl: 'assets/avatars/avatar_3.png'),
        LeaderboardEntryModel(id: '4', label: 'Lucas', value: 1980, rank: 4, isUser: true, isMe: false, impactStats: '-71kg', actionsCount: 36, streakDays: 0, avatarUrl: ''),
        LeaderboardEntryModel(id: '6', label: 'Vous', value: 1720, rank: 6, isUser: true, isMe: true, impactStats: '-63kg', actionsCount: 31, streakDays: 1, avatarUrl: 'assets/avatars/avatar_5.png'),
      ];
      _communityList = [
        LeaderboardEntryModel(id: 'c1', label: 'Viveris Paris', value: 24500, rank: 1, isUser: false, isMe: true, impactStats: '-1.2T', actionsCount: 156, streakDays: 0, avatarUrl: ''),
        LeaderboardEntryModel(id: 'c2', label: 'Viveris Lyon', value: 18900, rank: 2, isUser: false, isMe: false, impactStats: '-890kg', actionsCount: 89, streakDays: 0, avatarUrl: ''),
      ];
      _isLoading = false;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
            "Classement",
            style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkForeground : AppColors.lightTextPrimary
            )
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: isDark ? AppColors.darkForeground : AppColors.lightTextPrimary),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            height: 45,
            decoration: BoxDecoration(
                color: isDark ? AppColors.darkInput : AppColors.lightInput,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder)
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: AppColors.lightPrimary.withOpacity(0.3), blurRadius: 4, offset: const Offset(0,2))],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? Colors.grey : AppColors.lightMutedForeground,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: "Individuel"),
                Tab(text: "Communautés"),
              ],
            ),
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

  Widget _buildLeaderboardView(List<LeaderboardEntry> list, {required bool isCommunity}) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (list.isEmpty) return const Center(child: Text("Aucun classement disponible"));

    final top3 = list.take(3).toList();
    final rest = list.length > 3 ? list.sublist(3) : <LeaderboardEntry>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      child: Column(
        children: [
          if (top3.isNotEmpty) _buildPodium(top3, isCommunity),

          const SizedBox(height: 20),

          ...rest.map((entry) => _LeaderboardCard(
              entry: entry,
              onTap: () => _showRankingInfo(context, entry)
          )).toList(),

          const SizedBox(height: 30),

          _buildChallengesSection(isCommunity),
        ],
      ),
    );
  }

  Widget _buildPodium(List<LeaderboardEntry> top3, bool isCommunity) {
    if (top3.isEmpty) return const SizedBox();

    LeaderboardEntry? first = top3.isNotEmpty ? top3[0] : null;
    LeaderboardEntry? second = top3.length > 1 ? top3[1] : null;
    LeaderboardEntry? third = top3.length > 2 ? top3[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null) _buildPodiumStep(second, 2, const Color(0xFFC0C0C0), 110),
        if (first != null) _buildPodiumStep(first, 1, const Color(0xFFFFD700), 140),
        if (third != null) _buildPodiumStep(third, 3, const Color(0xFFCD7F32), 90),
      ],
    );
  }

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
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 3)),
                  child: OikosAvatar(
                    avatarUrl: entry.avatarUrl,
                    label: entry.label,
                    radius: rank == 1 ? 35 : 28,
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

            Text(
                entry.label,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis
            ),
            Text("${entry.value}", style: TextStyle(color: AppColors.lightPrimary, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Container(
              height: rank == 1 ? 60 : (rank == 2 ? 40 : 25),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withOpacity(0.3),
                      color.withOpacity(0.05),
                    ]
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChallengesSection(bool isCommunity) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text("Actions Collectives", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),

        _ChallengeCard(
          title: "Défi avec un membre",
          subtitle: "Compare tes actions avec un collègue",
          icon: Icons.flash_on,
          color: AppColors.lightPrimary,
          onTap: () {
            // Action à définir
          },
        ),

        const SizedBox(height: 12),

        _ChallengeCard(
          title: "Défi de communautés",
          subtitle: "Affronte une autre équipe",
          icon: Icons.emoji_events,
          color: Colors.orange,
          onTap: () {
            // Action à définir
          },
        ),
      ],
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final VoidCallback onTap;

  const _LeaderboardCard({required this.entry, required this.onTap});

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
          boxShadow: isMe ? [] : [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 5,
                offset: const Offset(0, 2)
            )
          ],
        ),
        child: Row(
          children: [
            Text("#${entry.rank}", style: TextStyle(fontWeight: FontWeight.bold, color: theme.hintColor, fontSize: 16)),
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
                          color: isDark ? AppColors.darkForeground : AppColors.lightTextPrimary,
                          fontSize: 15
                      )
                  ),
                  Text(
                    entry.isUser
                        ? "${entry.actionsCount ?? 0} actions • ${entry.impactStats ?? ''}"
                        : "${entry.actionsCount ?? 0} membres • ${entry.impactStats ?? ''}",
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${entry.value}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.lightPrimary, fontSize: 16)),
                Text("pts", style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// --- NOUVEAU DESIGN ÉPURÉ POUR LES CARTES ---
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

    // Design inspiré de ProfileActionButton
    // mais adapté en "Card" pour le dashboard
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Bordure fine comme sur les inputs
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder),
        // Ombre très légère, voire nulle pour un look "flat"
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))
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
                // Icône dans un cercle coloré (comme sur le profil)
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

                // Textes
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark ? AppColors.darkForeground : AppColors.lightTextPrimary
                          )
                      ),
                      const SizedBox(height: 2),
                      Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)
                      ),
                    ],
                  ),
                ),

                // Petite flèche discrète pour inviter à l'action
                Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: theme.hintColor.withOpacity(0.5)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}