import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_bilan_carbone_summary.dart';
import 'package:oikos/features/dashboard/domain/repository/dashboard_repository.dart';

class GetMyLatestBilanCarboneSummary
    implements UseCase<DashboardBilanCarboneSummary?, NoParams> {
  final DashboardRepository repository;

  GetMyLatestBilanCarboneSummary(this.repository);

  @override
  Future<Either<Failure, DashboardBilanCarboneSummary?>> call(NoParams params) {
    return repository.getMyLatestBilanCarboneSummary();
  }
}
