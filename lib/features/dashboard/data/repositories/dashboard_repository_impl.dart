import 'package:oikos/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_bilan_carbone_summary.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_actions_distribution.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_heatmap_data.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_xp_point.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_community_positioning_stats.dart';
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

  @override
  Future<Either<Failure, DashboardHeatmapData?>> getMyHeatmapData() async {
    try {
      final raw = await remoteDataSource.getMyHeatmapRaw();
      if (raw == null) return right(null);

      final dailyCounts = <DateTime, int>{};
      for (final actionDate in raw.actionDates) {
        final local = actionDate.toLocal();
        final normalized = DateTime(local.year, local.month, local.day);
        dailyCounts[normalized] = (dailyCounts[normalized] ?? 0) + 1;
      }

      return right(
        DashboardHeatmapData(
          minDate: raw.minDate,
          maxDate: raw.maxDate,
          dailyCounts: dailyCounts,
        ),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  String _normalizeCategory(String input) {
    var s = input.trim().toLowerCase();
    // minimal accent folding
    s = s
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('î', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ô', 'o')
        .replaceAll('ù', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ç', 'c');
    return s;
  }

  String _mapActionCategoryToBilanLabel(String rawCategory) {
    final normalized = _normalizeCategory(rawCategory);
    if (normalized.contains('transport')) return 'Transport';
    if (normalized.contains('aliment')) return 'Alimentation';
    if (normalized.contains('logement') || normalized.contains('habitat')) return 'Logement';
    if (normalized.contains('service') || normalized.contains('societ')) return 'Services Sociétaux';
    if (normalized.contains('divers')) return 'Divers';
    // fallback
    return 'Divers';
  }

  @override
  Future<Either<Failure, DashboardActionsDistribution?>> getMyActionsDistribution() async {
    try {
      final rawCategories = await remoteDataSource.getMyCompletedActionCategories();
      if (rawCategories.isEmpty) {
        return right(const DashboardActionsDistribution(countsByCategoryLabel: {}));
      }

      final counts = <String, double>{};
      for (final cat in rawCategories) {
        final label = _mapActionCategoryToBilanLabel(cat);
        counts[label] = (counts[label] ?? 0) + 1;
      }

      return right(DashboardActionsDistribution(countsByCategoryLabel: counts));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  DateTime _startOfWeekMonday(DateTime d) {
    // Alignement proche de date_trunc('week', ...) (lundi 00:00).
    final normalized = DateTime(d.year, d.month, d.day);
    final delta = (normalized.weekday + 6) % 7; // Monday=0, Sunday=6
    return normalized.subtract(Duration(days: delta));
  }

  @override
  Future<Either<Failure, List<DashboardXpPoint>>> getMyXpGainedSeries() async {
    try {
      final raw = await remoteDataSource.getMyXpGainedRaw();
      if (raw == null) return right(const <DashboardXpPoint>[]);

      // Agrégation par semaine (début lundi) : sum(xp_gagne)
      final xpByWeekStart = <DateTime, int>{};
      for (final row in raw.rows) {
        final weekStart = _startOfWeekMonday(row.date.toLocal());
        xpByWeekStart[weekStart] = (xpByWeekStart[weekStart] ?? 0) + row.xp;
      }

      final normalizedMin = DateTime(raw.minDate.year, raw.minDate.month, raw.minDate.day);
      final normalizedMax = DateTime(raw.maxDate.year, raw.maxDate.month, raw.maxDate.day);
      if (normalizedMax.isBefore(normalizedMin)) {
        return right(const <DashboardXpPoint>[]);
      }

      // Séries de points hebdo (semaine par semaine), puis cumul.
      final startWeek = _startOfWeekMonday(normalizedMin);
      final endWeek = _startOfWeekMonday(normalizedMax);

      final points = <DashboardXpPoint>[];
      var cumulative = 0.0;
      for (var week = startWeek; !week.isAfter(endWeek); week = week.add(const Duration(days: 7))) {
        cumulative += (xpByWeekStart[week] ?? 0).toDouble();
        points.add(DashboardXpPoint(date: week, cumulativeXp: cumulative));
      }

      return right(points);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  double _percentileCont(List<double> sortedValues, double p) {
    if (sortedValues.isEmpty) return 0.0;
    if (sortedValues.length == 1) return sortedValues.first;

    final clampedP = p.clamp(0.0, 1.0);
    final n = sortedValues.length;
    final pos = (n - 1) * clampedP;
    final lowerIndex = pos.floor();
    final upperIndex = pos.ceil();
    final lower = sortedValues[lowerIndex];
    final upper = sortedValues[upperIndex];
    final weight = pos - lowerIndex;
    return lower + (upper - lower) * weight;
  }

  @override
  Future<Either<Failure, DashboardCommunityPositioningStats?>>
      getMyCommunityPositioningStats() async {
    try {
      final raw = await remoteDataSource.getMyCommunityPositioningRaw();

      final userPoints = raw.userPoints;
      final members = raw.memberPoints;
      if (members.isEmpty) {
        return right(
          DashboardCommunityPositioningStats(
            userPoints: userPoints,
            communityAveragePoints: userPoints,
            communityTop10PercentPoints: userPoints,
          ),
        );
      }

      final sorted = [...members]..sort();
      final sum = sorted.fold<double>(0.0, (acc, v) => acc + v);
      final avg = sum / sorted.length;
      final top10 = _percentileCont(sorted, 0.90);

      return right(
        DashboardCommunityPositioningStats(
          userPoints: userPoints,
          communityAveragePoints: avg,
          communityTop10PercentPoints: top10,
        ),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
