import 'package:equatable/equatable.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';

abstract class BilanSessionState extends Equatable {
  const BilanSessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends BilanSessionState {}

class SessionLoading extends BilanSessionState {}

class SessionRepriseDetectee extends BilanSessionState {
  final List<QuestionBilanEntity> questions;
  final List<ReponseUtilisateurEntity> reponsesExistantes;

  const SessionRepriseDetectee({
    required this.questions,
    required this.reponsesExistantes,
  });
}

/// État : Tout est prêt pour afficher la première (ou la prochaine) question.
class SessionPrete extends BilanSessionState {
  final List<QuestionBilanEntity> questions;
  final List<ReponseUtilisateurEntity> reponsesExistantes;
  final ModeBilan? mode;

  const SessionPrete({
    required this.questions,
    required this.reponsesExistantes,
    this.mode = ModeBilan.full,
  });
}

class SessionError extends BilanSessionState {
  final String message;
  const SessionError(this.message);
}

enum ModeBilan { full, continuer, modifier }