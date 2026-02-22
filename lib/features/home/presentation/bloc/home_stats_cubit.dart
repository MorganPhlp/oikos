import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/home/domain/usecases/build_stats_cards_use_case.dart';
import 'package:oikos/features/home/domain/usecases/get_home_stats_use_case.dart';
import 'package:oikos/features/home/presentation/bloc/home_stats_state.dart';

class HomeStatsCubit extends Cubit<HomeStatsState> {
  final GetHomeStatsUseCase _getHomeStats;
  final BuildStatsCardsUseCase _buildStatsCards;

  HomeStatsCubit({
    required GetHomeStatsUseCase getHomeStats,
    required BuildStatsCardsUseCase buildStatsCards,
  }) : _getHomeStats = getHomeStats,
       _buildStatsCards = buildStatsCards,
       super(const HomeStatsInitial());

  Future<void> loadStats(String userId) async {
    emit(const HomeStatsLoading());

    final result = await _getHomeStats(userId);

    result.fold((failure) => emit(HomeStatsError(failure.message)), (stats) {
      final cards = _buildStatsCards(stats);
      emit(HomeStatsLoaded(statsCards: cards));
    });
  }
}
