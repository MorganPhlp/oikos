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
  bool _isDeepening = false;
  int _indexLastQuestionObligatoire = 0;
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
    on<TerminerQuestionnaireEvent>((event, emit) {
      emit(QuestionnaireTermine());
    });
  }

  Future<void> _onInit(
    InitQuestionnaireEvent event,
    Emitter<QuestionnaireState> emit,
  ) async {
    _questions = event.questions;
    _reponsesLocal.clear();

    // Charger les réponses initiales dans le map local
    for (var r in event.reponsesInitiales) {
      try {
        final q = _questions.firstWhere(
          (element) => element.id == r.questionId,
        );
        _reponsesLocal[q.slug] = r.valeur;
      } catch (_) {}
    }

    // Reprendre le bilan pour retrouver l'index de la dernière question répondue
    _currentIndex = await reprendreBilanUseCase.call(
      _questions,
      _reponsesLocal,
    );

    //  Stocker l'index de la dernière question obligatoire
    _indexLastQuestionObligatoire = _questions.lastIndexWhere(
      (q) => q.estObligatoire,
    ); 

    // Détecter si on est en approfondissement
    if (_currentIndex > _indexLastQuestionObligatoire) {
      _isDeepening = true;
    }

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
    _isDeepening = _currentIndex > _indexLastQuestionObligatoire; // Met à jour le flag d'approfondissement
    final q = _questions[_currentIndex];
    emit(
      QuestionnaireAffiche(
        question: q,
        index: _currentIndex + 1,
        total: _questions.length,
        totalObligatoire: _indexLastQuestionObligatoire + 1,
        valeurActuelle: _reponsesLocal[q.slug],
        isDeepening: _isDeepening,
      ),
    );
  }
}
