import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oikos/core/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_categories_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/choix_categories_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/definir_objectif_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_approfondissement_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/precedente_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/prochaine_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/objectif_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recommencer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_equivalents_carbone_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/preparer_choix_objectifs_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_questions_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_reponses_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/reprendre_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/verifier_bilan_en_cours_use_case.dart';

part 'bilan_event.dart';
part 'bilan_state.dart';

class BilanBloc extends Bloc<BilanEvent, BilanState> {
  final EnregistrerReponseUseCase repondreUseCase;
  final GetProchaineQuestionUseCase getNextUseCase;
  final GetPreviousQuestionUseCase getPrevUseCase;
  final ChoixCategoriesUseCase choixCategoriesUseCase;
  final DemarrerApprofondissementUseCase demarrerApprofondissementUseCase;
  final DefinirObjectifUseCase definirObjectifUseCase;
  final CalculerBilanUseCase calculerBilanUseCase;
  final CalculerBilanCategoriesUseCase calculerBilanCategoriesUseCase;
  final RecupererEquivalentsCarboneUseCase recupererEquivalentsCarboneUseCase;
  final PreparerChoixObjectifsUseCase preparerChoixObjectifsUseCase;
  final VerifierBilanEnCoursUseCase verifierBilanEnCoursUseCase;
  final RecupererReponsesUseCase recupererReponsesUseCase;
  final RecommencerBilanUseCase recommencerBilanUseCase;
  final ReprendreBilanUseCase reprendreBilanUseCase;
  final RecupererQuestionsUseCase recupererQuestionsUseCase;

  List<QuestionBilanEntity> _allQuestions = [];
  List<CategorieEmpreinteEntity> _allCategories = [];
  int _currentIndex = 0;
  final Map<String, dynamic> reponses = {};
  double? scoreTotal;

  BilanBloc({
    required this.repondreUseCase,
    required this.getNextUseCase,
    required this.getPrevUseCase,
    required this.choixCategoriesUseCase,
    required this.demarrerApprofondissementUseCase,
    required this.definirObjectifUseCase,
    required this.calculerBilanUseCase,
    required this.calculerBilanCategoriesUseCase,
    required this.recupererEquivalentsCarboneUseCase,
    required this.preparerChoixObjectifsUseCase,
    required this.verifierBilanEnCoursUseCase,
    required this.recupererReponsesUseCase,
    required this.recommencerBilanUseCase,
    required this.reprendreBilanUseCase,
    required this.recupererQuestionsUseCase,
  }) : super(BilanLoading()) {
    on<DemarrerBilanEvent>(_onDemarrerBilan);
    on<ReprendreBilanEvent>(_onReprendreBilan);
    on<RedemarrerBilanEvent>(_onRedemarrerBilan);
    on<RepondreQuestionEvent>(_onRepondreQuestion);
    on<RevenirQuestionPrecedenteEvent>(_onRevenirQuestionPrecedente);
    on<RetourVersQuestionsFromObjectifsEvent>(
      _onRetourVersQuestionsFromObjectifs,
    );
    on<RetourVersChoixCategoriesFromObjectifsEvent>(
      _onRetourVersChoixCategoriesFromObjectifs,
    );
    on<SelectionnerCategoriesEvent>(_onSelectionnerCategories);
    on<PreparerObjectifsEvent>(_onPreparerObjectifs);
    on<ValiderObjectifEvent>(_onValiderObjectif);
  }

  Future<void> _onDemarrerBilan(
    DemarrerBilanEvent event,
    Emitter<BilanState> emit,
  ) async {
    emit(BilanLoading());

    try {
      _allQuestions = await recupererQuestionsUseCase.call();

      // 2. Vérifier si un bilan est déjà en cours
      final hasBilan = await verifierBilanEnCoursUseCase();
      if (hasBilan) {
        emit(BilanRepriseDetectee());
        return;
      }

      // 3. Sinon, démarrer un nouveau bilan
      await _startNewBilan(emit);
    } catch (e) {
      print("❌ Erreur lors du démarrage du bilan : $e");
      emit(BilanError("Impossible d'initialiser le bilan : $e"));
    }
  }

  Future<void> _onReprendreBilan(
    ReprendreBilanEvent event,
    Emitter<BilanState> emit,
  ) async {
    emit(BilanLoading());

    try {
      List<ReponseUtilisateurEntity> allResponses =
          await recupererReponsesUseCase.call();
      _allQuestions = await recupererQuestionsUseCase.call();

      // reconstruire la map des réponses
      reponses.clear();
      for (var response in allResponses) {
        int responseId = response.questionId;
        String correspondingSlug = _allQuestions
            .firstWhere((q) => q.id == responseId)
            .slug;
        reponses[correspondingSlug] = response.valeur;
      }

      // appeler le use case de reprise
      _currentIndex = await reprendreBilanUseCase.call(_allQuestions, reponses);

      // verifier l'applicabilité de la question courante
      if (_currentIndex < _allQuestions.length) {
        if (!getNextUseCase.applicabilityChecker.isQuestionApplicable(
          _allQuestions[_currentIndex],
        )) {
          _currentIndex = await getNextUseCase(
            allQuestions: _allQuestions,
            currentIndex: _currentIndex - 1,
          );
        }
      }

      // 5. Afficher la question
      _emitQuestion(emit);
    } catch (e) {
      print("❌ Erreur Reprise Bilan : $e");
      emit(BilanError("Erreur lors de la récupération : $e"));
    }
  }

