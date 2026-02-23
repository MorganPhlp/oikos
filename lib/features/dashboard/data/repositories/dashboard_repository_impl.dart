import 'package:oikos/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_bilan_carbone_summary.dart';
import '../../domain/repository/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  DashboardRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, String>> getMyPseudo() async {
    try {
      final pseudo = await remoteDataSource.getMyPseudo();
      return right(pseudo);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DashboardBilanCarboneSummary?>>
      getMyLatestBilanCarboneSummary() async {
    try {
      final res = await remoteDataSource.getMyLatestCompletedBilan();
      if (res == null) return right(null);

      return right(
        DashboardBilanCarboneSummary(
          scoreTotalKg: res.scoreTotalKg,
          detail: res.detail,
        ),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
