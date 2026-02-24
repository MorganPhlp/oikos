import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_community_positioning_stats.dart';
import 'package:oikos/features/dashboard/domain/repository/dashboard_repository.dart';

class GetMyCommunityPositioningStats
    implements UseCase<DashboardCommunityPositioningStats?, NoParams> {
  final DashboardRepository repository;

  GetMyCommunityPositioningStats(this.repository);

  @override
  Future<Either<Failure, DashboardCommunityPositioningStats?>> call(NoParams params) {
    return repository.getMyCommunityPositioningStats();
  }
}
