import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/type_widget.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_event.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/questionnaire_state.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_notice_dialog.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/question_widget_factory.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/suggestions_widget.dart';
import '../../../../core/common/presentation/widgets/loader.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<QuestionnaireBloc, QuestionnaireState>(
          buildWhen: (p, c) =>
              c is QuestionnaireAffiche || c is QuestionnaireLoading,
          listener: (context, state) {
            if (state is QuestionnaireAffiche) {
              _initialiserValeurParDefaut(state);
            }
            if (state is QuestionnaireApprofondissementNotice) {
              BilanNoticeDialog.showNotice(
                context: context,
                onStart: () => context.read<QuestionnaireBloc>().add(
                  NoticeApprofondissementApprovedEvent(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is QuestionnaireLoading ||
                state is QuestionnaireInitial) {
              return const Loader();
            }

            if (state is QuestionnaireAffiche) {
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
                    _buildHeader(state, context),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      state.question.icone ?? '',
                      style: TextStyle(fontSize: size.width * 0.12),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      state.question.question,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
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
                              key: ValueKey(state.question.slug),
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

  Widget _buildHeader(QuestionnaireAffiche state, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    // Couleurs : Thème pour l'obligatoire, Orange pour l'approfondissement
    final mandatoryColor = colorScheme.primary;
    final deepeningColor =
        colorScheme.tertiary; // Forcé en orange comme demandé

    final int localIndex = state.isDeepening
        ? (state.index - state.totalObligatoire)
        : state.index;
    final int localTotal = state.isDeepening
        ? (state.total - state.totalObligatoire)
        : state.totalObligatoire;
    final String phaseLabel = state.isDeepening
        ? "Approfondissement"
        : "Question";

    final double targetGreenRatio = state.isDeepening
        ? (state.totalObligatoire / state.total)
        : 1.0;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Row(
                key: ValueKey(state.isDeepening),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    state.isDeepening ? Icons.add_chart : Icons.eco_outlined,
                    color: state.isDeepening ? deepeningColor : mandatoryColor,
                    size: isSmallScreen ? 20 : size.width * 0.05,
                  ),
                  SizedBox(width: size.width * 0.02),
                  Text(
                    state.isDeepening
                        ? "Approfondissons"
                        : "Dis-nous comment tu vis",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 13 : size.width * 0.038,
                    ),
                  ),
                ],
              ),
            ),
            if (state.isDeepening)
              Positioned(
                right: 0,
                child: _buildTextLink(
                  "Terminer Maintenant",
                  () => _confirmSkip(context),
                  size,
                  color: deepeningColor,
                ),
              ),
          ],
        ),
        SizedBox(height: size.height * 0.015),
        LayoutBuilder(
          builder: (context, constraints) {
            final fullWidth = constraints.maxWidth;
            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
              tween: Tween<double>(begin: 1.0, end: targetGreenRatio),
              builder: (context, ratio, child) {
                final double gap = state.isDeepening ? 6.0 : 0.0;
                final double greenPart = ((fullWidth * ratio) - (gap / 2))
                    .clamp(0.0, fullWidth);
                final double orangePart =
                    ((fullWidth * (1 - ratio)) - (gap / 2)).clamp(
                      0.0,
                      fullWidth,
                    );

                return Row(
                  children: [
                    if (greenPart > 0)
                      SizedBox(
                        width: greenPart,
                        child: LinearProgressIndicator(
                          value: state.isDeepening
                              ? 1.0
                              : (state.index / state.totalObligatoire),
                          backgroundColor: mandatoryColor.withValues(
                            alpha: 0.1,
                          ),
                          color: mandatoryColor,
                          minHeight: 8,
                          borderRadius: BorderRadius.horizontal(
                            left: const Radius.circular(4),
                            right: Radius.circular(state.isDeepening ? 0 : 4),
                          ),
                        ),
                      ),
                    if (state.isDeepening && orangePart > 0) ...[
                      SizedBox(width: gap),
                      SizedBox(
                        width: orangePart,
                        child: LinearProgressIndicator(
                          value:
                              (state.index - state.totalObligatoire) /
                              (state.total - state.totalObligatoire),
                          backgroundColor: deepeningColor.withValues(
                            alpha: 0.1,
                          ),
                          color: deepeningColor,
                          minHeight: 8,
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            );
          },
        ),
        SizedBox(height: size.height * 0.008),
        Text(
          "$phaseLabel $localIndex sur $localTotal",
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: isSmallScreen ? 11 : size.width * 0.028,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final buttonSize = size.width * 0.14;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.read<QuestionnaireBloc>().add(
                QuestionPrecedenteEvent(),
              ),
              icon: Icon(Icons.chevron_left, color: colorScheme.onSurface),
              style: IconButton.styleFrom(
                side: BorderSide(color: colorScheme.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fixedSize: Size(buttonSize, buttonSize),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            Expanded(
              child: GradientButton(
                label: state.index == state.total ? "Terminer" : "Suivant >",
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
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
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

  Widget _buildTextLink(
    String text,
    VoidCallback onTap,
    Size size, {
    Color? color,
    bool underlined = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color:
              color ??
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          decoration: underlined
              ? TextDecoration.underline
              : TextDecoration.none,
          fontSize: size.width < 360 ? 13 : size.width * 0.035,
          fontWeight: color != null ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void _confirmSkip(BuildContext context) {
    final bloc = context.read<QuestionnaireBloc>();

    BilanNoticeDialog.showSkip(
      context: context,
      onSkip: () => bloc.add(TerminerQuestionnaireEvent()),
    );
  }
}
