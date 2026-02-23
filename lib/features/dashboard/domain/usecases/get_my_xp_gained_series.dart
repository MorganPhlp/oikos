import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_xp_point.dart';
import 'package:oikos/features/dashboard/domain/repository/dashboard_repository.dart';

class GetMyXpGainedSeries implements UseCase<List<DashboardXpPoint>, NoParams> {
  final DashboardRepository repository;

  GetMyXpGainedSeries(this.repository);

  @override
  Future<Either<Failure, List<DashboardXpPoint>>> call(NoParams params) {
    return repository.getMyXpGainedSeries();
  }
}
