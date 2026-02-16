import 'package:flutter/material.dart';
import '../../domain/entities/action_entity.dart';

class ActionCard extends StatelessWidget {
  final ActionEntity action;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ICONE
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(action.categoryName).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action.icon,
                      color: _getCategoryColor(action.categoryName),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // TEXTES
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          action.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          action.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // TAGS
              Row(
                children: [
                  _buildTag(action.categoryName, Colors.blue),
                ],
              ),
              const SizedBox(height: 12),

              Divider(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 12),

              // STATS EN BAS (C'est ici qu'on corrige le Hebdo)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStat(action.co2Saved, Colors.green, isBold: true),
                  _buildDot(),
                  _buildStat(action.difficulty, Colors.grey),
                  _buildDot(),
                  // 👇 CORRECTION ICI : On affiche la vraie fréquence
                  _buildStat(_getFreqLabel(action.frequency), Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helpers
  String _getFreqLabel(String freq) {
    switch (freq) {
      case 'journalier': return 'Quotidien';
      case 'hebdomadaire': return 'Hebdo';
      case 'mensuel': return 'Mensuel';
      case 'unique': return 'One Shot';
      default: return 'Action';
    }
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildStat(String text, Color color, {bool isBold = false}) {
    return Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal));
  }

  Widget _buildDot() {
    return Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle));
  }

  Color _getCategoryColor(String category) {
    // Tu peux ajuster les couleurs ici
    if (category.contains('Transport')) return const Color(0xFF76B82A);
    if (category.contains('Alimentation')) return Colors.orange;
    if (category.contains('Eau')) return Colors.blue;
    return Colors.grey;
  }
}