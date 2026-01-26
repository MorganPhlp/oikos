import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/precedente_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/prochaine_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/reprendre_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_event.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_state.dart';

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  final EnregistrerReponseUseCase repondreUseCase;
  final GetProchaineQuestionUseCase getNextUseCase;
  final GetPreviousQuestionUseCase getPrevUseCase;
  final ReprendreBilanUseCase reprendreBilanUseCase;

  List<QuestionBilanEntity> _questions = [];
  int _currentIndex = 0;
  final Map<String, dynamic> _reponsesLocal = {};

  QuestionnaireBloc({
    required this.repondreUseCase,
    required this.getNextUseCase,
    required this.getPrevUseCase,
    required this.reprendreBilanUseCase,
  }) : super(QuestionnaireInitial()) {
    on<InitQuestionnaireEvent>(_onInit);
    on<RepondreQuestionEvent>(_onRepondre);
    on<QuestionPrecedenteEvent>(_onPrecedente);
    on<RetourVersQuestionnaireEvent>((event, emit) {
      _emitCurrent(emit);
    });
  }

  Future<void> _onInit(
    InitQuestionnaireEvent event,
    Emitter<QuestionnaireState> emit,
  ) async {
    _questions = event.questions;
    _reponsesLocal.clear();

    for (var r in event.reponsesInitiales) {
      try {
        final q = _questions.firstWhere(
          (element) => element.id == r.questionId,
        );
        _reponsesLocal[q.slug] = r.valeur;
      } catch (_) {}
    }

    _currentIndex = await reprendreBilanUseCase.call(
      _questions,
      _reponsesLocal,
    );
    _emitCurrent(emit);
  }

  Future<void> _onRepondre(
    RepondreQuestionEvent event,
    Emitter<QuestionnaireState> emit,
  ) async {
    final currentQ = _questions[_currentIndex];
    await repondreUseCase(question: currentQ, valeur: event.valeur);
    _reponsesLocal[currentQ.slug] = event.valeur;

    final nextIdx = await getNextUseCase(
      allQuestions: _questions,
      currentIndex: _currentIndex,
    );

    if (nextIdx == -1) {
      emit(QuestionnaireTermine());
    } else {
      _currentIndex = nextIdx;
      _emitCurrent(emit);
    }
  }

  Future<void> _onPrecedente(
    QuestionPrecedenteEvent event,
    Emitter<QuestionnaireState> emit,
  ) async {
    _currentIndex = await getPrevUseCase(
      allQuestions: _questions,
      currentIndex: _currentIndex,
    );
    _emitCurrent(emit);
  }

  void _emitCurrent(Emitter<QuestionnaireState> emit) {
    if (_questions.isEmpty) return;
    final q = _questions[_currentIndex];
    emit(
      QuestionnaireAffiche(
        question: q,
        index: _currentIndex + 1,
        total: _questions.length,
        valeurActuelle: _reponsesLocal[q.slug],
      ),
    );
  }
}
