
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

  DashboardLoaded({
    required this.pseudo,
    required this.bilanCarbone,
    required this.equivalents,
  });
}

/// Erreur lors du chargement
final class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}
