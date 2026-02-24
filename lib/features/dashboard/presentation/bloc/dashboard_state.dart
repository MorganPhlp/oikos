
part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

/// État initial (rien n'est encore chargé)
final class DashboardInitial extends DashboardState {}

/// Chargement en cours
final class DashboardLoading extends DashboardState {}

/// Données chargées avec succès
final class DashboardLoaded extends DashboardState {
  final String pseudo;
  final DashboardBilanCarboneSummary? bilanCarbone;
  final List<CarboneEquivalentEntity> equivalents;
  final List<ContributionEntry> heatmapEntries;
  final DateTime heatmapMinDate;
  final DateTime heatmapMaxDate;
  final Map<String, double> actionCountsByCategoryLabel;
  final List<DashboardXpPoint> xpGainedSeries;
  final DashboardCommunityPositioningStats? communityPositioningStats;

  DashboardLoaded({
    required this.pseudo,
    required this.bilanCarbone,
    required this.equivalents,
    required this.heatmapEntries,
    required this.heatmapMinDate,
    required this.heatmapMaxDate,
    required this.actionCountsByCategoryLabel,
    required this.xpGainedSeries,
    required this.communityPositioningStats,
  });
}

/// Erreur lors du chargement
final class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}
