import 'package:equatable/equatable.dart';

abstract class BilanSessionEvent extends Equatable {
  const BilanSessionEvent();

  @override
  List<Object?> get props => [];
}

/// Événement initial : lancé au chargement de la page pour vérifier
/// si un bilan est déjà en cours dans la base de données locale.
class CheckSessionEvent extends BilanSessionEvent {}

/// Lancé si l'utilisateur décide d'ignorer sa sauvegarde
/// et de recommencer le questionnaire à zéro.
class ForcerNouveauBilan extends BilanSessionEvent {}

/// Lancé pour confirmer qu'on souhaite reprendre là où on s'est arrêté.
/// Note : Souvent, le simple fait de ne pas "ForcerNouveauBilan" suffit,
/// mais cet event permet une transition explicite dans l'UI.
class ConfirmerRepriseEvent extends BilanSessionEvent {}

/// Permet de réinitialiser complètement la session (utile pour un bouton "Recommencer"
/// présent dans les réglages ou à la fin du parcours).
class RedemarrerBilanEvent extends BilanSessionEvent {}
