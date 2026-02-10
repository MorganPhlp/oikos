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
    final Color mainColor = isCompleted ? Colors.grey : const Color(0xFF76B82A);
    final Color bgColor = isCompleted ? Colors.grey.shade50 : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isCompleted)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
        border: isCompleted ? Border.all(color: Colors.grey.shade200) : null,
      ),
      child: Row(
        children: [
          // 1. ICONE RONDE
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(action.icon, color: mainColor, size: 24),
          ),
          const SizedBox(width: 15),

          // 2. TEXTES
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Titre
                    Expanded(
                      child: Text(
                        action.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? Colors.grey : Colors.black87,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    // PETITE POUBELLE DISCRÈTE
                    if (!isCompleted) // On cache la poubelle si c'est validé aujourd'hui (optionnel)
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(Icons.close, size: 18, color: Colors.grey[400]),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  action.description,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Points
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "+${action.points} pts",
                    style: TextStyle(color: Colors.orange[700], fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(width: 10),

          // 3. BOUTON CHECK
          GestureDetector(
            onTap: isCompleted ? null : onValidate,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green[100] : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? Colors.transparent : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.green, size: 24)
                  : Icon(Icons.circle_outlined, color: Colors.grey.shade300, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}