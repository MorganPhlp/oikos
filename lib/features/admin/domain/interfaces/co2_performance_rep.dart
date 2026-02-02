
import 'package:oikos/features/admin/domain/entities/carbon_data_point.dart';
import 'package:oikos/features/admin/domain/entities/category_data.dart';
import 'package:oikos/features/admin/domain/entities/impact_stat_data.dart';


abstract class Co2PerformanceRep {
  Future<List<CarbonDataPoint>> getCo2Performance(
    String timeBucket,
  );
  Future<ImpactStatData> getImpactStats();
  Future<List<CategoryData>> getCategoryData();
}
