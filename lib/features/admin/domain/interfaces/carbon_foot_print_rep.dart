import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/data/models/core/carbon_foot_print.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/entities/kpi_stats.dart';

abstract class CarbonFootPrintRep {
  Future<Either<Failure, List<CarbonTimeSeries>>> getCarbonTimeSeries(
    String timeBucket,String companyId
  );
  Future<Either<Failure, KpiStats>> getKpiStats(String companyId);
  Future<Either<Failure, List<CategoryData>>> getCategoryData(String companyId);
  Future<Either<Failure, List<CarbonFootPrint>>> getUsersCarbon(String companyId);
}
