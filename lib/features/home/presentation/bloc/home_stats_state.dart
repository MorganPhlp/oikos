import 'package:equatable/equatable.dart';
import 'package:oikos/features/home/domain/entities/stats_cards_entitie.dart';

sealed class HomeStatsState extends Equatable {
  const HomeStatsState();

  @override
  List<Object?> get props => [];
}

class HomeStatsInitial extends HomeStatsState {
  const HomeStatsInitial();
}

class HomeStatsLoading extends HomeStatsState {
  const HomeStatsLoading();
}

class HomeStatsLoaded extends HomeStatsState {
  final List<StatsCardsEntitie> statsCards;

  const HomeStatsLoaded({required this.statsCards});

  @override
  List<Object?> get props => [statsCards];
}

class HomeStatsError extends HomeStatsState {
  final String message;

  const HomeStatsError(this.message);

  @override
  List<Object?> get props => [message];
}
