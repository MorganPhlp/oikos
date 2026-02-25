import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/core/supabase_ext.dart';
import 'package:oikos/features/admin/data/models/core/carbon_foot_print.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/entities/kpi_stats.dart';
import 'package:oikos/features/admin/domain/interfaces/carbon_foot_print_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CarbonFootPrintImpl extends CarbonFootPrintRep {
  final SupabaseClient supabase;

  CarbonFootPrintImpl(this.supabase);

  @override
  Future<Either<Failure, List<CarbonTimeSeries>>> getCarbonTimeSeries(
    String timeBucket,
    String companyId,
  ) async {
    try {
      supabase.logConnection();
      // final response = await supabase
      //     .rpc('get_co2_evolution', params: {'interval_type': timeBucket})
      //     .select('average_co2,period');

      final mokResponse = [
        {'average_co2': 10.5, 'period': '2024-01-01'},
        {'average_co2': 12.0, 'period': '2024-02-01'},
        {'average_co2': 11.0, 'period': '2024-03-01'},
        {'average_co2': 9.5, 'period': '2024-04-01'},
      ];
      final data = mokResponse
          .map((json) => CarbonTimeSeries.fromJson(json))
          .toList();
      return right(data);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, KpiStats>> getKpiStats(String companyId) async {
    try {
      supabase.logConnection();
      // final response = await supabase.from('vue_admin_kpi_flash').select();

      // CarbonFootPrintCompletionRateKPI
      final mockCarbonFootPrint = {
        'completion_bilan_carbone_minimale': 65,
        'completion_bilan_carbone_detaille': 42,
        'objectif_completion_bilan_carbone_minimale': 80,
        'objectif_completion_bilan_carbone_detaille': 70,
      };

      // ChallengesAcceptedKPI
      final mockChallengesAccepted = {
        'nb_defis_releve': 134,
        'nb_defis_objectif': 200,
      };

      // DailyUseRateKPI
      final mockDailyUseRate = {
        'taux_utilisation_jour': 38,
        'objectif_taux_utilisation_jour': 50,
      };

      // RetentionRateKPI
      final mockRetentionRate = {
        'j7': 72,
        'j7_objective': 85,
        'j30': 55,
        'j30_objective': 75,
        'current_retention_rate': 61,
      };

      final kpiStats = KpiStats(
        carbonFootPrintCompletionRateKPI:
            CarbonFootPrintCompletionRateKPI.fromJson(mockCarbonFootPrint),
        challengesAcceptedKPI: ChallengesAcceptedKPI.fromJson(
          mockChallengesAccepted,
        ),
        dailyUseRateKPI: DailyUseRateKPI.fromJson(mockDailyUseRate),
        retentionRateKPI: RetentionRateKPI.fromJson(mockRetentionRate),
      );
      return right(kpiStats);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryData>>> getCategoryData(
    String companyId,
  ) async {
    try {
      // final response = await supabase
      //     .from('global_carbon_distribution')
      //     .select();

      final mokResponse = [
        {'name': 'Transport', 'co2': 1200.0, 'percentage': 40.0},
        {'name': 'Alimentation', 'co2': 900.0, 'percentage': 30.0},
        {'name': 'Logement', 'co2': 600.0, 'percentage': 20.0},
        {'name': 'Autres', 'co2': 300.0, 'percentage': 10.0},
      ];
      final colors = [
        Colors.blue,
        Colors.green,
        Colors.orange,
        Colors.purple,
        Colors.red,
        Colors.teal,
      ];
      final data = mokResponse.asMap().entries.map((entry) {
        final json = entry.value;
        return CategoryData(
          name: json['name'] as String,
          co2: (json['co2'] as num).toDouble(),
          percentage: (json['percentage'] as num).toDouble(),
          color: colors[entry.key % colors.length],
        );
      }).toList();
      return right(data);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, List<CarbonFootPrint>>> getUsersCarbon(
    String companyId,
  ) async {
    try {
      final response = await supabase.from('bilan_carbone').select();

      final data = response
          .map((json) => CarbonFootPrint.fromJson(json))
          .toList();

      return right(data);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }
}
