import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/detail_bilan_entity.dart';

abstract interface class DashboardRemoteDataSource {
  Future<String> getMyPseudo();

  /// Dernier bilan carbone complété (score + détail par catégorie).
  /// Retourne `null` si aucun bilan complété n'existe.
  Future<({double scoreTotalKg, DetailBilanEntity detail})?> getMyLatestCompletedBilan();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final SupabaseClient supabaseClient;
  DashboardRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<String> getMyPseudo() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw AuthException('User not logged in');
    }

    final data = await supabaseClient
        .from('utilisateur')
        .select('pseudo')
        .eq('id', user.id)
        .single();

    final pseudo = data['pseudo'] as String?;
    if (pseudo == null || pseudo.isEmpty) {
      throw Exception('Pseudo not found');
    }

    return pseudo;
  }

  @override
  Future<({double scoreTotalKg, DetailBilanEntity detail})?> getMyLatestCompletedBilan() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw AuthException('User not logged in');
    }

    final bilan = await supabaseClient
        .from('bilan_carbone')
        .select('id, scoretotalco2ean, complet')
        .eq('utilisateur_id', user.id)
        .eq('complet', true)
        .order('date_bilan', ascending: false)
        .limit(1)
        .maybeSingle();

    if (bilan == null) return null;

    final bilanId = bilan['id'] as int?;
    if (bilanId == null) {
      throw Exception('Bilan id not found');
    }

    final scoreTotalKg = (bilan['scoretotalco2ean'] as num?)?.toDouble() ?? 0.0;

    final detailRes = await supabaseClient
        .from('detail_bilan')
        .select('transport, alimentation, logement, divers, services_societaux')
        .eq('id', bilanId)
        .maybeSingle();

    final detail = DetailBilanEntity(
      id: bilanId,
      transport: (detailRes?['transport'] as num?)?.toDouble() ?? 0.0,
      alimentation: (detailRes?['alimentation'] as num?)?.toDouble() ?? 0.0,
      logement: (detailRes?['logement'] as num?)?.toDouble() ?? 0.0,
      divers: (detailRes?['divers'] as num?)?.toDouble() ?? 0.0,
      servicesSocietaux: (detailRes?['services_societaux'] as num?)?.toDouble() ?? 0.0,
    );

    return (scoreTotalKg: scoreTotalKg, detail: detail);
  }
}
