import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/core/supabase_ext.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/repositories/co2_performance_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Co2PerformanceImpl extends Co2PerformanceRep {
  final SupabaseClient supabase;

  Co2PerformanceImpl(this.supabase);

  @override
  Future<Either<Failure, List<CarbonFootprintData>>> getCo2Performance(
    String timeBucket,
  ) async {
    try {
      supabase.logConnection();
      // final response = await supabase
      //     .rpc('get_co2_evolution', params: {'interval_type': timeBucket})
      //     .select('average_co2,period');

      final mokResponse = [
        {'average_co2': 10.5, 'period': '2024-01'},
        {'average_co2': 12.0, 'period': '2024-02'},
        {'average_co2': 11.0, 'period': '2024-03'},
        {'average_co2': 9.5, 'period': '2024-04'},
      ];
      final data = mokResponse
          .map((json) => CarbonFootprintData.fromJson(json))
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
  Future<Either<Failure, GlobalInsightsStats>> getGlobalInsightsData() async {
    try {
      supabase.logConnection();
      // final response = await supabase.from('vue_admin_kpi_flash').select();

      final mokResponse = [
        {
          'average_co2': 11.5,
          'total_users': 1500,
          'average_completion_rate': 75.0,
        }
      ];
      final stats = mokResponse[0];
      return right(GlobalInsightsStats.fromJson(stats));
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryData>>> getCategoryData() async {
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
  Future<Either<Failure, CarbonFootprintCompletionRate>>
  getCompletionRateCarbon() async {
    try {
      supabase.logConnection();
      // final response = await supabase
      //     .from('vue_dashboard_completion_bilan')
      //     .select()
      //     .single();

      final mokResponse = {
        'average_completion_rate': 75.0,
      };
      final data = CarbonFootprintCompletionRate.fromJson(mokResponse);
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
