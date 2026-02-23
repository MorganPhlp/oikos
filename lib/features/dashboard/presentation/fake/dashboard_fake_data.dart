import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:oikos/features/dashboard/domain/entities/dashboard_xp_point.dart';

class DashboardFakeData {
  static const bilanCategoryLabels = <String>[
    'Transport',
    'Alimentation',
    'Logement',
    'Divers',
    'Services Sociétaux',
  ];

  static Map<String, double> fakeBilanScoresKg() {
    return const {
      'Transport': 1200,
      'Alimentation': 900,
      'Logement': 1500,
      'Divers': 500,
      'Services Sociétaux': 700,
    };
  }

  static double fakeBilanTotalKg(Map<String, double> scoresKg) {
    return scoresKg.values.fold<double>(0, (sum, v) => sum + v);
  }

  static Map<String, double> fakeActionsCountsByCategory() {
    return const {
      'Transport': 10,
      'Alimentation': 7,
      'Logement': 5,
      'Divers': 6,
      'Services Sociétaux': 3,
    };
  }

  static List<ContributionEntry> buildFakeHeatmapEntries({
    required DateTime minDate,
    required DateTime maxDate,
  }) {
    final entries = <ContributionEntry>[];
    final normalizedMin = DateTime(minDate.year, minDate.month, minDate.day);
    final normalizedMax = DateTime(maxDate.year, maxDate.month, maxDate.day);

    for (var date = normalizedMin;
        !date.isAfter(normalizedMax);
        date = date.add(const Duration(days: 1))) {
      final base = (date.day + date.month) % 6;
      final weekendBoost =
          (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday)
              ? 2
              : 0;

      final value = (base + weekendBoost).clamp(0, 10).toInt();
      entries.add(ContributionEntry(date, value));
    }

    return entries;
  }

  static List<DashboardXpPoint> buildFakeXpGainedSeries({
    required DateTime minDate,
    required DateTime maxDate,
  }) {
    final start = DateTime(minDate.year, minDate.month, minDate.day);
    final end = DateTime(maxDate.year, maxDate.month, maxDate.day);

    if (end.isBefore(start)) return [];

    // Point hebdo (tous les 7 jours), cumul déterministe.
    final points = <DashboardXpPoint>[];
    var cumulative = 0.0;
    var cursor = start;
    while (!cursor.isAfter(end)) {
      // Variation "réaliste" sans random (stable entre builds).
      final seed = (cursor.year * 10000) + (cursor.month * 100) + cursor.day;
      final weeklyGain = 40 + (seed % 121); // 40..160 XP/sem
      cumulative += weeklyGain.toDouble();

      points.add(DashboardXpPoint(date: cursor, cumulativeXp: cumulative));
      cursor = cursor.add(const Duration(days: 7));
    }

    // Assure un point final exactement à maxDate.
    if (points.isNotEmpty && points.last.date != end) {
      final last = points.last;
      final seed = (end.year * 10000) + (end.month * 100) + end.day;
      final extra = 10 + (seed % 41); // 10..50 XP
      points.add(DashboardXpPoint(date: end, cumulativeXp: last.cumulativeXp + extra.toDouble()));
    }

    return points;
  }

  static DateTime subtractMonths(DateTime date, int months) {
    final targetMonthIndex = (date.year * 12 + (date.month - 1)) - months;
    final targetYear = targetMonthIndex ~/ 12;
    final targetMonth = (targetMonthIndex % 12) + 1;

    final lastDayOfTargetMonth = DateTime(targetYear, targetMonth + 1, 0).day;
    final targetDay = date.day > lastDayOfTargetMonth ? lastDayOfTargetMonth : date.day;

    return DateTime(
      targetYear,
      targetMonth,
      targetDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }
}
