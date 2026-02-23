import 'package:oikos/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_bilan_carbone_summary.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, String>> getMyPseudo();
  Future<Either<Failure, DashboardBilanCarboneSummary?>> getMyLatestBilanCarboneSummary();
}
