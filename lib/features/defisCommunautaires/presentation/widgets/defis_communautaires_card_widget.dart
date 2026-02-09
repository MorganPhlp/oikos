import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_colors.dart';

class DefisCommunautairesCardWidget extends StatelessWidget {
  const DefisCommunautairesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Actions Collectives",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(LucideIcons.users, color: theme.colorScheme.primary),
          ],
        ),
        const SizedBox(height: 16),

        // TODO : remplacer par une ListView.builder avec les vrais défis communautaires (necessite la structure)
        const _ChallengeCard(
          title: "Semaine vélo",
          description: "Viens à vélo au moins 3 jours cette semaine",
          icon: "🚴",
          points: 100,
          currentProgress: 45,
          requiredPercentage: 60,
          activeUsers: 120,
          deadline: "4 jours",
          categories: ["Vélo"],
        ),
        const SizedBox(height: 12),
        const _ChallengeCard(
          title: "Repas végé collectif",
          description: "Mange végétarien au moins 2 fois cette semaine",
          icon: "🥗",
          points: 75,
          currentProgress: 72,
          requiredPercentage: 60,
          activeUsers: 86,
          deadline: "6 jours",
          categories: ["Végé", "Anti-gaspi"],
        ),
      ],
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.tertiary;

    return GestureDetector(
      onTap: () {
        // TODO : Naviguer vers la page de détail du défi
      },
      child: Stack(
        children: [
          // Fond de la carte
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: goldColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: goldColor.withValues(alpha: 0.1),
                  blurRadius: 12,
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
                        gradient: LinearGradient(
                          colors: [goldColor, goldColor.withValues(alpha: 0.7)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(icon, style: const TextStyle(fontSize: 24)),
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
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.lightTextPrimary.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "+$points pts",
                      style: const TextStyle(
                        color: AppColors.lightPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 6,
                  children: categories
                      .map((cat) => _CategoryBadge(label: cat))
                      .toList(),
                ),
                const SizedBox(height: 12),

                _ProgressBar(
                  current: currentProgress,
                  target: requiredPercentage,
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.users,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$activeUsers participants",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$deadline restants",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.lightPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
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
                  colors: [
                    goldColor.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(60),
                ),
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
            Text(
              "$current% de participation",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Text(
              "Objectif: $target%",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
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
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
