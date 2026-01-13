import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/type_widget.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/question_widget_factory.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/suggestion_container.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/suggestions_widget.dart';
import 'package:oikos/init_dependencies.dart';

import '../../../../core/common/widgets/loader.dart';

class BilanPage extends StatefulWidget {
  const BilanPage({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        // On injecte le Bloc ici, à la source
        create: (context) => serviceLocator<BilanBloc>()..add(DemarrerBilanEvent()),
        child: const BilanPage(),
      ),
    );
  }

  @override
  State<BilanPage> createState() => _BilanPageState();
}

class _BilanPageState extends State<BilanPage> {
  dynamic _currentAnswer;
  bool _isAnswerValid = false;
  String? _selectedSuggestion;
  final ScrollController _scrollController = ScrollController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<BilanBloc, BilanState>(
          buildWhen: (previous, current) => current is BilanQuestionDisplayed || current is BilanLoading,
          listenWhen: (previous, current) {

          if (current is BilanChoixCategories && previous is BilanQuestionDisplayed) {
            return true;
          }
          return false; 
        },
          listener: (context, state) {
            // Initialisation locale des valeurs quand une question arrive
            if (state is BilanQuestionDisplayed) {
              _initialiserValeurParDefaut(state);
            }
            
            // Navigation vers le choix des catégories
            if (state is BilanChoixCategories) {
              Navigator.of(context).pushNamed('categories');
            }
          },
          builder: (context, state) {
            if (state is BilanLoading) {
              return const Loader();
            }

            if (state is BilanQuestionDisplayed) {
              final double progress = state.index / state.totalQuestions;
              final size = MediaQuery.of(context).size;
              final horizontalPadding = size.width * 0.05;
              final verticalPadding = size.height * 0.012;
              
            return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  children: [
                    // --- ÉLÉMENTS FIXES (Haut) ---
                    Image.asset(
                      'assets/logos/oikos_logo.png',
                      width: size.width * 0.4,
                    ),
                    _buildHeader(progress, state, context),
                    SizedBox(height: size.height * 0.02),
                    
                    // Icône et Question restent fixes
                    Text(
                      state.question.icone ?? '',
                      style: TextStyle(fontSize: size.width * 0.12),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      state.question.question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: size.width < 360 ? 20 : size.width * 0.055,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),

                    // --- ZONE SCROLLABLE (Uniquement pour les réponses) ---
                    Expanded(
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              // Suggestions (si présentes)
                              if (state.question.suggestions != null) ...[
                                SuggestionsWidget(
                                  suggestions: List<String>.from(state.question.suggestions!.keys),
                                  selectedSuggestion: _selectedSuggestion,
                                  onLocalChange: (key) {
                                    setState(() {
                                      _selectedSuggestion = key;
                                      _currentAnswer = state.question.suggestions![key];
                                      _isAnswerValid = true;
                                    });
                                  },
                                ),
                                SizedBox(height: size.height * 0.02),
                              ],

                              // Le Widget Factory
                              QuestionWidgetFactory(
                                question: state.question,
                                currentValue: _currentAnswer,
                                onLocalChange: (newValue) {
                                  setState(() {
                                    _currentAnswer = newValue;
                                    _selectedSuggestion = null;
                                  });
                                },
                                onValidityChange: (isValid) {
                                  setState(() => _isAnswerValid = isValid);
                                },
                              ),
                              //Expliquation des suggestions 
                              if (state.question.suggestions != null)
                                SuggestionContainer(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // --- ÉLÉMENTS FIXES (Bas) ---
                    _buildFooterActions(context, state, size),
                  ],
                ),
              );
            }

            return const Center(child: Text("Initialisation du bilan..."));
          },
        ),
      ),
    );
  }

  void _initialiserValeurParDefaut(BilanQuestionDisplayed state) {
    if (state.valeurPrecedente == null) {
      setState(() {
        _currentAnswer = state.question.getInitialValue();
        _isAnswerValid = state.question.isAlwaysValid();
      });
    } else {
      setState(() {
        _isAnswerValid = true;
        _currentAnswer = state.valeurPrecedente;
      });
    }
  }

  Widget _buildHeader(double progress, BilanQuestionDisplayed state, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.eco_outlined, 
              color: AppColors.gradientGreenEnd, 
              size: isSmallScreen ? 20 : size.width * 0.06,
            ),
            SizedBox(width: size.width * 0.02),
            Text(
              "Dis-nous comment tu vis",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: isSmallScreen ? 14 : size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.018),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.gradientGreenEnd.withOpacity(0.2),
          color: AppColors.gradientGreenEnd,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          "Question ${state.index} sur ${state.totalQuestions}",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: isSmallScreen ? 11 : size.width * 0.03,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterActions(BuildContext context, BilanQuestionDisplayed state, Size size) {
    final buttonSize = size.width * 0.14;
    
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.read<BilanBloc>().add(RevenirQuestionPrecedenteEvent()),
              icon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onSurface),
              style: IconButton.styleFrom(
                side: const BorderSide(color: AppColors.gradientGreenEnd, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                fixedSize: Size(buttonSize, buttonSize),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            Expanded(
              child: GradientButton(
                label: state.index == state.totalQuestions ? "Terminer" : "Question suivante >",
                disabled: !_isAnswerValid && state.question.typeWidget != TypeWidget.slider,
                onPressed: () => context.read<BilanBloc>().add(RepondreQuestionEvent(_currentAnswer)),
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextLink("Je ne sais pas", () => context.read<BilanBloc>().add(RepondreQuestionEvent(null)), size),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Text("•", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
            ),
            _buildTextLink("Pas concerné", () => context.read<BilanBloc>().add(RepondreQuestionEvent(null)), size),
          ],
        ),
      ],
    );
  }

  Widget _buildTextLink(String text, VoidCallback onTap, Size size) {
    return InkWell(
      onTap: onTap,
      child: Builder(
        builder: (context) => Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            decoration: TextDecoration.underline,
            fontSize: size.width < 360 ? 13 : size.width * 0.035,
          ),
        ),
      ),
    );
  }
}