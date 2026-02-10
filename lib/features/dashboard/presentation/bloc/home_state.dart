
part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

/// État initial (rien n'est encore chargé)
final class HomeInitial extends HomeState {}

/// Chargement en cours
final class HomeLoading extends HomeState {}

/// Données chargées avec succès
final class HomeLoaded extends HomeState {
  final String pseudo;

  HomeLoaded({required this.pseudo});
}

/// Erreur lors du chargement
final class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
