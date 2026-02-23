import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/theme/app_colors.dart';
import '../../data/models/defi_model.dart';

class CommunityDefisListWidget extends StatelessWidget {
  final String entrepriseId;

  const CommunityDefisListWidget({Key? key, required this.entrepriseId}) : super(key: key);

  // LA MÉTHODE MANQUANTE EST BIEN LÀ
  Future<List<DefiModel>> _getActiveDefis() async {
    final client = Supabase.instance.client;
    
    // 1. On récupère tous les défis de l'entreprise (Table 'defis')
    final defisRes = await client.from('defis').select().eq('entreprise_id', entrepriseId);
    
    // 2. On cherche ceux qui sont ENCORE au stade de vote (Table 'defis_communautes')
    final pendingVotes = await client
        .from('defis_communautes')
        .select('defi_id')
        .inFilter('statut', ['VOTE_LANCEMENT', 'EN_ATTENTE_CIBLE']); // inFilter pour la compatibilité
        
    final pendingIds = (pendingVotes as List).map((v) => v['defi_id']).toSet();

    // 3. LE FILTRE : On ne garde que les défis qui NE SONT PAS en attente de vote
    final activeDefis = (defisRes as List)
        .where((d) => !pendingIds.contains(d['id']))
        .map((json) => DefiModel.fromJson(json))
        .toList();
        
    return activeDefis;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Récupération du thème actuel (clair ou sombre)
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FutureBuilder<List<DefiModel>>(
      future: _getActiveDefis(), // L'appel fonctionne maintenant
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ));
        }
        
        final defis = snapshot.data ?? [];
        if (defis.isEmpty) {
          // Texte adapté au thème
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Aucun défi actif pour le moment.", style: theme.textTheme.bodyMedium),
          );
        }

        return Column(
          children: defis.map((defi) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // UTILISATION DES COULEURS DU THÈME ADAPTATIVES
              color: isDark ? AppColors.darkInput : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder,
              ),
              boxShadow: isDark ? [] : [ // Ombre légère uniquement en mode clair
                 BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              children: [
                // Icône avec fond coloré
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Texte titre adapté
                      Text(defi.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      // Texte sous-titre adapté (couleur hint)
                      Text(defi.category, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                    ],
                  ),
                ),
                // Badge XP
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text("+${defi.xpGain} XP", style: const TextStyle(color: AppColors.lightPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          )).toList(),
        );
      },
    );
  }
}