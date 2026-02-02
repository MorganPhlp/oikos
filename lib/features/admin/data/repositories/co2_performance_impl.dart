import 'package:oikos/features/admin/data/models/carbon_data_point_model.dart';
import 'package:oikos/features/admin/data/models/category_data_model.dart';
import 'package:oikos/features/admin/data/models/impact_stats_model.dart';
import 'package:oikos/features/admin/domain/entities/carbon_data_point.dart';
import 'package:oikos/features/admin/domain/entities/category_data.dart';
import 'package:oikos/features/admin/domain/entities/impact_stat_data.dart';
import 'package:oikos/features/admin/domain/interfaces/co2_performance_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/logger.dart';

class Co2PerformanceImpl extends Co2PerformanceRep {
  final SupabaseClient supabase;

  Co2PerformanceImpl(this.supabase);

  @override
  Future<List<CarbonDataPoint>> getCo2Performance(String timeBucket) async {
    try {
      final response = await supabase
          .rpc('get_carbon_stats', params: {'time_bucket': timeBucket})
          .select('average_co2,period');
      // print('Données Supabase : $response'); // Regarde la console ici !
      return response
          .map((json) => CarbonDataPointModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("Erreur supabase : ${e.message} ");
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("une Erreur inattendu est survenue");
    }
  }

  @override
  Future<ImpactStatData> getImpactStats() async {
    try {
      final response = await supabase.from('impact_stats').select();
      return ImpactStatDataModel.fromJson(response[0]);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("Erreur supabase : ${e.message} ");
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("une Erreur inattendu est survenue");
    }
  }

  @override
  Future<List<CategoryData>> getCategoryData() async {
    try {
      final response = await supabase
          .from('global_carbon_distribution')
          .select();
      return response.map((json) => CategoryDataModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      throw Exception("Erreur supabase : ${e.message} ");
    } catch (e) {
      logger.e("Erreur Repository", error: e);

      throw Exception("une Erreur inattendu est survenue");
    }
  }
}
