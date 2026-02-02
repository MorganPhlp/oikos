import 'package:oikos/features/admin/domain/entities/carbon_data_point.dart';
import 'package:oikos/features/admin/domain/entities/category_data.dart';
import 'package:oikos/features/admin/domain/entities/impact_stat_data.dart';

class Co2PerformanceData {
  final List<CarbonDataPoint> co2PerformanceMonthly;
  final List<CarbonDataPoint> co2PerformanceYear;
  final ImpactStatData impactStats;
  final List<CategoryData> categories;

  Co2PerformanceData({
    required this.categories,
    required this.co2PerformanceMonthly,
    required this.co2PerformanceYear,
    required this.impactStats,
  });

  // Constructeur "from" : Crée une copie profonde (Deep Copy)
  factory Co2PerformanceData.from(Co2PerformanceData other) {
    return Co2PerformanceData(
      categories: List<CategoryData>.from(other.categories),
      co2PerformanceMonthly: List<CarbonDataPoint>.from(other.co2PerformanceMonthly),
      co2PerformanceYear: List<CarbonDataPoint>.from(other.co2PerformanceYear),
      impactStats: other.impactStats, // Si ImpactStatData est immuable
    );
  }

  Co2PerformanceData copyWith({
    List<CategoryData>? categories,
    List<CarbonDataPoint>? co2PerformanceMonthly,
    List<CarbonDataPoint>? co2PerformanceYear,
    ImpactStatData? impactStats,
  }) {
    return Co2PerformanceData(
      categories: categories ?? this.categories,
      co2PerformanceMonthly: co2PerformanceMonthly ?? this.co2PerformanceMonthly,
      co2PerformanceYear: co2PerformanceYear ?? this.co2PerformanceYear,
      impactStats: impactStats ?? this.impactStats,
    );
  }
}