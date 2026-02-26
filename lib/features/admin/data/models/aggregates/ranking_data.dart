import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/data/models/core/carbon_foot_print.dart';
import 'package:oikos/features/admin/data/models/models.dart';

part 'ranking_data.freezed.dart';

@freezed
sealed class RankingData with _$RankingData {
  const factory RankingData({
    required List<Utilisateurs> users,
    required List<CarbonFootPrint> carbonFootPrints,
    required List<Community> communities,
  }) = _RankingData;
}

extension RankingDataX on RankingData {
  // ── Communautés ────────────────────────────────────────────────────────────

  /// Tri par CO₂ moyen ascendant. avgScore == 0 (ou null) → fin de liste.
  List<Community> sortedCommunitiesByAvgScore() {
    final sorted = List<Community>.from(communities);
    sorted.sort((a, b) {
      final av = a.avgScore ?? 0.0;
      final bv = b.avgScore ?? 0.0;
      if (av == 0 && bv == 0) return 0;
      if (av == 0) return 1;
      if (bv == 0) return -1;
      return av.compareTo(bv); // plus petit CO₂ = meilleur → ascendant
    });
    return sorted;
  }

  /// Tri par XP plantes descendant. plantXp == 0 (ou null) → fin de liste.
  List<Community> sortedCommunitiesByPlantXp() {
    final sorted = List<Community>.from(communities);
    sorted.sort((a, b) {
      final av = a.plantXp ?? 0;
      final bv = b.plantXp ?? 0;
      if (av == 0 && bv == 0) return 0;
      if (av == 0) return 1;
      if (bv == 0) return -1;
      return bv.compareTo(av); // plus grand XP = meilleur → descendant
    });
    return sorted;
  }

  // ── Utilisateurs ───────────────────────────────────────────────────────────

  /// Tri par XP impact descendant. impactScoreXp == 0 → fin de liste.
  List<Utilisateurs> sortedUsersByImpactScore({String? communityCode}) {
    final filtered = _filterByCommunity(communityCode);
    filtered.sort((a, b) {
      final av = a.impactScoreXp;
      final bv = b.impactScoreXp;
      if (av == 0 && bv == 0) return 0;
      if (av == 0) return 1;
      if (bv == 0) return -1;
      return bv.compareTo(av); // plus grand XP = meilleur → descendant
    });
    return filtered;
  }

  /// Tri par dernier bilan CO₂ ascendant. Score == 0 ou absent → fin de liste.
  List<Utilisateurs> sortedUsersByCarbonScore({String? communityCode}) {
    final filtered = _filterByCommunity(communityCode);
    filtered.sort((a, b) {
      final av = _latestCarbonScore(a.id);
      final bv = _latestCarbonScore(b.id);
      // Pas de bilan → fin de liste
      if (av == double.infinity && bv == double.infinity) return 0;
      if (av == double.infinity) return 1;
      if (bv == double.infinity) return -1;
      // Bilan à 0 → fin de liste
      if (av == 0 && bv == 0) return 0;
      if (av == 0) return 1;
      if (bv == 0) return -1;
      return av.compareTo(bv); // plus petit CO₂ = meilleur → ascendant
    });
    return filtered;
  }

  // ── Helpers privés ─────────────────────────────────────────────────────────

  List<Utilisateurs> _filterByCommunity(String? communityCode) {
    if (communityCode == null) return List<Utilisateurs>.from(users);
    return users.where((u) => u.codeCommunaute == communityCode).toList();
  }

  /// Renvoie le score du dernier bilan CO₂. [double.infinity] si aucun bilan.
  double _latestCarbonScore(String userId) {
    final userFp =
        carbonFootPrints.where((fp) => fp.userId == userId).toList();
    if (userFp.isEmpty) return double.infinity;
    userFp.sort((a, b) => b.dateBilan.compareTo(a.dateBilan));
    return userFp.first.score;
  }
}
