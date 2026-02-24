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
  String _selectedCategory = 'Toutes'; 
  int _selectedDuration = 7;
  bool _isLoading = false;

  // Variables pour vérifier l'existence d'un défi
  bool _isCheckingDuel = true;
  Map<String, dynamic>? _existingDuel;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Transport', 'icon': Icons.directions_car},
    {'name': 'Alimentation', 'icon': Icons.restaurant},
    {'name': 'Énergie', 'icon': Icons.lightbulb_outline},
    {'name': 'Toutes', 'icon': Icons.track_changes},
  ];

  final List<int> _durations = [3, 7, 14, 30];

  @override
  void initState() {
    super.initState();
    _checkExistingDuel(); // Vérifie s'il y a déjà un défi en cours
  }

  /// Vérifie si un duel (en vote ou actif) existe déjà entre ces deux communautés
  Future<void> _checkExistingDuel() async {
    try {
      final client = Supabase.instance.client;
      // On vérifie dans les deux sens (Demandeur->Cible OU Cible->Demandeur)
      final res = await client.from('defis_communautes')
          .select('*, defis(titre)')
          .or('and(communaute_demandeur_code.eq.${widget.myCommunityCode},communaute_cible_code.eq.${widget.targetCommunity.id}),and(communaute_demandeur_code.eq.${widget.targetCommunity.id},communaute_cible_code.eq.${widget.myCommunityCode})')
          .inFilter('statut', ['VOTE_LANCEMENT', 'ACTIF'])
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _existingDuel = res;
          _isCheckingDuel = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isCheckingDuel = false);
    }
  }

  /// Filtre les actions, tire au sort, et lance le défi
  Future<void> _launchChallenge() async {
    setState(() => _isLoading = true);
    try {
      final client = Supabase.instance.client;

      // 1. Filtrage strict par catégorie
      List<dynamic> actionsList = [];
      final query = client.from('actions').select();

      if (_selectedCategory == 'Alimentation') {
        actionsList = await query.eq('categorie_nom', 'Alimentation');
      } else if (_selectedCategory == 'Transport') {
        actionsList = await query.eq('categorie_nom', 'Transport');
      } else if (_selectedCategory == 'Énergie') {
        // Regroupe les catégories liées à l'énergie/habitat
        actionsList = await query.inFilter('categorie_nom', ['Eau', 'Consommation & Dechets', 'Numerique', 'Logement']);
      } else {
        actionsList = await query; // 'Toutes'
      }

      if (actionsList.isEmpty) {
        throw Exception("Aucune action trouvée dans la base de données pour cette catégorie.");
      }

      // 2. TIRAGE AU SORT 🎲
      actionsList.shuffle();
      final actionRes = actionsList.first;

      // 3. Création du défi dans la table 'defis'
      final newDefi = await client.from('defis').insert({
        'entreprise_id': widget.entrepriseId,
        'titre': actionRes['titre'] ?? 'Défi communautaire',
        'description': actionRes['description'] ?? '',
        'xp_gain': actionRes['xp_gain'] ?? 100,
        'categorie_nom': actionRes['categorie_nom'], // On garde la vraie catégorie tirée
      }).select('id').single();

      // 4. Lancement du vote dans 'defis_communautes'
      final ds = CommunityRemoteDataSource(client);
      await ds.proposeDuel(
        defiId: newDefi['id'],
        myCommunityCode: widget.myCommunityCode,
        targetCommunityCode: widget.targetCommunity.id,
        entrepriseId: widget.entrepriseId,
        durationDays: _selectedDuration,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Défi tiré au sort et lancé ! Vote en cours."),
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
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: _isCheckingDuel 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              child: _existingDuel != null 
                  ? _buildExistingDuelView(context) // Affiche l'écran de blocage (Défi en cours)
                  : _buildCreationForm(context),    // Affiche le formulaire de création normal
            ),
    );
  }

  /// Vue affichée si un défi existe DÉJÀ entre ces deux communautés
  Widget _buildExistingDuelView(BuildContext context) {
    final theme = Theme.of(context);
    final statut = _existingDuel!['statut'];
    final titre = _existingDuel!['defis'] != null ? _existingDuel!['defis']['titre'] : 'Défi en cours';
    
    // Calcul du temps restant (sur date_fin ou date_expiration selon le statut)
    final String dateString = _existingDuel!['date_fin'] ?? _existingDuel!['date_expiration'] ?? DateTime.now().toIso8601String();
    final targetDate = DateTime.parse(dateString);
    final daysLeft = targetDate.difference(DateTime.now()).inDays;
    
    final deadlineText = daysLeft > 0 ? "$daysLeft jours restants" : "Dernier jour !";
    final isVote = statut == 'VOTE_LANCEMENT';

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
          ),
          child: Column(
            children: [
              Text(titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              
              // Le badge vert de temps restant (comme sur la capture)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3D31), // Vert très foncé
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  deadlineText, 
                  style: const TextStyle(color: Color(0xFF81C784), fontWeight: FontWeight.bold), // Vert clair
                ),
              ),
            ],
          ),
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
            onPressed: () => Navigator.pop(context),
            child: const Text("Compris", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

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