import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/data/models/analytics/rates/carbon_footprint_completion_rate.dart';
import 'package:oikos/features/admin/data/models/models.dart';

abstract class Co2PerformanceRep {
  Future<Either<Failure, List<CarbonFootprintData>>> getCo2Performance(
    String timeBucket,
  );
  Future<Either<Failure, GlobalInsightsStats>> getGlobalInsightsData();
  Future<Either<Failure, List<CategoryData>>> getCategoryData();
  Future<Either<Failure, CarbonFootprintCompletionRate>>
  getCompletionRateCarbon();
}
