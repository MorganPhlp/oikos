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
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.outline, width: 1),
          // Ombre uniquement en mode clair
          boxShadow: isDarkMode
              ? null
              : [
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
                  // Icône avec fond coloré selon la catégorie
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

                  // Titre et description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          action.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          action.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.onSurface.withOpacity(0.6),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Badge de catégorie
              Row(
                children: [
                  _buildTag(action.categoryName, _getCategoryColor(action.categoryName)),
                ],
              ),
              const SizedBox(height: 12),

              Divider(height: 1, color: colors.outline),
              const SizedBox(height: 12),

              // Infos : CO2, difficulté et fréquence
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStat(action.co2Saved, colors.primary, isBold: true),
                  _buildDot(colors),
                  _buildStat(action.difficulty, colors.onSurface.withOpacity(0.5)),
                  _buildDot(colors),
                  _buildStat(_getFreqLabel(action.frequency), colors.onSurface.withOpacity(0.5)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Fonctions d'affichage ---

  // Simplifie le texte de fréquence venant de la base
  String _getFreqLabel(String freq) {
    String f = freq.toLowerCase().trim();
    if (f.contains('quotidien') || f.contains('jour')) return 'Quotidien';
    if (f.contains('hebdo') || f.contains('semaine')) return 'Hebdo';
    if (f.contains('mensuel') || f.contains('mois')) return 'Mensuel';
    if (f.contains('unique') || f.contains('bonus') || f.contains('shot')) return 'Bonus';
    return 'Action';
  }

  // Attribue une couleur selon la catégorie
  Color _getCategoryColor(String category) {
    String cat = category.toLowerCase().trim();
    if (cat.contains('transport') || cat.contains('mobilité')) return const Color(0xFF76B82A);
    if (cat.contains('alimentation') || cat.contains('nourriture')) return Colors.orange;
    if (cat.contains('eau')) return Colors.blue;
    if (cat.contains('energie') || cat.contains('énergie')) return Colors.amber;
    if (cat.contains('déchet') || cat.contains('dechet')) return Colors.brown;
    return Colors.grey;
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildStat(String text, Color color, {bool isBold = false}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildDot(ColorScheme colors) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: colors.outline,
        shape: BoxShape.circle,
      ),
    );
  }
}