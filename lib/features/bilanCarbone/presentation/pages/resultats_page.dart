import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/widgets/loader.dart';
import 'dart:ui';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/presentation/widgets/gradient_button.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_bloc.dart';

class ResultsPage extends StatelessWidget {
  final double score; // Score en kg CO2
  final Map<String, double> scoresParCategorie;
  final List<dynamic>? equivalents; // Liste d'entités (label, valeur, icone, unite)
  final VoidCallback onContinue;

  static Route route(BilanBloc bloc) {
  // On récupère l'état actuel 
  final state = bloc.state as BilanResultats;

  return MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: ResultsPage(
        score: state.scoreTotal,
        scoresParCategorie: state.scoresParCategorie,
        equivalents: state.equivalents,
        onContinue: () => {},
      ),
    ),
  );
}

  const ResultsPage({
    super.key,
    required this.score,
    required this.scoresParCategorie,
    required this.onContinue,
    this.equivalents,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final horizontalPadding = size.width * 0.05;
    final verticalSpacing = size.height * 0.02;
    
    // Score affiché tel quel (en kg)
    final int displayScore = score.round();
    const int parisTarget = 2000;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundDecorations(context),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  SizedBox(height: verticalSpacing),
                  Center(
                    child: Image.asset('assets/logos/oikos_logo.png', 
                      height: isSmallScreen ? size.height * 0.06 : size.height * 0.08),
                  ),
                  SizedBox(height: verticalSpacing * 1.5),
                  _buildHeaderTitle(context),
                  SizedBox(height: verticalSpacing * 1.5),

                  // Hero Score
                  _buildHeroScore(displayScore, parisTarget, context),
                  SizedBox(height: verticalSpacing),

                  // Graphique dynamique
                  _buildCategoryChart(context),
                  SizedBox(height: verticalSpacing * 1.5),

                  Text(
                    "$displayScore kg de CO₂ par an",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : size.width * 0.055,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    "C'est l'équivalent de :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isSmallScreen ? 14 : size.width * 0.04,
                    ),
                  ),
                  SizedBox(height: verticalSpacing),

                  // Grid des équivalents adaptée au score
                  _buildEquivalentsGrid(context),

                  SizedBox(height: verticalSpacing * 2),
                  _buildFooter(context), // Accède bien à onContinue ici
                  SizedBox(height: verticalSpacing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIQUE DES ÉQUIVALENTS ---
  Widget _buildEquivalentsGrid(BuildContext context) {
    if (equivalents == null || equivalents!.isEmpty) {
      return const Loader();
    }

    final size = MediaQuery.of(context).size;
    final spacing = size.width * 0.04;
    final double scoreInTonnes = score / 1000.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: size.width < 360 ? 0.85 : 0.9,
      ),
      itemCount: equivalents!.length > 4 ? 4 : equivalents!.length,
      itemBuilder: (context, index) {
        // On caste l'item pour avoir l'autocomplétion
        final item = equivalents![index] as CarboneEquivalentEntity;
        
        final double finalValue = scoreInTonnes * item.valeur1Tonne;

        return _buildEquivalentCard(
          context: context,
          icon: _getIconData(item.equivalentLabel.toLowerCase()), 
          label: item.equivalentLabel,
          value: finalValue > 10 ? finalValue.round().toString() : finalValue.toStringAsFixed(1),
          unit: "",
          gradient: index % 2 == 0 
              ? [const Color(0xFF65BA74), const Color(0xFF8DB654)]
              : [const Color(0xFFBDEE63), const Color(0xFF8DB654)],
          textColor: index % 2 == 0 ? Colors.white : AppColors.lightTextPrimary,
        );
      },
    );
  }

  // --- GRAPHIQUE DYNAMIQUE ---
  Widget _buildCategoryChart(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final chartRadius = size.width * 0.13;
    final centerRadius = size.width * 0.07;
    
    final List<PieChartSectionData> sections = [];
    final List<Widget> legendItems = [];
    
    final colors = [
      const Color(0xFFE8914A), 
      const Color(0xFF65BA74), 
      const Color(0xFFBDEE63), 
      const Color(0xFF8DB654),
      const Color(0xFF4A9960),
    ];

    int i = 0;
    // Calcul du total pour les pourcentages
    double total = scoresParCategorie.values.fold(0, (sum, item) => sum + item);

    scoresParCategorie.forEach((key, value) {
      if (value > 0) {
        final color = colors[i % colors.length];
        final double percentage = (value / total) * 100;

        // 1. Ajouter la section du graphique
        sections.add(PieChartSectionData(
          color: color,
          value: value,
          title: '${percentage.toStringAsFixed(0)}%', // Affiche le % sur le graph
          radius: chartRadius,
          titleStyle: TextStyle(
            fontSize: isSmallScreen ? 10 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));

        // 2. Ajouter l'élément de légende
        legendItems.add(_buildLegendItem(color, key, value));
        i++;
      }
    });

    return Container(
      // Augmentation de la hauteur pour accueillir la légende
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.06),
        border: Border.all(color: const Color(0xFFBDEE63).withOpacity(0.2), width: 4),
      ),
      child: Column(
        children: [
          Text(
            "Répartition par catégorie", 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 14 : size.width * 0.04,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            children: [
              // Graphique à gauche
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: size.width * 0.4,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: centerRadius,
                      sections: sections.isNotEmpty 
                          ? sections 
                          : [PieChartSectionData(color: Colors.grey.shade200, value: 1)],
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.04),
              // Légende à droite
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: legendItems,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              // On met la première lettre en majuscule pour le label
              "${label[0].toUpperCase()}${label.substring(1)}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "${value.round()}kg",
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTION INTERNES ---

  Widget _buildHeroScore(int score, int target, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final padding = size.width * 0.075;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.07),
        border: Border.all(color: AppColors.gradientGreenEnd.withOpacity(0.1), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "Ton empreinte annuelle", 
            style: TextStyle(
              color: Colors.grey,
              fontSize: isSmallScreen ? 14 : size.width * 0.04,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            "$score",
            style: TextStyle(
              fontSize: isSmallScreen ? 44 : size.width * 0.14, 
              fontWeight: FontWeight.bold, 
              color: AppColors.lightTextPrimary,
            ),
          ),
          Text(
            "kg CO₂e par an", 
            style: TextStyle(
              color: Colors.grey,
              fontSize: isSmallScreen ? 14 : size.width * 0.04,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          SizedBox(height: size.height * 0.02),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04, 
              vertical: size.height * 0.012,
            ),
            decoration: BoxDecoration(
              color: AppColors.gradientGreenEnd.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.target, size: 20, color: AppColors.gradientGreenEnd),
                const SizedBox(width: 10),
                Text("Objectif 2050 : $target kg/an"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.05),
          decoration: BoxDecoration(
            color: AppColors.gradientGreenEnd.withOpacity(0.1),
            borderRadius: BorderRadius.circular(size.width * 0.05),
            border: Border.all(color: AppColors.gradientGreenEnd.withOpacity(0.2)),
          ),
          child: Text(
            "Prêt à faire la différence ?\nDécouvre des actions simples pour réduire ton impact",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: isSmallScreen ? 13 : size.width * 0.037),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        GradientButton(
          label: "Continuer",
          onPressed: onContinue, // Utilisation correcte de la variable de classe
        ),
      ],
    );
  }

  // --- HELPERS ---

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'plane': return LucideIcons.plane;
      case 'car': return LucideIcons.car;
      case 'tree': return LucideIcons.treePine;
      case 'beef': return LucideIcons.beef;
      default: return LucideIcons.info;
    }
  }

  Widget _buildBackgroundDecorations(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = size.width * 0.4;
    
    return Stack(
      children: [
        Positioned(
          top: -size.height * 0.05,
          right: -size.width * 0.1,
          child: _blurCircle(circleSize, AppColors.gradientGreenEnd.withOpacity(0.2)),
        ),
        Positioned(
          top: size.height * 0.04,
          left: -size.width * 0.15,
          child: _blurCircle(circleSize * 1.1, Colors.green.withOpacity(0.1)),
        ),
      ],
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    
    return Column(
      children: [
        Text(
          "Mon bilan carbone",
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : size.width * 0.07, 
            fontWeight: FontWeight.bold, 
            color: AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Container(
          height: 4,
          width: size.width * 0.4,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.transparent,
              AppColors.gradientGreenEnd.withOpacity(0.4),
              Colors.transparent,
            ]),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildEquivalentCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required List<Color> gradient,
    required Color textColor,
  }) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(size.width * 0.05),
        boxShadow: [BoxShadow(color: gradient.first.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: isSmallScreen ? 24 : size.width * 0.07),
          SizedBox(height: size.height * 0.008),
          Text(
            label, 
            style: TextStyle(
              color: textColor.withOpacity(0.8), 
              fontSize: isSmallScreen ? 10 : size.width * 0.028,
            ), 
            textAlign: TextAlign.center,
          ),
          Text(
            value, 
            style: TextStyle(
              color: textColor, 
              fontSize: isSmallScreen ? 20 : size.width * 0.06, 
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit, 
            style: TextStyle(
              color: textColor.withOpacity(0.8), 
              fontSize: isSmallScreen ? 10 : size.width * 0.028,
            ),
          ),
        ],
      ),
    );
  }
}