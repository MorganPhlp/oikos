import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/home/domain/entities/home_stats_entity.dart';

abstract interface class HomeStatsRepository {
  Future<Either<Failure, HomeStatsEntity>> getHomeStats(String userId);
}
