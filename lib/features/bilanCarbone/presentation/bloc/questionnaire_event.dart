import 'package:equatable/equatable.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';

abstract class QuestionnaireEvent extends Equatable {
  const QuestionnaireEvent();

  @override
  List<Object?> get props => [];
}

/// Initialise le moteur avec les données récupérées par le SessionBloc
class InitQuestionnaireEvent extends QuestionnaireEvent {
  final List<QuestionBilanEntity> questions;
  final List<ReponseUtilisateurEntity> reponsesInitiales;

  const InitQuestionnaireEvent({
    required this.questions,
    required this.reponsesInitiales,
  });

  @override
  List<Object?> get props => [questions, reponsesInitiales];
}

/// Enregistre une réponse et demande la question suivante
class RepondreQuestionEvent extends QuestionnaireEvent {
  final dynamic valeur;

  const RepondreQuestionEvent(this.valeur);

  @override
  List<Object?> get props => [valeur];
}

/// Revient à la question précédente (géré par le UseCase de navigation)
class QuestionPrecedenteEvent extends QuestionnaireEvent {}

class TerminerQuestionnaireEvent extends QuestionnaireEvent {}

class RetourVersQuestionnaireEvent extends QuestionnaireEvent {}

class AfficherNoticeApprofondissementEvent extends QuestionnaireEvent {}

class NoticeApprofondissementApprovedEvent extends QuestionnaireEvent {}
