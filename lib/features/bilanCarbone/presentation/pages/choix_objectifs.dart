import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/objectif_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/resultats_page.dart';

class PersonalGoalPage extends StatefulWidget {
  const PersonalGoalPage({
    super.key,
  });

  static MaterialPageRoute route(BilanBloc existingBloc) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: existingBloc,
        child: const PersonalGoalPage(),
      ),
    );
  }

  @override
  State<PersonalGoalPage> createState() => _PersonalGoalPageState();
}

class _PersonalGoalPageState extends State<PersonalGoalPage> {
  double? _selectedRatio;
  bool _isCustomMode = false;
  final TextEditingController _customController = TextEditingController();
  //les icones pour les objectifs
  final List<IconData> goalIcons = [
    Icons.eco, // Objectif 1
    Icons.directions_bike,    // Objectif 2
    Icons.rocket_launch,      // Objectif 3
];

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
          context.read<BilanBloc>().add(RetourVersChoixCategoriesFromObjectifsEvent());
        }
      },
      child: BlocConsumer<BilanBloc, BilanState>(
        listener: (context, state) {
          if (state is BilanResultats) {
            Navigator.of(context).pushNamed('resultats');
      
          } else if (state is BilanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.lightDestructive),
            );
          }
        },
        builder: (context, state) {
          final double score = state is BilanChoixObjectifs ? state.scoreActuel/1000 : 0.0;
          final objectifs = state is BilanChoixObjectifs ? state.objectifs : [];
          final size = MediaQuery.of(context).size;
          final horizontalPadding = size.width * 0.05;
          final isSmallScreen = size.width < 360;
          
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/logos/oikos_logo.png', 
                        height: isSmallScreen ? size.height * 0.06 : size.height * 0.065,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      "Fixe-toi un objectif personnel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.lightTextPrimary,
                        fontSize: isSmallScreen ? 20 : size.width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    Text(
                      "En plus de l'objectif des Accords de Paris (2 tonnes CO₂/an), choisis ton propre défi !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.lightTextPrimary.withOpacity(0.7), 
                        fontSize: isSmallScreen ? 14 : size.width * 0.04,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
      
                    _buildCurrentEmpreinteBox(score, context),
                    SizedBox(height: size.height * 0.024),
      
                    ...objectifs.asMap().entries.map((entry) {
                      int idx = entry.key;
                      var obj = entry.value;
                      return _buildGoalCard(
                        obj, 
                        score, 
                        context, 
                        goalIcons[idx % goalIcons.length],
                      );
                    }).toList(),
      
                    _buildCustomGoalCard(score, context),
      
                    SizedBox(height: size.height * 0.024),
                    _buildHintBox(context),
                    SizedBox(height: size.height * 0.03),
      
                    GradientButton(
                      label: state is BilanLoading ? "Sauvegarde..." : "Valider mon objectif",
                      disabled: _selectedRatio == null || state is BilanLoading,
                      onPressed: () {
                        if (_selectedRatio != null) {
                          context.read<BilanBloc>().add(ValiderObjectifEvent(_selectedRatio!));
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

  Widget _buildCurrentEmpreinteBox(double score, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final padding = size.width * 0.05;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradientGreenStart.withOpacity(0.2),
            AppColors.gradientGreenEnd.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(size.width * 0.05),
        border: Border.all(color: AppColors.gradientGreenEnd.withOpacity(0.3), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.eco, 
            color: AppColors.lightIconPrimary,
            size: isSmallScreen ? 20 : size.width * 0.055,
          ),
          SizedBox(width: size.width * 0.03),
          Text(
            "Ton empreinte : ${score.toStringAsFixed(1)} tonnes CO₂/an",
            style: TextStyle(
              color: AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 14 : size.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard( ObjectifEntity objectif, double score, BuildContext context, IconData icon) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final bool isSelected = !_isCustomMode && _selectedRatio == objectif.valeur;
    final double targetValue = score * objectif.valeur;

    return GestureDetector(
      onTap: () => _handlePresetSelect(objectif.valeur),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: size.height * 0.016),
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.05),
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
            _buildIconCircle(icon, objectif.gradientColors, isSelected, context),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    objectif.label, 
                    style: TextStyle(
                      color: AppColors.lightTextPrimary, 
                      fontWeight: FontWeight.bold, 
                      fontSize: isSmallScreen ? 15 : size.width * 0.04,
                    ),
                  ),
                  Text(
                    objectif.description, 
                    style: TextStyle(
                      color: AppColors.lightTextPrimary.withOpacity(0.6),
                      fontSize: isSmallScreen ? 13 : size.width * 0.035,
                    ),
                  ),
                  SizedBox(height: size.height * 0.005),
                  Text(
                    "${targetValue.toStringAsFixed(1)} tonnes CO₂/an",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: AppColors.lightTextPrimary,
                      fontSize: isSmallScreen ? 13 : size.width * 0.035,
                    ),
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    
    return GestureDetector(
      onTap: () => setState(() {
        _isCustomMode = true;
        _selectedRatio = null;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          color: _isCustomMode ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.05),
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
                _buildIconCircle(Icons.edit, [AppColors.lightMutedForeground, AppColors.lightForeground], _isCustomMode, context),
                SizedBox(width: size.width * 0.04),
                Text(
                  "Personnalisé", 
                  style: TextStyle(
                    color: AppColors.lightTextPrimary, 
                    fontWeight: FontWeight.bold, 
                    fontSize: isSmallScreen ? 15 : size.width * 0.04,
                  ),
                ),
              ],
            ),
            if (_isCustomMode) ...[
              SizedBox(height: size.height * 0.016),
              TextField(
                controller: _customController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                cursorColor: AppColors.lightIconPrimary,
                style: TextStyle(fontSize: isSmallScreen ? 14 : size.width * 0.04),
                decoration: InputDecoration(
                  hintText: "Ex: 5.5",
                  suffixText: "tonnes CO₂/an",
                  fillColor: AppColors.lightInput,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.03),
                    borderSide: const BorderSide(color: AppColors.lightInputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.03),
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

  Widget _buildIconCircle(IconData icon, List<Color> colors, bool isSelected, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = size.width * 0.125;
    final iconSize = size.width * 0.06;
    
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected ? LinearGradient(colors: colors) : null,
        color: isSelected ? null : AppColors.lightSecondary,
      ),
      child: Icon(
        icon, 
        color: isSelected ? AppColors.lightPrimaryForeground : AppColors.lightMutedForeground, 
        size: iconSize,
      ),
    );
  }

  Widget _buildHintBox(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.04),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Text(
        "💡 Tu pourras modifier ton objectif à tout moment dans ton profil.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.lightTextPrimary.withOpacity(0.6), 
          fontSize: isSmallScreen ? 12 : size.width * 0.033,
        ),
      ),
    );
  }
}