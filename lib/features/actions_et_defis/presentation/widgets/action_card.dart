import 'package:flutter/material.dart';

import '../../domain/entities/action_entity.dart';

class ActionCard extends StatelessWidget {
  final ActionEntity action;
  final VoidCallback onTap;

  const ActionCard({super.key, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryColor = getCategoryColor(action.categoryName, colorScheme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bande de couleur catégorie en haut
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icône avec couleur catégorie
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              categoryColor.withValues(alpha: 0.15),
                              categoryColor.withValues(alpha: 0.30),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: categoryColor.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          action.icon,
                          color: categoryColor,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Titre + description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              action.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              action.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Chips : sous-catégories (mock tags)
                  if (action.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: action.tags
                          .take(3)
                          .map((tag) => _buildSubTag(context, tag))
                          .toList(),
                    ),
                  if (action.tags.isNotEmpty) const SizedBox(height: 12),

                  Divider(
                    height: 1,
                    color: colorScheme.outline.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 12),

                  // Stats : Points · Difficulté · Fréquence
                  Row(
                    children: [
                      _buildStatChip(
                        context,
                        Icons.bolt,
                        '${action.impactScore} pts',
                        colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      _buildStatChip(
                        context,
                        Icons.speed,
                        action.difficulty,
                        colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                      const SizedBox(width: 10),
                      _buildStatChip(
                        context,
                        Icons.schedule,
                        _getFreqLabel(action.frequency),
                        colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Helpers ---------------------------------------------------------------

  String _getFreqLabel(String freq) {
    switch (freq) {
      case 'journalier':
        return 'Quotidien';
      case 'hebdomadaire':
        return 'Hebdo';
      case 'mensuel':
        return 'Mensuel';
      case 'unique':
        return 'Bonus';
      default:
        return freq;
    }
  }

  Widget _buildSubTag(BuildContext context, String tag) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Couleur par catégorie – exposée en static pour réutilisation.
  static Color getCategoryColor(String category, ColorScheme colorScheme) {
    final lower = category.toLowerCase();
    if (lower.contains('transport')) return const Color(0xFF4CAF50);
    if (lower.contains('alimentation')) return const Color(0xFFFF9800);
    if (lower.contains('énergie') || lower.contains('energie')) {
      return const Color(0xFFFFC107);
    }
    if (lower.contains('eau')) return const Color(0xFF2196F3);
    if (lower.contains('déchet') || lower.contains('dechet')) {
      return const Color(0xFF795548);
    }
    if (lower.contains('numérique') || lower.contains('numerique')) {
      return const Color(0xFF9C27B0);
    }
    if (lower.contains('logement')) return const Color(0xFF607D8B);
    if (lower.contains('biodiversité') || lower.contains('biodiversite')) {
      return const Color(0xFF009688);
    }
    if (lower.contains('textile') || lower.contains('mode')) {
      return const Color(0xFFE91E63);
    }
    return colorScheme.primary;
  }
}
