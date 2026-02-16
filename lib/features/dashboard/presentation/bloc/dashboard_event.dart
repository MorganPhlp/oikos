part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

/// Déclenché quand la page d'accueil doit charger les données utilisateur
final class DashboardLoadRequested extends DashboardEvent {}