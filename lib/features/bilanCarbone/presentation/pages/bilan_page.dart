import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/type_widget.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_cubit.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/choix_categories_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/question_widget_factory.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/suggestions_widget.dart';
import 'package:oikos/init_dependencies.dart';

class BilanPage extends StatefulWidget {
  const BilanPage({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        // On injecte le Cubit ici, à la source
        create: (context) => serviceLocator<BilanCubit>()..demarrerBilan(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: BlocConsumer<BilanCubit, BilanState>(
          listener: (context, state) {
            // Initialisation locale des valeurs quand une question arrive
            if (state is BilanQuestionDisplayed) {
              _initialiserValeurParDefaut(state);
            }
            
            // Navigation vers le choix des catégories
            if (state is BilanChoixCategories) {
              final cubit = context.read<BilanCubit>();
              Navigator.of(context).push(
                ChoixCategoriesPage.route(cubit),
              );
            }
          },
          builder: (context, state) {
            if (state is BilanLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BilanQuestionDisplayed) {
              final double progress = state.index / state.totalQuestions;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logos/oikos_logo.png',
                      width: MediaQuery.of(context).size.width * 0.4, 
                    ),
                    _buildHeader(progress, state),
                    const SizedBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              state.question.icone ?? '',
                              style: const TextStyle(fontSize: 50),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              state.question.question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.lightTextPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 30),
                            state.question.suggestions != null ? SuggestionsWidget(
                            suggestions: List<String>.from(state.question.suggestions!.keys),
                            selectedSuggestion: _selectedSuggestion, 
                            onLocalChange: (key) {
                              setState(() {
                                _selectedSuggestion = key; // On retient quel bouton est cliqué
                                _currentAnswer = state.question.suggestions![key]; // La Map pour la logique
                                _isAnswerValid = true;
                              });
                            },
                          ) : const SizedBox.shrink(),
                          const SizedBox(height: 30),
                            QuestionWidgetFactory(
                              question: state.question,
                              currentValue: _currentAnswer,
                              onLocalChange: (newValue) {
                                setState(() {
                                  _currentAnswer = newValue;
                                  _selectedSuggestion = null; // On désélectionne la suggestion
                                  });
                              },
                              onValidityChange: (isValid) {
                                setState(() => _isAnswerValid = isValid);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFooterActions(context, state),
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

  Widget _buildHeader(double progress, BilanQuestionDisplayed state) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco_outlined, color: AppColors.gradientGreenEnd, size: 24),
            SizedBox(width: 8),
            Text(
              "Dis-nous comment tu vis",
              style: TextStyle(
                color: AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.gradientGreenEnd.withOpacity(0.2),
          color: AppColors.gradientGreenEnd,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        Text(
          "Question ${state.index} sur ${state.totalQuestions}",
          style: TextStyle(
            color: AppColors.lightTextPrimary.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterActions(BuildContext context, BilanQuestionDisplayed state) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.read<BilanCubit>().revenirQuestionPrecedente(),
              icon: const Icon(Icons.chevron_left),
              style: IconButton.styleFrom(
                side: const BorderSide(color: AppColors.gradientGreenEnd, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                fixedSize: const Size(56, 56),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GradientButton(
                label: state.index == state.totalQuestions ? "Terminer" : "Question suivante >",
                disabled: !_isAnswerValid && state.question.typeWidget != TypeWidget.slider,
                onPressed: () => context.read<BilanCubit>().repondre(_currentAnswer),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextLink("Je ne sais pas", () => context.read<BilanCubit>().repondre(null)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("•", style: TextStyle(color: Colors.grey)),
            ),
            _buildTextLink("Pas concerné", () => context.read<BilanCubit>().repondre(null)),
          ],
        ),
      ],
    );
  }

  Widget _buildTextLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.lightTextPrimary.withOpacity(0.6),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}