// session_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recommencer_bilan_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_questions_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_reponses_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/verifier_bilan_en_cours_use_case.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_session_event.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_session_state.dart';

class BilanSessionBloc extends Bloc<BilanSessionEvent, BilanSessionState> {
  final VerifierBilanEnCoursUseCase verifierBilanUseCase;
  final RecupererQuestionsUseCase recupererQuestionsUseCase;
  final RecupererReponsesUseCase recupererReponsesUseCase;
  final RecommencerBilanUseCase recommencerBilanUseCase;

  BilanSessionBloc({
    required this.verifierBilanUseCase,
    required this.recupererQuestionsUseCase,
    required this.recupererReponsesUseCase,
    required this.recommencerBilanUseCase,
  }) : super(SessionInitial()) {
    on<CheckSessionEvent>(_onCheckSession);
    on<ForcerNouveauBilan>(_onForcerNouveau);
    on<ModifierBilanEvent>(_onModifierBilan);
    on<ContinuerBilanEvent>(_onContinuerBilan);
  }

  Future<void> _onCheckSession(
    CheckSessionEvent event,
    Emitter<BilanSessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      final questions = await recupererQuestionsUseCase();
      final hasBilan = await verifierBilanUseCase();

      if (hasBilan) {
        final reponses = await recupererReponsesUseCase();
        emit(
          SessionRepriseDetectee(
            questions: questions,
            reponsesExistantes: reponses,
          ),
        );
      } else {
        await recommencerBilanUseCase();
        emit(SessionPrete(questions: questions, reponsesExistantes: const []));
      }
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }

  Future<void> _onModifierBilan(
    ModifierBilanEvent event,
    Emitter<BilanSessionState> emit,
  ) async {
    emit(SessionLoading());
    final questions = await recupererQuestionsUseCase();
    final reponses = await recupererReponsesUseCase();
        emit(
          SessionPrete(
            questions: questions,
            reponsesExistantes: reponses,
            mode: ModeBilan.modifier,
          ));
  }

  Future<void> _onForcerNouveau(
    ForcerNouveauBilan event,
    Emitter<BilanSessionState> emit,
  ) async {
    emit(SessionLoading());
    final questions = await recommencerBilanUseCase();
    emit(SessionPrete(questions: questions, reponsesExistantes: const [], mode: ModeBilan.full));
  }

  Future<void> _onContinuerBilan(
    ContinuerBilanEvent event,
    Emitter<BilanSessionState> emit,
  ) async {
    emit(SessionLoading());
    final questions = await recupererQuestionsUseCase();
    final reponses = await recupererReponsesUseCase();
        emit(
          SessionPrete(
            questions: questions,
            reponsesExistantes: reponses,
            mode: ModeBilan.continuer,
          ));
   }
}
