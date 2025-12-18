import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart'; // <--- IMPORTANT : L'import doit être ici
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/precedente_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/prochaine_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
part 'bilan_state.dart';

class BilanCubit extends Cubit<BilanState> {
  final DemarrerBilanUseCase demarrerBilanUseCase;
  final EnregistrerReponseUseCase repondreUseCase;
  final GetProchaineQuestionUseCase getNextUseCase;
  final GetPreviousQuestionUseCase getPrevUseCase;

  List<QuestionBilanEntity> _allQuestions = [];
  int _currentIndex = 0;
  final Map<String, dynamic> reponses = {};

  BilanCubit({
    required this.demarrerBilanUseCase,
    required this.repondreUseCase,
    required this.getNextUseCase ,
    required this.getPrevUseCase,
  }) : super(BilanLoading());

  Future<void> demarrerBilan() async {
    emit(BilanLoading());
    _allQuestions = await demarrerBilanUseCase();
    
    // On s'assure que la première question est pertinente
    if (!getNextUseCase.applicabilityChecker.isQuestionApplicable(_allQuestions[_currentIndex])) {
      _currentIndex = await getNextUseCase(allQuestions: _allQuestions, currentIndex: -1);
    }
    _emitQuestion();
  }

  Future<void> repondre(dynamic valeur) async {
    final currentQ = _allQuestions[_currentIndex];
    await repondreUseCase(question: currentQ, valeur: valeur);
    reponses[currentQ.slug] = valeur;

    final nextIndex = await getNextUseCase(
      allQuestions: _allQuestions,
      currentIndex: _currentIndex,
    );

    if (nextIndex == -1) {
      emit(BilanTermine());
    } else {
      _currentIndex = nextIndex;
      _emitQuestion();
    }
  }

  Future<void> revenirQuestionPrecedente() async {
    _currentIndex = await getPrevUseCase(
      allQuestions: _allQuestions,
      currentIndex: _currentIndex,
    );
    _emitQuestion();
  }

  void _emitQuestion() {
    final q = _allQuestions[_currentIndex];
    emit(BilanQuestionDisplayed(
      question: q,
      index: _currentIndex + 1,
      totalQuestions: _allQuestions.length,
      valeurPrecedente: reponses[q.slug],
    ));
  }
}