  Future<void> _onRedemarrerBilan(
    RedemarrerBilanEvent event,
    Emitter<BilanState> emit,
  ) async {
    emit(BilanLoading());
    // Réinitialiser et démarrer un nouveau bilan
    _currentIndex = 0;
    reponses.clear();
    await _startNewBilan(emit);
  }

  Future<void> _startNewBilan(Emitter<BilanState> emit) async {
    _allQuestions = await recommencerBilanUseCase();

    // On s'assure que la première question est pertinente
    if (!getNextUseCase.applicabilityChecker.isQuestionApplicable(
      _allQuestions[_currentIndex],
    )) {
      _currentIndex = await getNextUseCase(
        allQuestions: _allQuestions,
        currentIndex: -1,
      );
    }
    _emitQuestion(emit);
  }

  Future<void> _onRepondreQuestion(
    RepondreQuestionEvent event,
    Emitter<BilanState> emit,
  ) async {
    final currentQ = _allQuestions[_currentIndex];
    await repondreUseCase(question: currentQ, valeur: event.valeur);
    reponses[currentQ.slug] = event.valeur;

    final nextIndex = await getNextUseCase(
      allQuestions: _allQuestions,
      currentIndex: _currentIndex,
    );

    // On arrive à la fin des questions
    if (nextIndex == -1) {
      // cas fin des questions obligatoires - on lance l'approfondissement
      if (state is BilanQuestionDisplayed) {
        _allCategories = await demarrerApprofondissementUseCase.call();
        emit(BilanChoixCategories(_allCategories));
      }
    } // si il reste des questions
    else {
      _currentIndex = nextIndex;
      _emitQuestion(emit);
    }
  }

  Future<void> _onRevenirQuestionPrecedente(
    RevenirQuestionPrecedenteEvent event,
    Emitter<BilanState> emit,
  ) async {
    _currentIndex = await getPrevUseCase(
      allQuestions: _allQuestions,
      currentIndex: _currentIndex,
    );
    _emitQuestion(emit);
  }

  void _onRetourVersQuestionsFromObjectifs(
    RetourVersQuestionsFromObjectifsEvent event,
    Emitter<BilanState> emit,
  ) {
    _emitQuestion(emit);
  }

  void _onRetourVersChoixCategoriesFromObjectifs(
    RetourVersChoixCategoriesFromObjectifsEvent event,
    Emitter<BilanState> emit,
  ) {
    emit(BilanChoixCategories(_allCategories));
  }

  void _emitQuestion(Emitter<BilanState> emit) {
    final q = _allQuestions[_currentIndex];
    emit(
      BilanQuestionDisplayed(
        question: q,
        index: _currentIndex + 1,
        totalQuestions: _allQuestions.length,
        valeurPrecedente: reponses[q.slug],
      ),
    );
  }

  void _onSelectionnerCategories(
    SelectionnerCategoriesEvent event,
    Emitter<BilanState> emit,
  ) {
    // Logique pour gérer les catégories sélectionnées
    choixCategoriesUseCase.call(categories: event.categories);
    add(PreparerObjectifsEvent());
  }

  Future<void> _onPreparerObjectifs(
    PreparerObjectifsEvent event,
    Emitter<BilanState> emit,
  ) async {
    emit(BilanLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final resultat = await preparerChoixObjectifsUseCase.call();

      scoreTotal = resultat.scoreActuel;

      emit(
        BilanChoixObjectifs(
          scoreActuel: resultat.scoreActuel,
          objectifs: resultat.objectifs,
        ),
      );
    } catch (e) {
      print("❌ Erreur lors du calcul final : $e");
      emit(BilanError("Impossible de calculer votre bilan carbone."));
    }
  }

  Future<void> _onValiderObjectif(
    ValiderObjectifEvent event,
    Emitter<BilanState> emit,
  ) async {
    // Logique pour valider l'objectif choisi
    definirObjectifUseCase.call(event.objectif);
    emit(
      BilanResultats(
        scoreTotal: scoreTotal ?? 0.0,
        scoresParCategorie: await calculerBilanCategoriesUseCase.call(),
        equivalents: await recupererEquivalentsCarboneUseCase.call(),
      ),
    );
  }
}
