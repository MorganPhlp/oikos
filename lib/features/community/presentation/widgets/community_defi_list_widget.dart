import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/theme/app_colors.dart';
import '../../data/models/defi_model.dart';
import 'active_defi_details_modal.dart';

class CommunityDefisListWidget extends StatelessWidget {
  final String entrepriseId;
  final String communityCode;

  const CommunityDefisListWidget({
    Key? key, 
    required this.entrepriseId, 
    required this.communityCode
  }) : super(key: key);

  Future<List<DefiModel>> _getActiveDefis() async {
    final client = Supabase.instance.client;
    
    // 1. On récupère tous les défis de l'entreprise (Table 'defis')
    final defisRes = await client.from('defis').select().eq('entreprise_id', entrepriseId);
    
    // 2. On cherche ceux qui sont ENCORE au stade de vote (Table 'defis_communautes')
    final pendingVotes = await client
        .from('defis_communautes')
        .select('defi_id')
        .inFilter('statut', ['VOTE_LANCEMENT', 'EN_ATTENTE_CIBLE']);
        
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FutureBuilder<List<DefiModel>>(
      future: _getActiveDefis(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final defis = snapshot.data ?? [];
        if (defis.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Aucun défi actif pour le moment.", 
              style: theme.textTheme.bodyMedium
            ),
          );
        }

        return Column(
          children: defis.map((defi) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkInput : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder,
                ),
                boxShadow: isDark ? [] : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              // On utilise Material pour que le InkWell puisse afficher l'effet de clic
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    // On attend potentiellement un retour pour rafraîchir la liste
                    final result = await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ActiveDefiDetailsModal(
                        defi: defi,
                        communityCode: communityCode,
                      ),
                    );
                    
                    // Si l'action a été validée dans le modal, on pourrait rafraîchir ici
                    // if (result == true) { /* callback de refresh */ }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.emoji_events, 
                            color: Colors.amber, 
                            size: 24
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                defi.title, 
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              const SizedBox(height: 4),
                              Text(
                                defi.category, 
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor
                                )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, 
                            vertical: 6
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "+${defi.xpGain} XP", 
                            style: const TextStyle(
                              color: AppColors.lightPrimary, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 12
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}