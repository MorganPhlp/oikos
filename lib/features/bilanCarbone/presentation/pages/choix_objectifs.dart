import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/widgets/loader.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/objectif_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_event.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_state.dart';

class PersonalGoalPage extends StatefulWidget {
  const PersonalGoalPage({super.key});

  @override
  State<PersonalGoalPage> createState() => _PersonalGoalPageState();
}

class _PersonalGoalPageState extends State<PersonalGoalPage> {
  ObjectifEntity? _selectedGoal;
  bool _isCustomMode = false;
  final TextEditingController _customController = TextEditingController();

  // Variables persistantes pour éviter le flash à "0"
  double _persistedScore = 0.0;
  List<ObjectifEntity> _persistedObjectifs = [];

  final List<IconData> goalIcons = [
    Icons.eco,
    Icons.directions_bike,
    Icons.rocket_launch,
  ];

  void _handlePresetSelect(ObjectifEntity goal) {
    setState(() {
      _selectedGoal = goal;
      _isCustomMode = false;
      _customController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<BilanResultatBloc>().add(RetourAuChoixCategoriesEvent());
        }
      },
      child: BlocConsumer<BilanResultatBloc, ResultatState>(
        listener: (context, state) {
          if (state is ResultatFinal) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('resultats', (route) => false);
          } else if (state is ResultatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.lightDestructive,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ResultatChoixObjectifs) {
            _persistedScore = state.scoreActuel / 1000;
            _persistedObjectifs = state.objectifs;
          }

          final size = MediaQuery.of(context).size;
          final isSmallScreen = size.width < 360;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Center(
                          child: Image.asset(
                            'assets/logos/oikos_logo.png',
                            height: isSmallScreen ? 45 : 55,
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        const Text(
                          "Fixe-toi un objectif personnel",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),

                        // Utilisation du score persisté
                        _buildCurrentEmpreinteBox(_persistedScore, context),
                        SizedBox(height: size.height * 0.024),

                        // Utilisation des objectifs persistés
                        ..._persistedObjectifs.asMap().entries.map((entry) {
                          return _buildGoalCard(
                            entry.value,
                            _persistedScore,
                            context,
                            goalIcons[entry.key % goalIcons.length],
                          );
                        }),

                        _buildCustomGoalCard(_persistedScore, context),

                        SizedBox(height: size.height * 0.024),
                        _buildHintBox(context),
                        SizedBox(height: size.height * 0.03),

                        GradientButton(
                          label: state is ResultatLoading
                              ? "Sauvegarde..."
                              : "Valider mon objectif",
                          disabled:
                              _selectedGoal == null || state is ResultatLoading,
                          onPressed: () {
                            if (_selectedGoal != null) {
                              context.read<BilanResultatBloc>().add(
                                ValiderObjectifEvent(_selectedGoal!),
                              );
                            }
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                ),

                // Overlay de chargement (Z-index supérieur)
                if (state is ResultatLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Loader(),
                          SizedBox(height: 20),
                          Text(
                            "Sauvegarde en cours...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Les méthodes privées (_build...) utilisent maintenant le score passé en paramètre
  Widget _buildCurrentEmpreinteBox(double score, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gradientGreenEnd.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gradientGreenEnd.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.eco, color: AppColors.lightIconPrimary, size: 22),
          const SizedBox(width: 10),
          Text(
            "Ton empreinte : ${score.toStringAsFixed(1)} tonnes CO₂/an",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(
    ObjectifEntity objectif,
    double score,
    BuildContext context,
    IconData icon,
  ) {
    final bool isSelected =
        !_isCustomMode && _selectedGoal?.valeur == objectif.valeur;
    final double targetValue = score * (objectif.valeur);

    return GestureDetector(
      onTap: () => _handlePresetSelect(objectif),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.transparent
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.gradientGreenEnd
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.gradientGreenStart.withValues(alpha: 0.1),
                    AppColors.gradientGreenEnd.withValues(alpha: 0.1),
                  ],
                )
              : null,
        ),
        child: Row(
          children: [
            _buildIconCircle(
              icon,
              objectif.colors.map((c) => Color(c)).toList(),
              isSelected,
              context,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    objectif.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    objectif.description,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${targetValue.toStringAsFixed(1)} tonnes CO₂/an",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomGoalCard(double score, BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _isCustomMode = true;
        _selectedGoal = null;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isCustomMode
              ? Colors.transparent
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isCustomMode
                ? AppColors.gradientGreenEnd
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
          gradient: _isCustomMode
              ? LinearGradient(
                  colors: [
                    AppColors.gradientGreenStart.withValues(alpha: 0.1),
                    AppColors.gradientGreenEnd.withValues(alpha: 0.1),
                  ],
                )
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                _buildIconCircle(
                  Icons.edit,
                  [Colors.grey, Colors.blueGrey],
                  _isCustomMode,
                  context,
                ),
                const SizedBox(width: 15),
                const Text(
                  "Personnalisé",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            if (_isCustomMode) ...[
              const SizedBox(height: 15),
              TextField(
                controller: _customController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: "Ex: 5.5",
                  suffixText: "tonnes CO₂/an",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (val) {
                  final double? input = double.tryParse(
                    val.replaceAll(',', '.'),
                  );
                  if (input != null && input > 0) {
                    setState(() {
                      _selectedGoal = ObjectifEntity(
                        label: "Objectif personnalisé",
                        description: "Défini manuellement",
                        valeur: input / (score > 0 ? score : 1),
                        colors: const [0xFF9E9E9E, 0xFF607D8B],
                      );
                    });
                  } else {
                    setState(() => _selectedGoal = null);
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconCircle(
    IconData icon,
    List<Color> colors,
    bool isSelected,
    BuildContext context,
  ) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected ? LinearGradient(colors: colors) : null,
        color: isSelected ? null : Theme.of(context).colorScheme.surface,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey,
        size: 24,
      ),
    );
  }

  Widget _buildHintBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: const Text(
        "💡 Tu pourras modifier ton objectif à tout moment dans ton profil.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }
}
