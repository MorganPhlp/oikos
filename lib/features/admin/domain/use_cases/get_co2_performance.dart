import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/entities/co2_performance_data.dart';
import 'package:oikos/features/admin/domain/repositories/co2_performance_rep.dart';

class GetCo2Performance {
  final Co2PerformanceRep rep;

  GetCo2Performance(this.rep);

  Future<Either<Failure, Co2PerformanceData>> call() async {
    final monthlyResult = await rep.getCo2Performance('month');
    final yearResult = await rep.getCo2Performance('year');
    final globalInsightsStatsResult = await rep.getGlobalInsightsData();
    final categoriesResult = await rep.getCategoryData();
    final completionRateCarbonResult = await rep.getCompletionRateCarbon();

    return monthlyResult.fold(
      (failure) => left(failure),
      (monthly) => yearResult.fold(
        (failure) => left(failure),
        (yearly) => globalInsightsStatsResult.fold(
          (failure) => left(failure),
          (globalInsightsStats) => categoriesResult.fold(
            (failure) => left(failure),
            (categories) => completionRateCarbonResult.fold(
              (failure) => left(failure),
              (completionRateCarbon) =>       
                right(Co2PerformanceData(
                  categories: categories,
                  co2PerformanceMonthly: monthly,
                  co2PerformanceYear: yearly,
                  globalInsightsStats: globalInsightsStats,
                  completionRateCarbon: completionRateCarbon,
                  
                )),
            )
          ),
        ),
      ),
    );
  }
}
