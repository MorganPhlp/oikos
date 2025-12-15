import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/question_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/services/applicability_checker.dart';


part 'bilan_state.dart';

class BilanCubit extends Cubit<BilanState> {
  // Dépendances (Injectées)
  final SimulationRepository simulationRepo; // Gère Publicodes
  final QuestionRepository questionRepo;     // Gère Supabase
  final ApplicabilityChecker _applicabilityChecker;

  // État interne (Privé)
  List<QuestionBilanEntity> _allQuestions = [];
  int _currentIndex = 0;

  BilanCubit({
    required this.simulationRepo,
    required this.questionRepo,
    required ApplicabilityChecker? applicabilityChecker,
  }) : _applicabilityChecker = applicabilityChecker ?? ApplicabilityChecker(simulationRepo),
       super(BilanLoading());

  // --- 1. DÉMARRAGE DU BILAN ---
  Future<void> demarrerBilan() async {
    emit(BilanLoading());
    try {
      // A. Initialiser le moteur JS
      await simulationRepo.init();

      // B. Récupérer les questions depuis Supabase
      _allQuestions = await questionRepo.getQuestions();

      // C. Chercher la première question pertinente
      await _chargerProchaineQuestion();
      
    } catch (e) {
      emit(BilanError("Erreur au démarrage : $e"));
    }
  }

  // --- 2. RÉPONSE UTILISATEUR ---
  Future<void> repondre(dynamic valeur) async {
    // Sécurité : on vérifie qu'une question est bien affichée
    if (state is! BilanQuestionDisplayed) return;
    
    final currentQ = (state as BilanQuestionDisplayed).question;

    try {
      // A. Envoyer la réponse au moteur (via le Repo qui nettoie les données)
      simulationRepo.updateSituation({ currentQ.slug : valeur });

      // B. On considère cette question comme traitée, on avance
      _currentIndex++;

      // C. On cherche la suivante
      await _chargerProchaineQuestion();

    } catch (e) {
      emit(BilanError("Erreur lors de la réponse : $e"));
    }
  }

  // --- 3. LOGIQUE DE NAVIGATION (Le Cœur) ---
  Future<void> _chargerProchaineQuestion() async {
    // Boucle tant qu'on n'est pas à la fin
    while (_currentIndex < _allQuestions.length) {
      print("Vérification de la question à l'index $_currentIndex sur ${_allQuestions.length} questions.");
      final candidate = _allQuestions[_currentIndex];

      // Faut il poser cette question ?
      final isPertinente = _applicabilityChecker.isQuestionApplicable(candidate);
      if (isPertinente) {
        //  On met à jour l'état de l'UI.
        emit(BilanQuestionDisplayed(
          question: candidate,
          index: _currentIndex + 1,
          totalQuestions: _allQuestions.length,
        ));
        return; // On arrête la fonction ici, on attend l'utilisateur.
      }

      // Si pas pertinente, on passe à la suivante sans rien dire à l'UI
      _currentIndex++;
    }

    // Si on sort de la boucle, c'est qu'il n'y a plus de questions.
    print ("Aucune question restante. Bilan terminé.");
    emit(BilanTermine());
  }
}