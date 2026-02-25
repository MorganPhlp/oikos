import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/entities/kpi_stats.dart';

class CarbonFootPrintData {
  final List<CarbonTimeSeries> co2PerformanceMonthly;
  final List<CarbonTimeSeries> co2PerformanceYear;
  final KpiStats kpiStats;
  final List<CategoryData> categories;

  CarbonFootPrintData({
    required this.co2PerformanceMonthly,
    required this.co2PerformanceYear,
    required this.kpiStats,
    required this.categories,
  });
}
