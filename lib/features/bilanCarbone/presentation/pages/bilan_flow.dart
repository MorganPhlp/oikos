import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/widgets/loader.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_state.dart';
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
import 'package:oikos/features/bilanCarbone/presentation/widgets/on_se_connait.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/resume_bilan_dialog.dart';
import 'package:oikos/init_dependencies.dart';

class BilanFlow extends StatefulWidget {
  final String? mode;
  const BilanFlow({super.key, this.mode = 'full'});

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
          create: (context) {
            final bloc = serviceLocator<BilanSessionBloc>();
            switch (widget.mode) {
              case 'full':
                bloc.add(CheckSessionEvent());
                break;
              case 'continuer':
                bloc.add(ContinuerBilanEvent());
                break;
              case 'modifier':
                bloc.add(ModifierBilanEvent());
                break;
            }
            return bloc;
          },
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
                  // Si une reprise est detecte (ie la personne n'a pas fini son bilan initial) on propose de reprendre ou de recommencer
                  if (state is SessionRepriseDetectee) {
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
                    // Sinon, si la session est prête, on démarre le questionnaire directement
                  } else if (state is SessionPrete) {
                    innerContext.read<QuestionnaireBloc>().add(
                      InitQuestionnaireEvent(
                        questions: state.questions,
                        reponsesInitiales: state.reponsesExistantes,
                        modeQuestionnaire: widget.mode == 'continuer'
                            ? ModeQuestionnaire.continuer
                            : ModeQuestionnaire.debut,
                      ),
                    );
                  }
                },
              ),

              BlocListener<QuestionnaireBloc, QuestionnaireState>(
                listener: (context, state) {
                  if (state is QuestionnaireTermine) {
                    if (widget.mode == 'full') {
                      showDialog(
                        context: context,
                        builder: (context) => OnSeConnait(),
                      );
                      innerContext.read<BilanResultatBloc>().add(
                        DemarrerAnalyseEvent(),
                      );
                    } else {
                      innerContext.read<BilanResultatBloc>().add(
                        AllerVersResultatEvent(),
                      );
                    }
                  }
                },
              ),

              BlocListener<BilanResultatBloc, ResultatState>(
                listener: (context, state) {
                  if (state is ResultatChoixCategories) {
                    _innerNavigatorKey.currentState?.pushNamed('categories');
                  } else if (state is ResultatFinal) {
                    _innerNavigatorKey.currentState?.pushNamedAndRemoveUntil(
                      'resultats',
                      (route) => false,
                    );
                  } else if (state is ResultatError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
            child: Stack(
              children: [
                PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) async {
                    if (didPop) return;
                    final NavigatorState? navigator =
                        _innerNavigatorKey.currentState;
                    if (navigator != null && navigator.canPop()) {
                      navigator.pop();
                    } else {
                      context.go('/');
                    }
                  },
                  child: Navigator(
                    key: _innerNavigatorKey,
                    initialRoute: 'questions',
                    onDidRemovePage: (page) {
                      if (page.name == 'categories') {
                        innerContext.read<QuestionnaireBloc>().add(
                          RetourVersQuestionnaireEvent(),
                        );
                      }
                    },
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(
                        settings: settings,
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

                BlocBuilder<BilanResultatBloc, ResultatState>(
                  builder: (context, state) {
                    if (state is ResultatLoading) {
                      return const Loader();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
