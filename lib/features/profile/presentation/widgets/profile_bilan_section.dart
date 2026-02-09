import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/features/profile/presentation/widgets/profile_action_button.dart';

class ProfileBilanSection extends StatelessWidget {
  final int remainingQuestions;

  const ProfileBilanSection({
    super.key,
    required this.remainingQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (remainingQuestions > 0) ...[
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ProfileActionButton(
                  title: 'Compléter mon bilan',
                  subtitle: '$remainingQuestions questions restantes',
                  icon: LucideIcons.checkSquare,
                  iconColor: colorScheme.primary,
                  onTap: () {
                    // TODO: Navigation vers BilanFlow
                  },
                  showBorder: true,
                ),
                ProfileActionButton(
                  title: 'Reprendre le bilan',
                  subtitle: 'Modifier mes réponses',
                  icon: LucideIcons.rotateCcw,
                  iconColor: colorScheme.tertiary,
                  onTap: () {
                    // TODO: Reprise bilan
                  },
                  showBorder: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],

        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: ProfileActionButton(
            title: 'Actions écartées',
            icon: LucideIcons.ban,
            iconColor: colorScheme.onSurface.withValues(alpha: 0.5),
            onTap: () {
              // TODO: Modale actions écartées
            },
            showBorder: false,
          ),
        ),
      ],
    );
  }
}