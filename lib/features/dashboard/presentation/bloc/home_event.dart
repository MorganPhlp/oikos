part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

/// Déclenché quand la page d'accueil doit charger les données utilisateur
final class HomeLoadRequested extends HomeEvent {}
