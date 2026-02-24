import 'package:flutter/material.dart';
import '../../domain/entities/action_entity.dart';

class ChallengeCard extends StatelessWidget {
  final ActionEntity action;
  final bool isCompleted;
  final VoidCallback onValidate;
  final VoidCallback onDelete;

  const ChallengeCard({
    super.key,
    required this.action,
    required this.isCompleted,
    required this.onValidate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Définition des couleurs selon si l'action est terminée ou non
    final Color mainColor = isCompleted ? colors.onSurface.withOpacity(0.4) : colors.primary;
    final Color bgColor = colors.surface;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        // Ombre légère uniquement en mode clair et pour les défis actifs
        boxShadow: (!isCompleted && !isDarkMode)
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
        border: Border.all(
          color: isCompleted ? colors.outline.withOpacity(0.5) : colors.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Icône ronde à gauche
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(action.icon, color: mainColor, size: 24),
          ),
          const SizedBox(width: 15),

          // Textes : Titre, description et points
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Titre du défi (barré si terminé)
                    Expanded(
                      child: Text(
                        action.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? colors.onSurface.withOpacity(0.5) : colors.onSurface,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    // Bouton pour supprimer le défi de sa liste
                    if (!isCompleted)
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(Icons.close, size: 18, color: colors.onSurface.withOpacity(0.4)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                Text(
                  action.description,
                  style: TextStyle(color: colors.onSurface.withOpacity(0.5), fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Petit badge affichant les points gagnés
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "+${action.points} pts",
                    style: TextStyle(
                      color: colors.tertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Bouton de validation (Cercle à cocher)
          GestureDetector(
            onTap: isCompleted ? null : onValidate,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? colors.primary.withOpacity(0.15) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? Colors.transparent : colors.outline,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(Icons.check, color: colors.primary, size: 24)
                  : Icon(Icons.circle_outlined, color: colors.outline, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}