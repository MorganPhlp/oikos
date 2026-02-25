import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/data/models/aggregates/ranking_data.dart';
import 'package:oikos/features/admin/data/models/core/carbon_foot_print.dart';
import 'package:oikos/features/admin/data/models/core/community.dart';
import 'package:oikos/features/admin/domain/use_cases/get_rankings.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_event.dart';
import 'package:oikos/features/admin/presentation/bloc/ranking_state.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState> {
  final GetRankings getRanking;

  RankingBloc({required this.getRanking}) : super(RankingInitial()) {
    on<RankingDataFetched>(_onDataFetched);
    on<RankingTypeChanged>(_onTypeChanged);
    on<CommunitySortChanged>(_onCommunitySortChanged);
    on<UserSortChanged>(_onUserSortChanged);
    on<CommunityFilterChanged>(_onCommunityFilterChanged);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HANDLERS
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onDataFetched(
    RankingDataFetched event,
    Emitter<RankingState> emit,
  ) async {
    emit(RankingLoading());
    final result = await getRanking(event.companyId);
    result.fold(
      (failure) => emit(RankingError(message: failure.message)),
      (data) => emit(
        _buildState(
          data: data,
          rankingType: RankingType.communities,
          communitySortBy: CommunitySortBy.avgScore,
          userSortBy: UserSortBy.impactScoreXp,
          selectedCommunityCode: null,
        ),
      ),
    );
  }

  void _onTypeChanged(RankingTypeChanged event, Emitter<RankingState> emit) {
    if (state is! RankingLoaded) return;
    final s = state as RankingLoaded;
    emit(
      _buildState(
        data: s.data,
        rankingType: event.rankingType,
        communitySortBy: s.communitySortBy,
        userSortBy: s.userSortBy,
        selectedCommunityCode: s.selectedCommunityCode,
      ),
    );
  }

  void _onCommunitySortChanged(
    CommunitySortChanged event,
    Emitter<RankingState> emit,
  ) {
    if (state is! RankingLoaded) return;
    final s = state as RankingLoaded;
    emit(
      _buildState(
        data: s.data,
        rankingType: s.rankingType,
        communitySortBy: event.sortBy,
        userSortBy: s.userSortBy,
        selectedCommunityCode: s.selectedCommunityCode,
      ),
    );
  }

  void _onUserSortChanged(UserSortChanged event, Emitter<RankingState> emit) {
    if (state is! RankingLoaded) return;
    final s = state as RankingLoaded;
    emit(
      _buildState(
        data: s.data,
        rankingType: s.rankingType,
        communitySortBy: s.communitySortBy,
        userSortBy: event.sortBy,
        selectedCommunityCode: s.selectedCommunityCode,
      ),
    );
  }

  void _onCommunityFilterChanged(
    CommunityFilterChanged event,
    Emitter<RankingState> emit,
  ) {
    if (state is! RankingLoaded) return;
    final s = state as RankingLoaded;
    emit(
      _buildState(
        data: s.data,
        rankingType: s.rankingType,
        communitySortBy: s.communitySortBy,
        userSortBy: s.userSortBy,
        selectedCommunityCode: event.communityCode,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STATE BUILDER
  // ─────────────────────────────────────────────────────────────────────────

  RankingLoaded _buildState({
    required RankingData data,
    required RankingType rankingType,
    required CommunitySortBy communitySortBy,
    required UserSortBy userSortBy,
    required String? selectedCommunityCode,
  }) {
    return RankingLoaded(
      data: data,
      rankingType: rankingType,
      communitySortBy: communitySortBy,
      userSortBy: userSortBy,
      selectedCommunityCode: selectedCommunityCode,
      sortedCommunities: _sortCommunities(data.communities, communitySortBy),
      sortedUsers: _sortUsers(
        data.users,
        data.carbonFootPrints,
        userSortBy,
        selectedCommunityCode,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SORTING HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  static List<Community> _sortCommunities(
    List<Community> communities,
    CommunitySortBy sortBy,
  ) {
    final sorted = List<Community>.from(communities);
    switch (sortBy) {
      case CommunitySortBy.avgScore:
        // CO₂ moyen : plus petit = meilleur → tri ascendant
        sorted.sort((a, b) => (a.avgScore ?? 0).compareTo(b.avgScore ?? 0));
      case CommunitySortBy.plantXp:
        // XP plantes : plus grand = meilleur → tri descendant
        sorted.sort((a, b) => (b.plantXp ?? 0).compareTo(a.plantXp ?? 0));
    }
    return sorted;
  }

  static List<Utilisateurs> _sortUsers(
    List<Utilisateurs> users,
    List<CarbonFootPrint> footprints,
    UserSortBy sortBy,
    String? communityCode,
  ) {
    final filtered = communityCode == null
        ? List<Utilisateurs>.from(users)
        : users.where((u) => u.codeCommunaute == communityCode).toList();

    switch (sortBy) {
      case UserSortBy.impactScoreXp:
        // XP impact : plus grand = meilleur → tri descendant
        filtered.sort((a, b) => b.impactScoreXp.compareTo(a.impactScoreXp));
      case UserSortBy.carbonScore:
        // Dernier bilan CO₂ : plus petit = meilleur → tri ascendant
        filtered.sort((a, b) {
          final aScore = _latestCarbonScore(a.id, footprints);
          final bScore = _latestCarbonScore(b.id, footprints);
          return aScore.compareTo(bScore);
        });
    }
    return filtered;
  }

  /// Renvoie le score du dernier bilan CO₂ d'un utilisateur.
  /// Retourne [double.infinity] si aucun bilan disponible (classé dernier).
  static double _latestCarbonScore(
    String userId,
    List<CarbonFootPrint> footprints,
  ) {
    final userFp = footprints.where((fp) => fp.userId == userId).toList();
    if (userFp.isEmpty) return double.infinity;
    // dateBilan est une chaîne ISO-8601 : tri lexicographique correct
    userFp.sort((a, b) => b.dateBilan.compareTo(a.dateBilan));
    return userFp.first.score;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC STATIC HELPERS (utilisés dans l'UI)
  // ─────────────────────────────────────────────────────────────────────────

  /// Calcule le pourcentage de progression pour la barre d'avancement.
  ///
  /// - [isLowerBetter] = true  → CO₂ (plus petit = meilleur) : bar inversée
  /// - [isLowerBetter] = false → XP (plus grand = meilleur) : bar directe
  static double progressPercent({
    required double value,
    required double maxValue,
    required bool isLowerBetter,
  }) {
    if (maxValue <= 0) return 0.0;
    if (isLowerBetter) {
      return (1.0 - (value / maxValue)).clamp(0.0, 1.0);
    }
    return (value / maxValue).clamp(0.0, 1.0);
  }

  /// Renvoie le score CO₂ du dernier bilan d'un utilisateur (accès public).
  static double getLatestCarbonScore(
    String userId,
    List<CarbonFootPrint> footprints,
  ) => _latestCarbonScore(userId, footprints);
}
