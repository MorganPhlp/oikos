import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/community/presentation/widgets/validate_action_button.dart';
import 'package:oikos/init_dependencies.dart';
import '../../domain/repositories/community_repository.dart';
import '../../domain/models/active_challenge_model.dart';

class CommunityChallengesCardWidget extends StatefulWidget {
  final String entrepriseId;
  final String myCommunityCode;

  const CommunityChallengesCardWidget({
    super.key,
    required this.entrepriseId,
    required this.myCommunityCode,
  });

  @override
  State<CommunityChallengesCardWidget> createState() =>
      _CommunityChallengesCardWidgetState();
}

class _CommunityChallengesCardWidgetState
    extends State<CommunityChallengesCardWidget> {
  List<ActiveChallengeModel> _challenges = [];
  bool _isLoading = true;
  int _requiredParticipants = 1;
  late final CommunityRepository _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = serviceLocator<CommunityRepository>();
    _loadChallenges(); // Premier chargement (avec icône de chargement)
  }

  // MODIFICATION 1 : Ajout de "showLoading" pour permettre le rechargement silencieux
  Future<void> _loadChallenges({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final required = await _dataSource.getRequiredVotes(
        widget.myCommunityCode,
      );
      // 2. On récupère les défis
      final results = await _dataSource.getActiveChallenges(
        widget.entrepriseId,
      );

      if (mounted) {
        setState(() {
          _requiredParticipants = required; // On sauvegarde l'objectif
          _challenges = results
              .map(
                (e) =>
                    ActiveChallengeModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _joinAndValidateChallenge(ActiveChallengeModel challenge) async {
    try {
      // 1. L'appel à ta DataSource pour enregistrer la participation
      await _dataSource.validateCollectiveAction(
        instanceId: challenge.id,
        baseActionId: challenge.baseActionId,
        communityCode: widget.myCommunityCode,
        xpGain: challenge.xpGain,
      );

      // 3. Succès et rechargement silencieux
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Action validée ! +${challenge.xpGain} XP 🎉"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // On recharge les données SANS faire clignoter l'écran
        _loadChallenges(showLoading: false);
      }
    } catch (e) {
      String message = "Erreur lors de la validation";
      if (e.toString().contains("23505")) {
        message = "Tu as déjà validé cette action !";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.orange),
        );
        // On recharge les données SANS faire clignoter l'écran en cas d'erreur
        _loadChallenges(showLoading: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_challenges.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                LucideIcons.frown,
                size: 40,
                color: Colors.grey.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              const Text(
                "Aucune action collective en cours.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _challenges.map((challenge) {
        final daysLeft = challenge.dateFin.difference(DateTime.now()).inDays;
        final deadlineText = daysLeft > 0
            ? "$daysLeft jours restants"
            : "Dernier jour !";

        // Calcul du progrès par rapport à l'objectif dynamique
        final target = _requiredParticipants;
        final progress = (challenge.participantsCount / target * 100)
            .clamp(0, 100) // Empêche de dépasser 100% visuellement
            .toInt();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _ChallengeCard(
            title: challenge.title,
            description: challenge.description,
            icon: "⚡",
            points: challenge.xpGain,
            currentProgress: progress,
            targetParticipants: target,
            activeUsers: challenge.participantsCount,
            deadline: deadlineText,
            isJoined: challenge.isJoined,
            // C'est ici que l'action s'enclenche !
            onTap: challenge.isJoined
                ? null
                : () => _joinAndValidateChallenge(challenge),
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
  final int targetParticipants;
  final int activeUsers;
  final String deadline;
  final bool isJoined;
  final VoidCallback? onTap;

  const _ChallengeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    required this.currentProgress,
    required this.targetParticipants,
    required this.activeUsers,
    required this.deadline,
    required this.isJoined,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = theme.colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goldColor.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
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
                  color: goldColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: theme.hintColor),
                    ),
                  ],
                ),
              ),
              Text(
                "+$points XP",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _ProgressBar(current: currentProgress, target: targetParticipants),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.users, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "$activeUsers participant(s)",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  deadline,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.lightPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: theme.dividerColor.withValues(alpha: 0.1)),
          const SizedBox(height: 8),
          Center(
            child: ValidateActionButton(
              isValidated: isJoined,
              onPressed: onTap,
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
            Text(
              "$current% de l'objectif",
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            Text(
              // CORRECTION ICI : "participant(s)" au lieu de "%"
              "Objectif : $target participant(s)",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: current / 100),
            duration: const Duration(seconds: 1),
            builder: (BuildContext context, double value, Widget? child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.grey.withValues(alpha: 0.1),
                color: AppColors.lightPrimary,
              );
            },
          ),
        ),
      ],
    );
  }
}
