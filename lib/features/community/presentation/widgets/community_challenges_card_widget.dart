import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/active_challenge_model.dart';

// Widget pour les défis communautaires
class CommunityChallengesCardWidget extends StatefulWidget {
  final String entrepriseId;
  final String myCommunityCode;

  const CommunityChallengesCardWidget({
    Key? key, 
    required this.entrepriseId,
    required this.myCommunityCode,
  }) : super(key: key);

  @override
  State<CommunityChallengesCardWidget> createState() => _CommunityChallengesCardWidgetState();
}

class _CommunityChallengesCardWidgetState extends State<CommunityChallengesCardWidget> {
  List<ActiveChallengeModel> _challenges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    final dataSource = CommunityRemoteDataSource(Supabase.instance.client);
    final results = await dataSource.getActiveChallenges(widget.entrepriseId);
    
    if (mounted) {
      setState(() {
        _challenges = results.map((e) => ActiveChallengeModel.fromJson(Map<String, dynamic>.from(e))).toList();
        _isLoading = false;
      });
    }
  }

  // Dans la méthode _joinAndValidateChallenge du widget :
Future<void> _joinAndValidateChallenge(dynamic challenge) async {
  try {
    final dataSource = CommunityRemoteDataSource(Supabase.instance.client);
    final int baseXp = challenge.xpGain;

    await dataSource.validateCommunityAction(
      instanceId: challenge.id, 
      baseActionId: challenge.baseActionId,
      codeCommunaute: widget.myCommunityCode, 
      userXpGain: (baseXp * 0.4).toInt(), 
      communityXpReward: baseXp, 
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Action validée ! Score collectif en cours... 🚀"), backgroundColor: AppColors.lightPrimary),
      );
      _loadChallenges();
    }
  } catch (e) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e"), backgroundColor: Colors.red));
  }
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()));
    }

    if (_challenges.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text("Aucun défi en cours. Sois le premier à en lancer un !")),
      );
    }

    return Column(
      children: _challenges.map((challenge) {
        final daysLeft = challenge.dateFin.difference(DateTime.now()).inDays;
        final deadlineText = daysLeft > 0 ? "$daysLeft jours restants" : "Se termine aujourd'hui";
        final target = 20; 
        final progress = (challenge.participantsCount / target * 100).clamp(0, 100).toInt();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _ChallengeCard(
            title: challenge.title,
            description: challenge.description,
            icon: "⚡", 
            points: challenge.xpGain,
            currentProgress: progress,
            requiredPercentage: 100, 
            activeUsers: challenge.participantsCount,
            deadline: deadlineText,
            categories: const ["Défi actif"],
            isJoined: challenge.isJoined, 
            onTap: challenge.isJoined ? null : () => _joinAndValidateChallenge(challenge), 
          ),
        );
      }).toList(),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final int points;
  final int currentProgress;
  final int requiredPercentage;
  final int activeUsers;
  final String deadline;
  final List<String> categories;
  final bool isJoined;
  final VoidCallback? onTap;

  const _ChallengeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    required this.currentProgress,
    required this.requiredPercentage,
    required this.activeUsers,
    required this.deadline,
    required this.categories,
    required this.isJoined,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.tertiary;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: goldColor, width: 2),
              boxShadow: [
                BoxShadow(color: goldColor.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [goldColor, goldColor.withValues(alpha: 0.7)]),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(description, style: TextStyle(fontSize: 12, color: AppColors.lightTextPrimary.withValues(alpha: 0.7))),
                        ],
                      ),
                    ),
                    Text("+$points pts", style: const TextStyle(color: AppColors.lightPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 6,
                  children: categories.map((cat) => _CategoryBadge(label: cat)).toList(),
                ),
                const SizedBox(height: 12),

                _ProgressBar(current: currentProgress, target: requiredPercentage),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.users, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("$activeUsers participants", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.lightPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(deadline, style: const TextStyle(fontSize: 11, color: AppColors.lightPrimary)),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                Center(
                   child: Text(
                     isJoined ? "Tu as déjà fait l'action" : "Appuie si tu l'as fait !", 
                     style: TextStyle(
                       fontSize: 13, 
                       fontWeight: FontWeight.bold, 
                       color: isJoined ? Colors.grey : AppColors.lightPrimary, 
                     )
                   ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [goldColor.withValues(alpha: 0.2), Colors.transparent],
                ),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(60)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int target;
  const _ProgressBar({required this.current, required this.target});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$current% de l'objectif", style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text("Objectif: $target%", style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: current / 100,
            minHeight: 6,
            backgroundColor: AppColors.lightTextPrimary.withValues(alpha: 0.1),
            color: AppColors.lightPrimary,
          ),
        ),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
    );
  }
}