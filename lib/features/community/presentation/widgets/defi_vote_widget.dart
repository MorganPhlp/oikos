import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';

class DefiVoteWidget extends StatelessWidget {
  final String title;
  final int currentVotes;
  final int totalRequired; // Le nombre total de membres ACTIF * 0.6
  final VoidCallback onVote;
  final bool hasVoted;

  const DefiVoteWidget({
    Key? key,
    required this.title,
    required this.currentVotes,
    required this.totalRequired,
    required this.onVote,
    required this.hasVoted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = (currentVotes / totalRequired).clamp(0.0, 1.0);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInput : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder,
        ),
        // Ombre légère ajoutée pour s'harmoniser avec les autres cartes
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligne les textes à gauche
        children: [
          Text(
            "Vote pour lancer : $title",
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          // ClipRRect permet d'arrondir les bords de la barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              // On adapte le fond de la barre de progression au thème
              backgroundColor: isDark ? AppColors.darkBorder : Colors.grey[200],
              color: AppColors.lightPrimary,
              minHeight: 8,
            ),
          ),
          
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$currentVotes vote(s)",
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
              Text(
                "Objectif : $totalRequired",
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Bouton pleine largeur
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // Couleur de fond selon l'état (Voté ou Non) et le thème
                backgroundColor: hasVoted
                    ? (isDark ? AppColors.darkBorder : Colors.grey[200])
                    : AppColors.lightPrimary,
                // Couleur du texte
                foregroundColor: hasVoted
                    ? (isDark ? Colors.grey[400] : Colors.grey[600])
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: hasVoted ? null : onVote,
              child: Text(
                hasVoted ? "Tu as déjà voté" : "Vote pour ce défi",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}