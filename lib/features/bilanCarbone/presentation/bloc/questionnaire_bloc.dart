import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/initialiser_moteur_de_calcul_use_case.dart';
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
  final InitialiserMoteurDeCalculUseCase initialiserMoteurDeCalculUseCase;

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
    required this.initialiserMoteurDeCalculUseCase,
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
    // pour afficher le message d'approfondissement
    on<AfficherNoticeApprofondissementEvent>((event, emit) {
      emit(QuestionnaireApprofondissementNotice());
    });
    // après approbation de la notice, revenir à la question courante
    on<NoticeApprofondissementApprovedEvent>((event, emit) {
      _isDeepening = true;
      _emitCurrent(emit);
    });
  }

  Future<void> _onInit(
    InitQuestionnaireEvent event,
    Emitter<QuestionnaireState> emit,
  ) async {
    emit(QuestionnaireLoading());
    await initialiserMoteurDeCalculUseCase.call();
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
    if(event.modeQuestionnaire == ModeQuestionnaire.debut){
      _currentIndex = 0;
      _emitCurrent(emit);
    // Si on est en mode "continuer", on reprend le bilan pour retrouver l'index de la dernière question répondue
    }else{
      _currentIndex = await reprendreBilanUseCase.call(
      _questions,
      _reponsesLocal,
    );

    }

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
      userId: event.userId,
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

    // transition vers l'approfondissement
    if (!_isDeepening && _currentIndex > _indexLastQuestionObligatoire) {
      emit(QuestionnaireApprofondissementNotice());
    return;
  }

  // transition approfondissement vers normal
    if (_isDeepening && _currentIndex <= _indexLastQuestionObligatoire) {
      _isDeepening = false;
    }

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
