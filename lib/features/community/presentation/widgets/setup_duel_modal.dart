import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/theme/app_colors.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/leaderboard_entry_model.dart';

class SetupDuelModal extends StatefulWidget {
  final LeaderboardEntryModel targetCommunity;
  final String myCommunityCode;
  final String entrepriseId;

  const SetupDuelModal({
    Key? key,
    required this.targetCommunity,
    required this.myCommunityCode,
    required this.entrepriseId,
  }) : super(key: key);

  @override
  State<SetupDuelModal> createState() => _SetupDuelModalState();
}

class _SetupDuelModalState extends State<SetupDuelModal> {
  String _selectedCategory = 'Quick Wins';
  int _selectedDuration = 7;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Quick Wins', 'icon': Icons.bolt},
    {'name': 'Transport', 'icon': Icons.directions_car},
    {'name': 'Alimentation', 'icon': Icons.restaurant},
    {'name': 'Énergie', 'icon': Icons.lightbulb_outline},
    {'name': 'Toutes', 'icon': Icons.track_changes},
  ];

  final List<int> _durations = [3, 7, 14, 30];

  Future<void> _launchChallenge() async {
    setState(() => _isLoading = true);
    try {
      final client = Supabase.instance.client;

      // 1. On prend une action correspondante dans la table 'actions'
      // (Prend la première action disponible comme base)
      final actionRes = await client
          .from('actions')
          .select()
          .limit(1)
          .maybeSingle();

      if (actionRes == null) {
        throw Exception("Aucune action trouvée dans la table 'actions' pour créer le duel.");
      }

      // 2. On prépare le terrain : Création du défi dans la table 'defis'
      final newDefi = await client.from('defis').insert({
        'entreprise_id': widget.entrepriseId,
        'titre': actionRes['titre'] ?? 'Duel communautaire',
        'description': actionRes['description'] ?? '',
        'xp_gain': actionRes['xp_gain'] ?? 100,
        'categorie_nom': _selectedCategory, // Catégorie choisie dans le modal
      }).select('id').single();

      // 3. On lance le vote dans 'defis_communautes'
      final ds = CommunityRemoteDataSource(client);
      await ds.proposeDuel(
        defiId: newDefi['id'], // On utilise l'ID tout neuf
        myCommunityCode: widget.myCommunityCode,
        targetCommunityCode: widget.targetCommunity.id,
        entrepriseId: widget.entrepriseId,
        durationDays: _selectedDuration,
      );

      if (mounted) {
        Navigator.pop(context); // Ferme le modal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vote lancé ! Le défi est en attente de validation."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // On ajoute des contraintes de hauteur et un scroll pour éviter l'overflow vertical
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView( // Correction de l'overflow vertical (92px)
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.military_tech, size: 40, color: AppColors.lightPrimary),
            const SizedBox(height: 16),
            Text("Lancer un défi ?", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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

            // Type de duel - Correction overflow horizontal avec Wrap
            const Align(alignment: Alignment.centerLeft, child: Text("Type de duel", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            Wrap( // Remplace la Row/SingleChildScrollView pour éviter l'overflow
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

            // Durée du duel - Correction overflow horizontal (320px) avec Wrap
            const Align(alignment: Alignment.centerLeft, child: Text("Durée du duel", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            Wrap( // Remplace la Row (ligne 186)
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
                child: const Text("Lance le vote", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}