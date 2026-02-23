import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/detail_bilan_entity.dart';

abstract interface class DashboardRemoteDataSource {
  Future<String> getMyPseudo();

  /// Dernier bilan carbone complété (score + détail par catégorie).
  /// Retourne `null` si aucun bilan complété n'existe.
  Future<({double scoreTotalKg, DetailBilanEntity detail})?> getMyLatestCompletedBilan();

  /// Données brutes pour la heatmap streaks : bornes de saison + dates des actions quotidiennes.
  /// Fenêtre glissante sur les 5 derniers mois.
  Future<({DateTime minDate, DateTime maxDate, List<DateTime> actionDates})?> getMyHeatmapRaw();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final SupabaseClient supabaseClient;
  DashboardRemoteDataSourceImpl(this.supabaseClient);

  DateTime _subtractMonths(DateTime date, int months) {
    final targetMonthIndex = (date.year * 12 + (date.month - 1)) - months;
    final targetYear = targetMonthIndex ~/ 12;
    final targetMonth = (targetMonthIndex % 12) + 1;

    final lastDayOfTargetMonth = DateTime(targetYear, targetMonth + 1, 0).day;
    final targetDay = date.day > lastDayOfTargetMonth ? lastDayOfTargetMonth : date.day;

    return DateTime(targetYear, targetMonth, targetDay, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
  }

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

  @override
  Future<({DateTime minDate, DateTime maxDate, List<DateTime> actionDates})?> getMyHeatmapRaw() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw AuthException('User not logged in');
    }

    final now = DateTime.now();
    final maxDate = DateTime(now.year, now.month, now.day);
    final fiveMonthsAgo = _subtractMonths(maxDate, 5);
    final minDate = DateTime(fiveMonthsAgo.year, fiveMonthsAgo.month, fiveMonthsAgo.day);

    final response = await supabaseClient
        .from('realisation_actions')
        .select('date_realisation, actions!inner(frequence)')
        .eq('utilisateur_id', user.id)
        .eq('actions.frequence', 'quotidienne')
        .gte('date_realisation', minDate.toUtc().toIso8601String())
        .lte('date_realisation', maxDate.toUtc().toIso8601String());

    final rows = List<Map<String, dynamic>>.from(response as List);
    final actionDates = <DateTime>[];

    for (final row in rows) {
      final rawDate = row['date_realisation'];
      if (rawDate is String) {
        actionDates.add(DateTime.parse(rawDate).toLocal());
      }
    }

    return (minDate: minDate, maxDate: maxDate, actionDates: actionDates);
  }
}
