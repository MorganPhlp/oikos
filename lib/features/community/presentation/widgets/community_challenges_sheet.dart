import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/community_remote_datasource.dart';
import 'package:oikos/core/theme/app_colors.dart';
import '../../data/models/community_action_model.dart';
import 'community_challenges_card_widget.dart';

class CommunityChallengesSheet extends StatefulWidget {
  final List<CommunityActionModel> actions;
  final String entrepriseId;
  final String myCommunityCode;

  const CommunityChallengesSheet({
    Key? key,
    required this.actions,
    required this.entrepriseId,
    required this.myCommunityCode,
  }) : super(key: key);

  @override
  State<CommunityChallengesSheet> createState() => _CommunityChallengesSheetState();
}

class _CommunityChallengesSheetState extends State<CommunityChallengesSheet> {
  int _currentView = 0;
  bool _isLoading = false;
  List<String> _activeActionIds = [];

  @override
  void initState() {
    super.initState();
    _fetchActiveChallenges(); 
  }

  // On récupère les défis actifs
  Future<void> _fetchActiveChallenges() async {
    try {
      final res = await Supabase.instance.client
          .from('action_communautaire')
          .select('action_id')
          .eq('entreprise_id', widget.entrepriseId)
          .gt('date_fin', DateTime.now().toIso8601String());

      if (mounted) {
        setState(() {
          _activeActionIds = (res as List).map((e) => e['action_id'].toString()).toList();
        });
      }
    } catch (e) {
      debugPrint("Erreur vérification doublons: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (_currentView != 0)
                IconButton(
                  icon: Icon(Icons.arrow_back, color: isDark ? AppColors.darkForeground : AppColors.lightForeground),
                  onPressed: () => setState(() => _currentView = 0),
                ),
              Expanded(
                child: Text(
                  _currentView == 0 ? "Défis de communautés" 
                : _currentView == 1 ? "Actions en cours" 
                : "Lancer un défi",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkForeground : AppColors.lightTextPrimary,
                  ),
                  textAlign: _currentView == 0 ? TextAlign.center : TextAlign.left,
                ),
              ),
              if (_currentView == 0) const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: _currentView == 0 
                ? _buildMainMenu(isDark) 
                : _currentView == 1 
                    ? _buildCurrentChallenges(isDark) 
                    : _buildActionsList(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenu(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBigChoiceButton(
          title: "Actions en cours",
          subtitle: "Rejoins les défis actifs et fais gagner des points à ta communauté",
          icon: Icons.list_alt,
          color: AppColors.lightPrimary,
          isDark: isDark,
          onTap: () => setState(() => _currentView = 1),
        ),
        const SizedBox(height: 24),
        Text("OU", style: TextStyle(color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildBigChoiceButton(
          title: "Défier les autres",
          subtitle: "Choisis une action et lance un défi à ta communauté",
          icon: Icons.sports_kabaddi,
          color: AppColors.orange,
          isDark: isDark,
          onTap: () => setState(() => _currentView = 2),
        ),
      ],
    );
  }

  Widget _buildBigChoiceButton({
    required String title, required String subtitle, required IconData icon, 
    required Color color, required bool isDark, required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkInput : AppColors.lightInput,
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.15), radius: 30, child: Icon(icon, color: color, size: 30)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? AppColors.darkForeground : AppColors.lightTextPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentChallenges(bool isDark) {
    return SingleChildScrollView(
      child: CommunityChallengesCardWidget( 
        entrepriseId: widget.entrepriseId,
        myCommunityCode: widget.myCommunityCode, 
      ),
    );
  }

  Widget _buildActionsList(bool isDark) {
    if (widget.actions.isEmpty) {
      return Center(child: Text("Aucune action disponible.", style: TextStyle(color: isDark ? AppColors.darkForeground : AppColors.lightForeground)));
    }

    return ListView.builder(
      itemCount: widget.actions.length,
      itemBuilder: (context, index) {
        final action = widget.actions[index];
        final isAlreadyActive = _activeActionIds.contains(action.id); 

        return Card(
          color: isDark ? AppColors.darkInput : AppColors.lightInput,
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.lightPrimary.withOpacity(0.2),
                      child: const Icon(Icons.bolt, color: AppColors.lightPrimary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        action.title, 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? AppColors.darkForeground : AppColors.lightTextPrimary)
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: AppColors.orange),
                          const SizedBox(width: 4),
                          Text("${action.xpGain} XP", style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  action.subtitle, 
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground, fontSize: 14)
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAlreadyActive ? Colors.grey : AppColors.lightPrimary, 
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: isAlreadyActive || _isLoading ? null : () async {
                      setState(() => _isLoading = true);
                      
                      try {
                        final dataSource = CommunityRemoteDataSource(Supabase.instance.client);
                        
                        await dataSource.createCommunityChallenge(
                          entrepriseId: widget.entrepriseId,
                          actionId: action.id, 
                          titrePersonnalise: "Défi : ${action.title}",
                          daysDuration: 7, 
                        );

                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            _activeActionIds.add(action.id); 
                          });
                          Navigator.pop(context); 
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Le défi a été lancé avec succès ! 🎉"), backgroundColor: AppColors.lightPrimary),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() => _isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Erreur lors du lancement.")),
                          );
                        }
                      }
                    },
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(isAlreadyActive ? "Défi déjà en cours ⏳" : "Lancer ce défi", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}