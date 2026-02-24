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

    // Génération déterministe mais plus "naturelle" :
    // - jours off
    // - périodes de streaks
    // - weekends un peu plus actifs
    // - quelques pics
    int seed = normalizedMin.millisecondsSinceEpoch ~/ const Duration(days: 1).inMilliseconds;
    double nextRand() {
      // LCG simple (déterministe)
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      return seed / 0x7fffffff;
    }

    var prevActive = false;
    var streakEnergy = 0.0;

    for (var date = normalizedMin;
        !date.isAfter(normalizedMax);
        date = date.add(const Duration(days: 1))) {
      final isWeekend = (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday);

      // Probabilité d'activité du jour.
      var p = isWeekend ? 0.55 : 0.38;
      if (prevActive) p += 0.22; // favorise les streaks
      p += streakEnergy.clamp(0.0, 0.15);

      // Petites périodes "off" (ex: vacances / baisse de régime) toutes les ~4-6 semaines.
      final dayIndex = date.difference(normalizedMin).inDays;
      final offWindow = (dayIndex % 37) >= 32; // 5 jours off dans un cycle de 37
      if (offWindow) p -= 0.25;

      p = p.clamp(0.05, 0.92);

      final r = nextRand();
      final active = r < p;

      int value;
      if (!active) {
        value = 0;
        prevActive = false;
        streakEnergy = (streakEnergy - 0.06).clamp(0.0, 0.25);
      } else {
        // Intensité: la plupart du temps 1..5, parfois plus.
        final r2 = nextRand();
        final base = 1 + (r2 * 4.8).floor(); // 1..5
        final weekendBoost = isWeekend ? 1 : 0;

        // Pic occasionnel.
        final r3 = nextRand();
        final spike = (r3 > 0.93) ? 3 : 0;

        value = (base + weekendBoost + spike).clamp(0, 10);
        prevActive = true;
        streakEnergy = (streakEnergy + 0.04).clamp(0.0, 0.25);
      }

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

  static ({double userPoints, double teamAveragePoints, double top10PercentPoints})
      buildFakeCommunityGaugeFromUserPoints(double userPoints) {
    final safeUser = userPoints.isNaN ? 0.0 : (userPoints < 0 ? 0.0 : userPoints);

    // On simule une équipe avec une moyenne légèrement inférieure
    // et un top 10% au-dessus de l'utilisateur.
    final avg = (safeUser * 0.78).clamp(0.0, double.infinity);
    final top10 = (safeUser * 1.22 + 120).clamp(0.0, double.infinity);

    return (userPoints: safeUser, teamAveragePoints: avg, top10PercentPoints: top10);
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
