import 'package:oikos/features/admin/domain/entities/carbon_data_point.dart';
import 'package:oikos/features/admin/domain/entities/category_data.dart';
import 'package:oikos/features/admin/domain/entities/co2_performance_data.dart';
import 'package:oikos/features/admin/domain/entities/impact_stat_data.dart';
import 'package:oikos/features/admin/domain/interfaces/co2_performance_rep.dart';

class GetCo2Performance {
  final Co2PerformanceRep rep;

  GetCo2Performance(this.rep);

  Future<Co2PerformanceData> call() async {
    final List<CarbonDataPoint> co2PerformanceMonthly = await rep.getCo2Performance(
      'month',
    );
    final List<CarbonDataPoint> co2PerformanceYear = await rep.getCo2Performance(
      'year',
    );
    final ImpactStatData impactStats = await rep.getImpactStats();
    final List<CategoryData> categories = await rep.getCategoryData();

    return Co2PerformanceData(
      categories: categories,
      co2PerformanceMonthly: co2PerformanceMonthly,
      co2PerformanceYear: co2PerformanceYear,
      impactStats: impactStats,
    );
  }
}
