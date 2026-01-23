import 'package:equatable/equatable.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';

abstract class QuestionnaireState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuestionnaireInitial extends QuestionnaireState {}

class QuestionnaireLoading extends QuestionnaireState {}

class QuestionnaireRepriseDetectee extends QuestionnaireState {}

class QuestionnaireAffiche extends QuestionnaireState {
  final QuestionBilanEntity question;
  final int index;
  final int total;
  final dynamic valeurActuelle;

  QuestionnaireAffiche({
    required this.question,
    required this.index,
    required this.total,
    this.valeurActuelle,
  });

  @override
  List<Object?> get props => [question, index, total, valeurActuelle];
}

class QuestionnaireTermine extends QuestionnaireState {}

class QuestionnaireError extends QuestionnaireState {
  final String message;
  QuestionnaireError(this.message);
}
