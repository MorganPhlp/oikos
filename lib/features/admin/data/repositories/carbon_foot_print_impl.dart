import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/models/core/carbon_foot_print.dart';
import 'package:oikos/features/admin/domain/models/models.dart';
import 'package:oikos/features/admin/domain/entities/kpi_stats.dart';
import 'package:oikos/features/admin/domain/interfaces/carbon_foot_print_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CarbonFootPrintImpl extends CarbonFootPrintRep {
  CarbonFootPrintImpl(this.supabase);
  final SupabaseClient supabase;

  Future<Either<Failure, T>> _request<T>(Future<T> Function() query) async {
    try {
      return right(await query());
    } catch (_) {
      return left(Failure('Impossible de charger les statistiques. Réessaie.'));
    }
  }

  @override
  Future<Either<Failure, List<CarbonTimeSeries>>> getCarbonTimeSeries(
    String timeBucket,
    String companyId,
  ) => _request(() async {
    final rows = await supabase.rpc(
      'get_co2_evolution',
      params: {'company_id': companyId, 'interval_type': timeBucket},
    );
    return (rows as List)
        .map((r) => CarbonTimeSeries.fromJson(Map<String, dynamic>.from(r)))
        .toList();
  });

  @override
  Future<Either<Failure, List<CategoryData>>> getCategoryData(
    String companyId,
  ) => _request(() async {
    final rows = await supabase.rpc(
      'get_carbon_distribution',
      params: {'company_id': companyId},
    );
    return (rows as List)
        .map((r) => CategoryData.fromJson(Map<String, dynamic>.from(r)))
        .toList();
  });

  @override
  Future<Either<Failure, KpiStats>> getKpiStats(String companyId) => _request(
    () async {
      final data = Map<String, dynamic>.from(
        await supabase.rpc('get_admin_kpis', params: {'company_id': companyId}),
      );
      return KpiStats(
        carbonFootPrintCompletionRateKPI: CarbonFootPrintCompletionRateKPI(
          carbonFootPrintMinimalCompletionRate: data['completed'],
          carbonFootPrintDetailledCompletionRate: data['detailed'],
          carbonFootPrintMinimalCompletionRateObjective: 0,
          carbonFootPrintDetailledCompletionRateObjective: 0,
        ),
        challengesAcceptedKPI: ChallengesAcceptedKPI(
          nbChallenges: data['actions'],
          nbChallengesObjective: 0,
        ),
        dailyUseRateKPI: DailyUseRateKPI(
          dailyUseRate: data['daily'],
          dailyUseRateObjective: 0,
        ),
      );
    },
  );

  @override
  Future<Either<Failure, List<CarbonFootPrint>>> getUsersCarbon(
    String companyId,
  ) => _request(() async {
    final rows = await supabase
        .from('bilan_carbone')
        .select(
          'utilisateur_id,scoretotalco2ean,date_bilan,utilisateur!inner(entreprise_id)',
        )
        .eq('utilisateur.entreprise_id', companyId)
        .eq('complet', true)
        .order('date_bilan', ascending: false);
    return rows.map(CarbonFootPrint.fromJson).toList();
  });
}
