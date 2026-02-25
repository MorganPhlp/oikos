import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/theme/app_colors.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/leaderboard_entry_model.dart';
=======
import 'package:oikos/features/community/domain/entities/community_entity.dart';
>>>>>>> dev/defis

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

<<<<<<< HEAD
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isVote ? Icons.how_to_vote : Icons.sports_kabaddi, size: 50, color: AppColors.lightPrimary),
        const SizedBox(height: 16),
        Text(
          isVote ? "Vote en cours" : "Défi en cours", 
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 12),
        Text(
          "Un défi est déjà actif avec ${widget.targetCommunity.label}. Tu dois le terminer avant d'en lancer un nouveau.",
          textAlign: TextAlign.center,
          style: TextStyle(color: theme.hintColor),
        ),
        const SizedBox(height: 24),
        
        // Carte du défi existant avec le style "Dernier jour"
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.lightPrimary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightPrimary.withOpacity(0.2)),
=======
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
>>>>>>> dev/defis
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
<<<<<<< HEAD
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child:
          //Bouton compris dans le style de l'app, qui ferme le modal
          GradientButton(
          onPressed: () => Navigator.pop(context),
          label: "Compris",
=======
              ],
            ),
>>>>>>> dev/defis
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD


  /// Vue par défaut : Formulaire de création
  Widget _buildCreationForm(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.military_tech, size: 40, color: AppColors.lightPrimary),
        const SizedBox(height: 16),
        Text("Tu veux lancer un défi ?", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        
        const SizedBox(height: 24),

        // Carte Adversaire
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightPrimary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightPrimary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: Colors.orange.withOpacity(0.2), child: const Icon(Icons.groups, color: Colors.orange)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.targetCommunity.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Communauté adverse", style: TextStyle(fontSize: 12, color: theme.hintColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Type de duel
        const Align(alignment: Alignment.centerLeft, child: Text("Type d'action (Tirage au sort)", style: TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _categories.map((cat) {
            bool isSelected = _selectedCategory == cat['name'];
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat['name']),
              child: Container(
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.lightPrimary : Colors.transparent,
                  border: Border.all(color: isSelected ? AppColors.lightPrimary : Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(cat['icon'], color: isSelected ? Colors.white : theme.hintColor, size: 20),
                    const SizedBox(height: 4),
                    Text(cat['name'], style: TextStyle(color: isSelected ? Colors.white : theme.hintColor, fontSize: 11)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Durée du duel
        const Align(alignment: Alignment.centerLeft, child: Text("Durée du défi", style: TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: _durations.map((d) {
            bool isSelected = _selectedDuration == d;
            return GestureDetector(
              onTap: () => setState(() => _selectedDuration = d),
              child: Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.transparent,
                  border: Border.all(color: isSelected ? Colors.green : Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text("${d}j", style: TextStyle(color: isSelected ? Colors.white : null, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _isLoading ? null : _launchChallenge, 
            child: _isLoading 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("Tirer au sort et Lancer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
=======
}
>>>>>>> dev/defis
