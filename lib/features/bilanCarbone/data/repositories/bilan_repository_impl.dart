// features/bilanCarbone/data/repositories/bilan_session_repository_impl.dart

import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BilanSessionRepositoryImpl implements BilanSessionRepository {
  final SupabaseClient supabaseClient;

  BilanSessionRepositoryImpl({required this.supabaseClient});

  @override
  Future<int?> getBilanId(String userId) async {
    final response = await supabaseClient
        .from('bilan_carbone')
        .select('id')
        .eq('utilisateur_id', userId)
        .order('date_bilan', ascending: false)
        .limit(1)
        .maybeSingle();

    return response?['id'] as int?;
  }

  @override
  Future<void> createNewBilanSession(String userId) async {
    await supabaseClient.from('bilan_carbone').upsert({
      'utilisateur_id': userId,
      'date_bilan': DateTime.now().toIso8601String(),
      'scoretotalco2ean': 0,
      'complet': false,
    });
  }

  @override
  Future<void> setBilanScore(String userId, double score) async {
    await supabaseClient
        .from('bilan_carbone')
        .update({'scoretotalco2ean': score, 'complet': true})
        .eq('utilisateur_id', userId)
        .order('date_bilan', ascending: false)
        .limit(1);
  }

  @override
  Future<void> deleteBilan(String userId) async {
    await supabaseClient
        .from('bilan_carbone')
        .delete()
        .eq('utilisateur_id', userId)
        .order('date_bilan', ascending: false)
        .limit(1);
  }

  @override
  Future<bool> hasBilanEnCours(String userId) async {
    try {
      final response = await supabaseClient
          .from('bilan_carbone')
          .select('complet')
          .eq('utilisateur_id', userId)
          .order('date_bilan', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return false;

      // Si 'complet' est false, alors un bilan est en cours.
      final isComplet = response['complet'] ?? false;
      return !isComplet;
    } catch (e) {
      // On peut logger l'erreur ici si besoin
      return false;
    }
  }
}
