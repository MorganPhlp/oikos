import 'package:flutter/material.dart';
import 'package:oikos/features/community/domain/entities/community_entity.dart';

class SetupDuelModal extends StatefulWidget {
  final CommunityEntity targetCommunity;
  final String myCommunity;
  final String userId;
  // Ajout du userId dans le callback pour le creatorId
  final Function(String category, int duration, String creatorId) onConfirm;

  const SetupDuelModal({
    super.key,
    required this.targetCommunity,
    required this.myCommunity,
    required this.onConfirm,
    required this.userId,
  });

  @override
  State<SetupDuelModal> createState() => _SetupDuelModalState();
}

class _SetupDuelModalState extends State<SetupDuelModal> {
  String _selectedCategory = 'Toutes';
  int _selectedDuration = 7;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Transport', 'icon': Icons.directions_car},
    {'name': 'Alimentation', 'icon': Icons.restaurant},
    {'name': 'Energie & Eau', 'icon': Icons.lightbulb_outline},
    {'name': 'Consommation & Dechets', 'icon': Icons.recycling},
    {'name': 'Numérique', 'icon': Icons.computer},
  ];

  final List<int> _durations = [3, 7, 14, 30];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barre de drag (Handle)
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Icon(Icons.military_tech, size: 40, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            "Lancer un duel",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _TargetTeamCard(targetCommunity: widget.targetCommunity),

          const SizedBox(height: 24),

          _buildSectionTitle(theme, "Catégorie (Tirage au sort)"),
          const SizedBox(height: 12),
          _buildCategoryGrid(theme),

          const SizedBox(height: 24),

          _buildSectionTitle(theme, "Durée du défi"),
          const SizedBox(height: 12),
          _buildDurationPicker(theme),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // On passe bien le userId comme creatorId
                widget.onConfirm(
                  _selectedCategory,
                  _selectedDuration,
                  widget.userId,
                );
                Navigator.pop(context);
              },
              child: const Text(
                "Tirer au sort et Lancer",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _categories.map((cat) {
        final isSelected = _selectedCategory == cat['name'];
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat['name']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onPrimary.withValues(alpha: 0.3),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : theme.dividerColor.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  cat['icon'],
                  color: isSelected ? colorScheme.onPrimary : theme.hintColor,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  cat['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? colorScheme.onPrimary : theme.hintColor,
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDurationPicker(ThemeData theme) {
    return Wrap(
      spacing: 12,
      children: _durations.map((d) {
        final isSelected = _selectedDuration == d;
        return GestureDetector(
          onTap: () => setState(() => _selectedDuration = d),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? Colors.green
                    : theme.dividerColor.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "${d}j",
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TargetTeamCard extends StatelessWidget {
  final CommunityEntity targetCommunity;
  const _TargetTeamCard({required this.targetCommunity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.orange.withValues(alpha: 0.2),
            child: const Icon(Icons.bolt, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  targetCommunity.nom,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Équipe adverse",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
