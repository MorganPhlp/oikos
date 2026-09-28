import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/home/domain/entities/home_stats_entity.dart';
import 'package:oikos/features/home/domain/repositories/home_stats_repository.dart';

class GetHomeStatsUseCase {
  final HomeStatsRepository repository;
  GetHomeStatsUseCase(this.repository);

  Future<Either<Failure, HomeStatsEntity>> call(String userId) {
    return repository.getHomeStats(userId);
  }
}
