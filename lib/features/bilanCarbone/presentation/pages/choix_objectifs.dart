import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/objectif_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_cubit.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/resultats_page.dart';

class PersonalGoalPage extends StatefulWidget {
  const PersonalGoalPage({
    super.key,
  });

  @override
  State<PersonalGoalPage> createState() => _PersonalGoalPageState();
}

class _PersonalGoalPageState extends State<PersonalGoalPage> {
  double? _selectedRatio;
  bool _isCustomMode = false;
  final TextEditingController _customController = TextEditingController();

  void _handlePresetSelect(double ratio) {
    setState(() {
      _selectedRatio = ratio;
      _isCustomMode = false;
      _customController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result)  {
        if (didPop) {
          context.read<BilanCubit>().retourVersChoixCategoriesFromObjectifs();
        }
      },
      child: BlocConsumer<BilanCubit, BilanState>(
        listener: (context, state) {
          if (state is BilanResultats) {
            
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<BilanCubit>(),
                  child: ResultsPage( 
                    score: state.scoreTotal,
                    scoresParCategorie: state.scoresParCategorie,
                    equivalents: state.equivalents,
                    onContinue: () {
                      //TO DO
                    },
                  ),
                ),
              ),
              (route) => false,
            );
      
          } else if (state is BilanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.lightDestructive),
            );
          }
        },
        builder: (context, state) {
          final double score = state is BilanChoixObjectifs ? state.scoreActuel/1000 : 0.0;
          final objectifs = state is BilanChoixObjectifs ? state.objectifs : [];
          
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset('assets/logos/oikos_logo.png', height: 50),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Fixe-toi un objectif personnel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.lightTextPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "En plus de l'objectif des Accords de Paris (2 tonnes CO₂/an), choisis ton propre défi !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.lightTextPrimary.withOpacity(0.7), 
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 30),
      
                    _buildCurrentEmpreinteBox(score),
                    const SizedBox(height: 24),
      
                    ...objectifs.map((obj) => _buildGoalCard(obj, score)).toList(),
      
                    _buildCustomGoalCard(score),
      
                    const SizedBox(height: 24),
                    _buildHintBox(),
                    const SizedBox(height: 30),
      
                    GradientButton(
                      label: state is BilanLoading ? "Sauvegarde..." : "Valider mon objectif",
                      disabled: _selectedRatio == null || state is BilanLoading,
                      onPressed: () {
                        if (_selectedRatio != null) {
                          context.read<BilanCubit>().validerObjectif(_selectedRatio!);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentEmpreinteBox(double score) {
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradientGreenStart.withOpacity(0.2),
            AppColors.gradientGreenEnd.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gradientGreenEnd.withOpacity(0.3), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.eco, color: AppColors.lightIconPrimary),
          const SizedBox(width: 12),
          Text(
            "Ton empreinte : ${score.toStringAsFixed(1)} tonnes CO₂/an",
            style: const TextStyle(
              color: AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard( ObjectifEntity objectif, double score) {
    final bool isSelected = !_isCustomMode && _selectedRatio == objectif.valeur;
    final double targetValue = score * objectif.valeur;

    return GestureDetector(
      onTap: () => _handlePresetSelect(objectif.valeur),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.gradientGreenEnd : AppColors.lightBorder,
            width: 2,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.gradientGreenStart.withOpacity(0.1),
                    AppColors.gradientGreenEnd.withOpacity(0.1),
                  ],
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.08 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildIconCircle(Icons.bolt, objectif.gradientColors, isSelected),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    objectif.label, 
                    style: const TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  Text(
                    objectif.description, 
                    style: TextStyle(color: AppColors.lightTextPrimary.withOpacity(0.6))
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${targetValue.toStringAsFixed(1)} tonnes CO₂/an",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomGoalCard(double score) {
    return GestureDetector(
      onTap: () => setState(() {
        _isCustomMode = true;
        _selectedRatio = null;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isCustomMode ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isCustomMode ? AppColors.gradientGreenEnd : AppColors.lightBorder,
            width: 2,
          ),
          gradient: _isCustomMode
              ? LinearGradient(
                  colors: [
                    AppColors.gradientGreenStart.withOpacity(0.1),
                    AppColors.gradientGreenEnd.withOpacity(0.1),
                  ],
                )
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                _buildIconCircle(Icons.edit, [AppColors.lightMutedForeground, AppColors.lightForeground], _isCustomMode),
                const SizedBox(width: 16),
                const Text(
                  "Personnalisé", 
                  style: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ],
            ),
            if (_isCustomMode) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _customController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                cursorColor: AppColors.lightIconPrimary,
                decoration: InputDecoration(
                  hintText: "Ex: 5.5",
                  suffixText: "tonnes CO₂/an",
                  fillColor: AppColors.lightInput,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.lightInputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.lightInputBorderFocused),
                  ),
                ),
                onChanged: (val) {
                  final double? input = double.tryParse(val);
                  if (input != null && input > 0) {
                    setState(() => _selectedRatio = input / score);
                  } else {
                    setState(() => _selectedRatio = null);
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconCircle(IconData icon, List<Color> colors, bool isSelected) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected ? LinearGradient(colors: colors) : null,
        color: isSelected ? null : AppColors.lightSecondary,
      ),
      child: Icon(
        icon, 
        color: isSelected ? AppColors.lightPrimaryForeground : AppColors.lightMutedForeground, 
        size: 24
      ),
    );
  }

  Widget _buildHintBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Text(
        "💡 Tu pourras modifier ton objectif à tout moment dans ton profil.",
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.lightTextPrimary.withOpacity(0.6), fontSize: 13),
      ),
    );
  }
}