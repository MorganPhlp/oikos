import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart'; // <--- IMPORTANT : L'import doit être ici
import 'package:oikos/core/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_categories_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/choix_categories_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/definir_objectif_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_approfondissement_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/precedente_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/prochaine_question_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/objectif_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_equivalents_carbone_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/preparer_choix_objectifs_use_case.dart';
part 'bilan_state.dart';

class BilanCubit extends Cubit<BilanState> {
  final DemarrerBilanUseCase demarrerBilanUseCase;
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

  List<QuestionBilanEntity> _allQuestions = [];
  List<CategorieEmpreinteEntity> _allCategories = [];
  int _currentIndex = 0;
  final Map<String, dynamic> reponses = {};
  double? scoreTotal;

  BilanCubit({
    required this.demarrerBilanUseCase,
    required this.repondreUseCase,
    required this.getNextUseCase ,
    required this.getPrevUseCase,
    required this.choixCategoriesUseCase,
    required this.demarrerApprofondissementUseCase,
    required this.definirObjectifUseCase,
    required this.calculerBilanUseCase,
    required this.calculerBilanCategoriesUseCase,
    required this.recupererEquivalentsCarboneUseCase,
    required this.preparerChoixObjectifsUseCase,
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

    //On arrive a la fin des questions
    if (nextIndex == -1) {
      // cas fin des questions obligatoires - on lance l'approfondissement
      if (state is BilanQuestionDisplayed){
      _allCategories = await demarrerApprofondissementUseCase.call();
      emit(BilanChoixCategories(_allCategories));}
    } // si il reste des questions
    else {
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

  void retourVersQuestionsFromObjectifs() {
    _emitQuestion();
  }

  void retourVersChoixCategoriesFromObjectifs() {
    emit(BilanChoixCategories(_allCategories));
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

  void setSelectedCategories(List<CategorieEmpreinteEntity> categories) {
    // Logique pour gérer les catégories sélectionnées
    choixCategoriesUseCase.call(categories: categories);
    preparerObjectifs();
  }

  void preparerObjectifs() async {
    emit(BilanLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final resultat = await preparerChoixObjectifsUseCase.call();
      
      scoreTotal = resultat.scoreActuel;
      
      emit(BilanChoixObjectifs(
        scoreActuel: resultat.scoreActuel,
        objectifs: resultat.objectifs,
      ));
    } catch (e) {
      print("❌ Erreur lors du calcul final : $e");
      emit(BilanError("Impossible de calculer votre bilan carbone."));
    }
  }

  void validerObjectif(double objectif) async {
    // Logique pour valider l'objectif choisi
    definirObjectifUseCase.call(objectif);
    emit(BilanResultats(
      scoreTotal: scoreTotal ?? 0.0, 
      scoresParCategorie: await calculerBilanCategoriesUseCase.call(),
      equivalents: await recupererEquivalentsCarboneUseCase.call(),
      ));
  }

}