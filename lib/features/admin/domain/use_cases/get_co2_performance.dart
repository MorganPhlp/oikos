import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/entities/carbon_foot_print.dart';
import 'package:oikos/features/admin/domain/interfaces/carbon_foot_print_rep.dart';

class GetCarbonFootPrint {
  final CarbonFootPrintRep rep;

  GetCarbonFootPrint(this.rep);

  Future<Either<Failure, CarbonFootPrintData>> call(String companyId) async {
    final monthlyResult = await rep.getCarbonTimeSeries('month', companyId);
    final yearResult = await rep.getCarbonTimeSeries('year', companyId);
    final kpiStatsResult = await rep.getKpiStats(companyId);
    final categoriesResult = await rep.getCategoryData(companyId);

    return monthlyResult.fold(
      (failure) => left(failure),
      (monthly) => yearResult.fold(
        (failure) => left(failure),
        (yearly) => kpiStatsResult.fold(
          (failure) => left(failure),
          (kpiStats) => categoriesResult.fold(
            (failure) => left(failure),
            (categories) => right(
              CarbonFootPrintData(
                co2PerformanceMonthly: monthly,
                co2PerformanceYear: yearly,
                kpiStats: kpiStats,
                categories: categories,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
