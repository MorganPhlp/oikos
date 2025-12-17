import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/services/QuestionnaireNavigator.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/prochaine_question_use_case.dart';


part 'bilan_state.dart';

class BilanCubit extends Cubit<BilanState> {
  final DemarrerBilanUseCase demarrerBilanUseCase;
  final EnregistrerReponseUseCase repondreUseCase;
  final QuestionnaireNavigator navigator; // On utilise le service directement ou via UseCase

  final Map<String, dynamic> reponses = {};

  BilanCubit({
    required this.demarrerBilanUseCase,
    required this.repondreUseCase,
    required this.navigator,
  }) : super(BilanLoading());

  Future<void> demarrerBilan() async {
    emit(BilanLoading());
    final allQuestions = await demarrerBilanUseCase.call();
    navigator.setQuestions(allQuestions);
    
    // Si la 1ère question n'est pas applicable, on cherche la 1ère pertinente
    QuestionBilanEntity? q = navigator.currentQuestion;
    if (q != null && !navigator.applicabilityChecker.isQuestionApplicable(q)) {
      q = await navigator.moveNext();
    }
    _emitQuestion(q);
  }

  Future<void> repondre(dynamic valeur) async {
    final currentQ = (state as BilanQuestionDisplayed).question;
    await repondreUseCase.call(question: currentQ, valeur: valeur);
    reponses[currentQ.slug] = valeur;

    final next = await navigator.moveNext();
    _emitQuestion(next);
  }

  Future<void> revenirQuestionPrecedente() async {
    final prev = await navigator.movePrevious();
    _emitQuestion(prev);
  }

  void _emitQuestion(QuestionBilanEntity? q) {
    if (q != null) {
      emit(BilanQuestionDisplayed(
        question: q,
        index: navigator.currentIndex + 1,
        totalQuestions: navigator.totalQuestions,
        valeurPrecedente: reponses[q.slug],
      ));
    } else {
      emit(BilanTermine());
    }
  }
}