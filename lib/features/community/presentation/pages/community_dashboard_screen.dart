import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/presentation/bloc/defis_cubit.dart';
import 'package:oikos/features/community/presentation/bloc/defis_state.dart';
import 'package:oikos/features/community/presentation/widgets/community_challenge_sheet.dart';
import 'package:oikos/features/community/presentation/widgets/defi_end_overlay.dart';
import 'package:oikos/features/community/presentation/widgets/defis_actions_section.dart';
import 'package:oikos/features/community/presentation/widgets/profile_details_modal.dart';
import 'package:oikos/features/community/presentation/widgets/ranking_action_modal.dart';
import 'package:oikos/features/notifications/domain/entities/notification_entity.dart';
import 'package:oikos/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:oikos/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/oikos_avatar.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/leaderboard_entry_model.dart';
import '../../data/models/community_action_model.dart';
import '../../domain/entities/leaderboard_entry.dart';

class CommunityDashboardScreen extends StatefulWidget {
  const CommunityDashboardScreen({super.key});

  @override
  State<CommunityDashboardScreen> createState() =>
      _CommunityDashboardScreenState();
}

class _CommunityDashboardScreenState extends State<CommunityDashboardScreen>
    with SingleTickerProviderStateMixin {
  late CommunityRemoteDataSource _dataSource;
  late TabController _tabController;
  final List<dynamic> _communityDefis = [];

  bool _isLoading = true;
  String? _error;

  List<LeaderboardEntryModel> _userList = [];
  List<LeaderboardEntryModel> _communityList = [];
  List<CommunityActionModel> _actions = [];

  String? _myCommunityCode;
  String? _myEntrepriseId;

  int get _notificationCount {
    final incomingCount = _communityDefis
        .where(
          (d) =>
              d['communaute_cible_code'] == _myCommunityCode &&
              d['statut'] == 'EN_ATTENTE_CIBLE',
        )
        .length;

    final votingCount = _communityDefis
        .where(
          (d) => d['statut'] == 'VOTE_LANCEMENT' && d['is_joined'] == false,
        )
        .length;

    return incomingCount + votingCount;
  }

  @override
  void initState() {
    super.initState();
    _dataSource = CommunityRemoteDataSource(Supabase.instance.client);
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
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
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = "Rejoins une communauté d'abord.";
          });
        }
        return;
      }

      _myCommunityCode = userRes['code_communaute'];
      _myEntrepriseId = userRes['entreprise_id'];

      final results = await Future.wait([
        _dataSource.getUserLeaderboard(_myCommunityCode!),
        _dataSource.getCommunityLeaderboard(
          _myEntrepriseId ?? '',
          _myCommunityCode!,
        ),
        _dataSource.getActions(),
      ]);

      if (!mounted) return;

      setState(() {
        _userList = (results[0] as List<LeaderboardEntryModel>).map((entry) {
          return entry.isMe ? entry.copyWith(label: "Moi") : entry;
        }).toList();
        _communityList = results[1] as List<LeaderboardEntryModel>;
        _actions = results[2] as List<CommunityActionModel>;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = "Erreur lors du chargement des données.";
        });
      }
    }
  }

  void _processDefiNotifications(
    NotificationsState notifState,
    DefisState defiState,
  ) {
    if (defiState is! DefisLoaded) return;

    final endDefisNotif = notifState.notifications
        .where((n) => n.type == NotificationType.defiCollectifTermine)
        .toList();

    if (endDefisNotif.isEmpty) return;

    for (var notif in endDefisNotif) {
      final defiId = notif.data['defi_id'];

      try {
        final defi = defiState.defis.firstWhere((d) => d.id == defiId);

        late OverlayEntry overlayEntry;
        overlayEntry = OverlayEntry(
          builder: (context) => Material(
            color: Colors.transparent,
            child: DefiEndOverlay(
              defi: defi,
              onClose: () {
                context.read<NotificationsCubit>().markAsRead(notif.id);
                overlayEntry.remove();
              },
            ),
          ),
        );
        Overlay.of(context, rootOverlay: true).insert(overlayEntry);

        context.read<NotificationsCubit>().markAsRead(notif.id);
      } catch (e) {
        debugPrint("Défi $defiId non trouvé dans le state");
      }
    }
  }

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

  void _showRankingInfo(BuildContext context, LeaderboardEntry entry) {
    final defisCubit = context.read<DefisCubit>();
    final appUserCubit = context.read<AppUserCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: defisCubit),
          BlocProvider.value(value: appUserCubit),
        ],
        child: RankingActionModal(
          name: entry.label,
          avatarUrl: entry.avatarUrl ?? '',
          isCommunity: !entry.isUser,
          targetCommunity: entry as LeaderboardEntryModel,
          myCommunityCode: _myCommunityCode!,
          entrepriseId: _myEntrepriseId!,
          onSeeProfile: () {
            Navigator.pop(dialogContext);
            showDialog(
              context: context,
              builder: (context) => BlocProvider.value(
                value: appUserCubit,
                child: ProfileDetailsModal(
                  entry: entry,
                  myCommunityCode: _myCommunityCode!,
                  entrepriseId: _myEntrepriseId!,
                ),
              ),
            );
          },
          onDuel: () => Navigator.pop(dialogContext),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text(_error!)));
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationsCubit, NotificationsState>(
          listenWhen: (prev, curr) =>
              curr.notifications.length > prev.notifications.length,
          listener: (context, state) {
            _processDefiNotifications(state, context.read<DefisCubit>().state);
          },
        ),
        BlocListener<DefisCubit, DefisState>(
          listenWhen: (prev, curr) =>
              prev is! DefisLoaded && curr is DefisLoaded,
          listener: (context, state) {
            _processDefiNotifications(
              context.read<NotificationsCubit>().state,
              state,
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            _buildTabBar(isDark),
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
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: 45,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : AppColors.lightInput,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.lightPrimary,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: isDark
            ? Colors.grey
            : AppColors.lightMutedForeground,
        tabs: [
          const Tab(text: "Individuel"),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Communautés"),
                if (_notificationCount > 0) _buildBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      child: Text(
        '$_notificationCount',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLeaderboardView(
    List<LeaderboardEntry> list, {
    required bool isCommunity,
  }) {
    if (list.isEmpty) {
      return const Center(child: Text("Aucun classement disponible"));
    }

    List<LeaderboardEntry> displayList = list.take(10).toList();
    bool amIInTop10 = displayList.any((e) => e.isMe);

    if (!amIInTop10) {
      final myEntry = list.cast<LeaderboardEntry?>().firstWhere(
        (e) => e?.isMe ?? false,
        orElse: () => null,
      );
      if (myEntry != null) displayList.add(myEntry);
    }

    final top3 = displayList.take(3).toList();
    final rest = displayList.length > 3
        ? displayList.sublist(3)
        : <LeaderboardEntry>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      child: Column(
        children: [
          _buildPodium(top3, isCommunity),
          const SizedBox(height: 20),
          ...rest.map((entry) => _buildEntryRow(entry, amIInTop10)),
          const SizedBox(height: 30),
          if (isCommunity)
            DefisActionsSection(onCommunityActionsTap: _openCommunityActions),
        ],
      ),
    );
  }

  Widget _buildEntryRow(LeaderboardEntry entry, bool amIInTop10) {
    final isMeAndFar = entry.isMe && !amIInTop10;
    return Column(
      children: [
        if (isMeAndFar) _buildSeparator(),
        _LeaderboardCard(
          entry: entry,
          onTap: () => _showRankingInfo(context, entry),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).hintColor.withValues(alpha: 0.3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.more_horiz, color: Theme.of(context).hintColor),
          ),
          Expanded(
            child: Divider(
              color: Theme.of(context).hintColor.withValues(alpha: 0.3),
            ),
          ),
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
        if (second != null)
          _buildPodiumStep(second, 2, const Color(0xFFC0C0C0), 110),
        if (first != null)
          _buildPodiumStep(first, 1, const Color(0xFFFFD700), 140),
        if (third != null)
          _buildPodiumStep(third, 3, const Color(0xFFCD7F32), 90),
      ],
    );
  }

  Widget _buildPodiumStep(
    LeaderboardEntry entry,
    int rank,
    Color color,
    double height,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _showRankingInfo(context, entry),
        child: Column(
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
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${entry.value} pts",
              style: const TextStyle(
                color: AppColors.lightPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: rank == 1 ? 60 : (rank == 2 ? 40 : 25),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.3),
                    color.withOpacity(0.05),
                  ],
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
              ? AppColors.lightPrimary.withValues(alpha: 0.1)
              : (isDark ? AppColors.darkInput : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMe ? AppColors.lightPrimary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                "#${entry.rank}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor,
                ),
              ),
            ),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
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
            Text(
              "${entry.value} pts",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.lightPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
