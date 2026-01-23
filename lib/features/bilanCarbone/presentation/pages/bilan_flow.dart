import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_session_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_session_event.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_session_state.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_event.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_state.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_event.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/bilan_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/choix_categories_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/choix_objectifs.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/resultats_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/resume_bilan_dialog.dart';
import 'package:oikos/init_dependencies.dart';

class BilanFlow extends StatefulWidget {
  final bool fullFlow;
  const BilanFlow({super.key, this.fullFlow = true});

  @override
  State<BilanFlow> createState() => _BilanFlowState();
}

class _BilanFlowState extends State<BilanFlow> {
  final GlobalKey<NavigatorState> _innerNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              serviceLocator<BilanSessionBloc>()..add(CheckSessionEvent()),
        ),
        BlocProvider(create: (context) => serviceLocator<QuestionnaireBloc>()),
        BlocProvider(create: (context) => serviceLocator<BilanResultatBloc>()),
      ],
      child: Builder(
        builder: (innerContext) {
          return MultiBlocListener(
            listeners: [
              BlocListener<BilanSessionBloc, BilanSessionState>(
                listener: (context, state) {
                  if (state is SessionRepriseDisponible) {
                    ResumeBilanDialog.show(
                      context: context,
                      onResume: () =>
                          innerContext.read<QuestionnaireBloc>().add(
                            InitQuestionnaireEvent(
                              questions: state.questions,
                              reponsesInitiales: state.reponsesExistantes,
                            ),
                          ),
                      onRestart: () => innerContext
                          .read<BilanSessionBloc>()
                          .add(ForcerNouveauBilan()),
                    );
                  } else if (state is SessionPrete) {
                    innerContext.read<QuestionnaireBloc>().add(
                      InitQuestionnaireEvent(
                        questions: state.questions,
                        reponsesInitiales: state.reponsesInitiales,
                      ),
                    );
                  }
                },
              ),
              BlocListener<QuestionnaireBloc, QuestionnaireState>(
                listener: (context, state) {
                  if (state is QuestionnaireTermine) {
                    if (widget.fullFlow) {
                      innerContext.read<BilanResultatBloc>().add(
                        DemarrerAnalyseEvent(),
                      );
                      _innerNavigatorKey.currentState?.pushNamed('categories');
                    } else {
                      context.go('/');
                    }
                  }
                },
              ),
            ],
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (didPop) return;

                final NavigatorState? navigator =
                    _innerNavigatorKey.currentState;
                if (navigator != null && navigator.canPop()) {
                  navigator.pop();
                  // Reset du bloc questionnaire lors d'un retour physique/gestuel
                  innerContext.read<QuestionnaireBloc>().add(
                    RetourVersQuestionnaireEvent(),
                  );
                } else {
                  context.go('/');
                }
              },
              child: Navigator(
                key: _innerNavigatorKey,
                initialRoute: 'questions',
                onDidRemovePage: (page) {
                  innerContext.read<QuestionnaireBloc>().add(
                    RetourVersQuestionnaireEvent(),
                  );
                },
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) {
                      switch (settings.name) {
                        case 'questions':
                          return const BilanPage();
                        case 'categories':
                          return const ChoixCategoriesPage();
                        case 'objectifs':
                          return const PersonalGoalPage();
                        case 'resultats':
                          return const ResultsPage();
                        default:
                          return const BilanPage();
                      }
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
