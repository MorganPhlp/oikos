import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_actions_distribution.dart';
import 'package:oikos/features/dashboard/domain/repository/dashboard_repository.dart';

class GetMyActionsDistribution
    implements UseCase<DashboardActionsDistribution?, NoParams> {
  final DashboardRepository repository;

  GetMyActionsDistribution(this.repository);

  @override
  Future<Either<Failure, DashboardActionsDistribution?>> call(NoParams params) {
    return repository.getMyActionsDistribution();
  }
}
