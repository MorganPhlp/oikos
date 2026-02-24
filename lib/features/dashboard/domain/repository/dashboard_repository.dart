import 'package:oikos/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_bilan_carbone_summary.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_actions_distribution.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_heatmap_data.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_xp_point.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_community_positioning_stats.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, String>> getMyPseudo();
  Future<Either<Failure, DashboardBilanCarboneSummary?>> getMyLatestBilanCarboneSummary();
  Future<Either<Failure, DashboardHeatmapData?>> getMyHeatmapData();
  Future<Either<Failure, DashboardActionsDistribution?>> getMyActionsDistribution();
  Future<Either<Failure, List<DashboardXpPoint>>> getMyXpGainedSeries();
  Future<Either<Failure, DashboardCommunityPositioningStats?>> getMyCommunityPositioningStats();
}
