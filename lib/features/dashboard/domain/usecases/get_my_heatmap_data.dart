import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_heatmap_data.dart';
import 'package:oikos/features/dashboard/domain/repository/dashboard_repository.dart';

class GetMyHeatmapData implements UseCase<DashboardHeatmapData?, NoParams> {
  final DashboardRepository repository;

  GetMyHeatmapData(this.repository);

  @override
  Future<Either<Failure, DashboardHeatmapData?>> call(NoParams params) {
    return repository.getMyHeatmapData();
  }
}
