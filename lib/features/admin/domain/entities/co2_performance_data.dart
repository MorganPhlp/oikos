import 'package:oikos/features/admin/data/models/models.dart';

class Co2PerformanceData {
  final List<CarbonFootprintData> co2PerformanceMonthly;
  final List<CarbonFootprintData> co2PerformanceYear;
  final GlobalInsightsStats globalInsightsStats;
  final List<CategoryData> categories;
  final CarbonFootprintCompletionRate completionRateCarbon;

  Co2PerformanceData({
    required this.co2PerformanceMonthly,
    required this.co2PerformanceYear,
    required this.globalInsightsStats,
    required this.categories,
    required this.completionRateCarbon,
  });
}
