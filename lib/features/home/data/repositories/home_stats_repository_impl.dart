import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/exceptions.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/home/data/datasources/home_stats_remote_data_source.dart';
import 'package:oikos/features/home/domain/entities/home_stats_entity.dart';
import 'package:oikos/features/home/domain/repositories/home_stats_repository.dart';

class HomeStatsRepositoryImpl implements HomeStatsRepository {
  final HomeStatsRemoteDataSource remoteDataSource;
  HomeStatsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, HomeStatsEntity>> getHomeStats(String userId) async {
    try {
      final stats = await remoteDataSource.fetchHomeStats(userId);
      return right(stats);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
