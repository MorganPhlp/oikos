import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/enregistrer_reponse_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/prochaine_question_use_case.dart';


part 'bilan_state.dart';

class BilanCubit extends Cubit<BilanState> {
  // Dépendances (Use Cases)
  final DemarrerBilanUseCase demarrerBilanUseCase;
  final EnregistrerReponseUseCase repondreUseCase; 
  final GetProchaineQuestionUseCase prochaineQuestionUseCase;
  final Map<String, dynamic> reponses = {};
  
  // Correction ici :
  BilanCubit({
    required this.demarrerBilanUseCase,
    required this.repondreUseCase,
    required this.prochaineQuestionUseCase,
  }) : super(BilanLoading()); // <-- AJOUT DE L'APPEL AU CONSTRUCTEUR PARENT

  // --- 1. DÉMARRAGE DU BILAN ---
  Future<void> demarrerBilan() async {
    emit(BilanLoading());
    try {
      // 1. Déléguer l'initialisation et obtenir les questions
      final allQuestions = await demarrerBilanUseCase.call();
      
      // 2. Initialiser le Use Case de navigation avec la liste
      prochaineQuestionUseCase.setQuestions(allQuestions);
      
      // 3. Afficher la première question pertinente
      await _chargerProchaineQuestion();
      
    } catch (e) {
      // ...
    }
  }

  // --- 2. RÉPONSE UTILISATEUR ---
  Future<void> repondre(dynamic valeur) async {
    final currentQ = (state as BilanQuestionDisplayed).question;

    try {
      // 1. Déléguer TOUTE la logique d'enregistrement et de simulation
      await repondreUseCase.call(question: currentQ, valeur: valeur); 
      reponses[currentQ.slug] = valeur;
      // 2. Avancer l'index dans le Use Case de navigation
      prochaineQuestionUseCase.avancerIndex();

      // 3. Chercher la suivante
      await _chargerProchaineQuestion(); 

    } catch (e) {
      // ...
    }
  }

  Future<void> revenirQuestionPrecedente() async {
    // 1. Reculer l'index dans le Use Case de navigation
    if (state is! BilanQuestionDisplayed) return;
    if(prochaineQuestionUseCase.currentIndex == 0) return;
    emit (BilanLoading());
    prochaineQuestionUseCase.reculerIndex();

    // 2. Chercher la précédente
    await _chargerProchaineQuestion(); 
  }

  // --- 3. LOGIQUE DE NAVIGATION (Simplifiée) ---
  Future<void> _chargerProchaineQuestion() async {
    // Déléguer la logique métier complexe au Use Case
    final nextQuestion = await prochaineQuestionUseCase.call();
    final valeurPrecedente = reponses[nextQuestion?.slug];
    if (nextQuestion != null) {
      emit(BilanQuestionDisplayed(
        question: nextQuestion,
        index: prochaineQuestionUseCase.currentIndex + 1,
        totalQuestions: prochaineQuestionUseCase.totalQuestions,
        valeurPrecedente: valeurPrecedente,
      ));
    } else {
      emit(BilanTermine());
    }
  }
}