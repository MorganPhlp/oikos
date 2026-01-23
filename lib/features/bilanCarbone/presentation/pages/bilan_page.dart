import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/type_widget.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_event.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_state.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/question_widget_factory.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/suggestions_widget.dart';
import '../../../../core/common/widgets/loader.dart';

class BilanPage extends StatefulWidget {
  const BilanPage({super.key});

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
        child: BlocConsumer<QuestionnaireBloc, QuestionnaireState>(
          buildWhen: (p, c) =>
              c is QuestionnaireAffiche || c is QuestionnaireLoading,
          listener: (context, state) {
            if (state is QuestionnaireAffiche) {
              _initialiserValeurParDefaut(state);
            }
          },
          builder: (context, state) {
            if (state is QuestionnaireLoading ||
                state is QuestionnaireInitial) {
              return const Loader();
            }

            if (state is QuestionnaireAffiche) {
              final double progress = state.index / state.total;
              final size = MediaQuery.of(context).size;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.012,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logos/oikos_logo.png',
                      width: size.width * 0.4,
                    ),
                    _buildHeader(progress, state, context),
                    SizedBox(height: size.height * 0.02),
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
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            if (state.question.suggestions != null)
                              SuggestionsWidget(
                                suggestions: List<String>.from(
                                  state.question.suggestions!.keys,
                                ),
                                selectedSuggestion: _selectedSuggestion,
                                onLocalChange: (key) {
                                  setState(() {
                                    _selectedSuggestion = key;
                                    _currentAnswer =
                                        state.question.suggestions![key];
                                    _isAnswerValid = true;
                                  });
                                },
                              ),
                            QuestionWidgetFactory(
                              key: ValueKey(
                                '${state.question.slug}_$_currentAnswer',
                              ),
                              question: state.question,
                              currentValue: _currentAnswer,
                              onLocalChange: (v) => setState(() {
                                _currentAnswer = v;
                                _selectedSuggestion = null;
                              }),
                              onValidityChange: (v) =>
                                  setState(() => _isAnswerValid = v),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildFooterActions(context, state, size),
                  ],
                ),
              );
            }
            return const Center(child: Text("Prêt à commencer..."));
          },
        ),
      ),
    );
  }

  void _initialiserValeurParDefaut(QuestionnaireAffiche state) {
    _currentAnswer = state.valeurActuelle ?? state.question.getInitialValue();
    _isAnswerValid =
        state.valeurActuelle != null || state.question.isAlwaysValid();
    setState(() {});
  }

  Widget _buildHeader(
    double progress,
    QuestionnaireAffiche state,
    BuildContext context,
  ) {
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
          "Question ${state.index} sur ${state.total}",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: isSmallScreen ? 11 : size.width * 0.03,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterActions(
    BuildContext context,
    QuestionnaireAffiche state,
    Size size,
  ) {
    final buttonSize = size.width * 0.14;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.read<QuestionnaireBloc>().add(
                QuestionPrecedenteEvent(),
              ),
              icon: Icon(
                Icons.chevron_left,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              style: IconButton.styleFrom(
                side: const BorderSide(
                  color: AppColors.gradientGreenEnd,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fixedSize: Size(buttonSize, buttonSize),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            Expanded(
              child: GradientButton(
                label: state.index == state.total
                    ? "Terminer"
                    : "Question suivante >",
                disabled:
                    !_isAnswerValid &&
                    state.question.typeWidget != TypeWidget.slider,
                onPressed: () => context.read<QuestionnaireBloc>().add(
                  RepondreQuestionEvent(_currentAnswer),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextLink(
              "Je ne sais pas",
              () => context.read<QuestionnaireBloc>().add(
                RepondreQuestionEvent(null),
              ),
              size,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Text(
                "•",
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
            _buildTextLink(
              "Pas concerné",
              () => context.read<QuestionnaireBloc>().add(
                RepondreQuestionEvent(null),
              ),
              size,
            ),
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
