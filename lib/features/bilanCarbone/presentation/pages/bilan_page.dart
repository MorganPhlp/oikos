import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Adapte les imports selon ton arborescence exacte
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/type_widget.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_cubit.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/next_button.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/question_widget_factory.dart';
import 'package:oikos/injection_container.dart';

class BilanPage extends StatefulWidget {
  const BilanPage({super.key});

  @override
  State<BilanPage> createState() => _BilanPageState();
}

class _BilanPageState extends State<BilanPage> {
  // STATE LOCAL : Stocke la réponse en cours AVANT validation
  dynamic _currentAnswer;
  
  // 💡 VARIABLE D'ÉTAT POUR CONTRÔLER LA VALIDITÉ DU FORMULAIRE
  bool _isAnswerValid = false;
  

  @override
  Widget build(BuildContext context) {
    // 1. Injection du Cubit
    return BlocProvider(
      create: (context) => sl<BilanCubit>()..demarrerBilan(),
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: SafeArea(
          // 2. BlocConsumer : Écoute ET Construit
          child: BlocConsumer<BilanCubit, BilanState>(
            listener: (context, state) {
              // RESET AUTOMATIQUE entre chaque question
              if (state is BilanQuestionDisplayed) {
                _initialiserValeurParDefaut(state);
              }
            },
            builder: (context, state) {
              // ... (Cas BilanLoading, BilanError, BilanTermine inchangés) ...

              // --- CAS 4 : QUESTION AFFICHÉE ---
              if (state is BilanQuestionDisplayed) {
                final double progress = state.index / state.totalQuestions;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    children: [
                      // --- HEADER : Logo & Progress ---
                      _buildHeader(progress, state),

                      const SizedBox(height: 30),

                      // --- CONTENU SCROLLABLE ---
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Icône de la question
                              Text(
                                state.question.icone ?? '🌱',
                                style: const TextStyle(fontSize: 50),
                              ),
                              const SizedBox(height: 15),

                              // Titre de la question
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

                              // 👉 FACTORY : Affiche Slider, Boutons ou Compteurs
                              QuestionWidgetFactory(
                                question: state.question,
                                currentValue: _currentAnswer,
                                onLocalChange: (newValue) {
                                  setState(() {
                                    _currentAnswer = newValue;
                                  });
                                },
                                // 💡 AJOUT DU CALLBACK DE VALIDITÉ
                                onValidityChange: (isValid) {
                                  setState(() {
                                    _isAnswerValid = isValid; // Met à jour l'état du BilanPage
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // --- FOOTER : Actions ---
                      const SizedBox(height: 20),
                      _buildFooterActions(context, state),
                    ],
                  ),
                );
              }

              return const SizedBox(); // Fallback
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MÉTHODES UI DÉCOUPÉES
  // ---------------------------------------------------------------------------

  /// Initialise la valeur locale selon le type de widget pour éviter les null errors
void _initialiserValeurParDefaut(BilanQuestionDisplayed state) {
  setState(() {
    switch (state.question.typeWidget) {
      case TypeWidget.slider:
        _currentAnswer = state.question.min ?? 0.0;
        _isAnswerValid = true; 
        break;
      case TypeWidget.compteur:
        _currentAnswer = <String, int>{};
        _isAnswerValid = true;
        break;
      case TypeWidget.nombre:
        _currentAnswer = 0.0;
        _isAnswerValid = false; 
        break;
      default:
        _currentAnswer = null;
        _isAnswerValid = false;
    }
  });

  if (state.question.typeWidget == TypeWidget.nombre && _currentAnswer is num) {
    // Validation gérée par le QuestionNumberWrapper
  }
}

  /// Construit l'en-tête (Barre de progression + Compteur)
  Widget _buildHeader(double progress, BilanQuestionDisplayed state) {
    return Column(
      children: [
        // Titre App
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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

        // Barre de progression Custom
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.gradientGreenEnd.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 8,
              
              // 👇 AJOUTE LES PARENTHÈSES ICI 👇
              width: (MediaQuery.of(context).size.width - 40) * progress,
              
              decoration: BoxDecoration(
                color: AppColors.gradientGreenEnd,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Texte "Question 1 sur 20"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Question ${state.index} sur ${state.totalQuestions}",
              style: TextStyle(
                color: AppColors.lightTextPrimary.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            // Optionnel : Afficher le score en temps réel ici si le Cubit le fournit
          ],
        ),
      ],
    );
  }

  /// Construit les boutons du bas (Suivant, Je ne sais pas...)
  Widget _buildFooterActions(BuildContext context, BilanQuestionDisplayed state) {
    // Vérifie si on peut passer à la suite (Bouton activé ?)
    bool canProceed = false;

    if (state.question.typeWidget == TypeWidget.nombre) {
      // 💡 NOUVEAU: Utilise l'état remonté par le QuestionNumberWrapper
      canProceed = _isAnswerValid; 
    } else if (state.question.typeWidget == TypeWidget.slider) {
      canProceed = true; // Un slider a toujours une valeur par défaut
    } else if (state.question.typeWidget == TypeWidget.compteur) {
      canProceed = true; // On autorise 0
    } else {
      // Pour choix unique, il faut avoir cliqué
      canProceed = _currentAnswer != null;
    }

    return Column(
      children: [
        Row(
          children: [
            // Bouton Retour
            InkWell(
              onTap: () {
                // TODO: Implémenter la méthode 'reculer()' dans le Cubit si nécessaire
                // Pour l'instant on peut afficher un message ou ne rien faire
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Retour en arrière bientôt disponible !")),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gradientGreenEnd, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.chevron_left, color: AppColors.gradientGreenEnd),
              ),
            ),
            const SizedBox(width: 12),

            // Bouton Suivant (OikosButton)
            Expanded(
              child: OikosNextButton(
                label: state.index == state.totalQuestions ? "Terminer" : "Suivant",
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                disabled: !canProceed,
                onPressed: () {
                  // C'est ICI qu'on valide et qu'on appelle le moteur
                  context.read<BilanCubit>().repondre(_currentAnswer);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Liens Textuels
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextLink("Je ne sais pas", () {
              context.read<BilanCubit>().repondre("je ne sais pas");
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("•", style: TextStyle(color: AppColors.lightTextPrimary.withOpacity(0.3))),
            ),
            _buildTextLink("Ça ne m'intéresse pas", () {
              // On peut imaginer une logique spécifique pour sauter la question
              context.read<BilanCubit>().repondre("non applicable"); 
            }),
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
          decorationStyle: TextDecorationStyle.dotted,
        ),
      ),
    );
  }
}
