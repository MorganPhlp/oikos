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
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BilanBloc, BilanState>(
      builder: (context, state) {
        if (state is! BilanResultats) {
          return const Scaffold(body: Center(child: Loader()));
        }

        // --- DONNÉES ---
        final double score = state.scoreTotal;
        final Map<String, double> scoresParCategorie = state.scoresParCategorie;
        final List<dynamic>? equivalents = state.equivalents;

        // --- LOGIQUE DE NAVIGATION ---
        void onContinue() {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }

        // --- DESIGN VARIABLES ---
        final size = MediaQuery.of(context).size;
        final isSmallScreen = size.width < 360;
        final int displayScore = score.round();
        const int parisTarget = 2000;

        return Scaffold(
          body: Stack(
            children: [
              _buildBackgroundDecorations(context),
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Center(
                        child: Image.asset(
                          'assets/logos/oikos_logo.png',
                          height: isSmallScreen ? size.height * 0.06 : size.height * 0.08,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      _buildHeaderTitle(context),
                      SizedBox(height: size.height * 0.03),

                      // Hero Score
                      _buildHeroScore(displayScore, parisTarget, context),
                      SizedBox(height: size.height * 0.02),

                      // Graphique avec Légende
                      _buildCategoryChart(context, scoresParCategorie),
                      SizedBox(height: size.height * 0.03),

                      Text(
                        "$displayScore kg de CO₂ par an",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : size.width * 0.055,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const Text(
                        "C'est l'équivalent de :",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Grille des équivalents
                      _buildEquivalentsGrid(context, equivalents, score),

                      SizedBox(height: size.height * 0.04),
                      _buildFooter(context, onContinue),
                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- COMPOSANTS DE STYLE ---

  Widget _buildBackgroundDecorations(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: -size.height * 0.05,
          right: -size.width * 0.1,
          child: _blurCircle(size.width * 0.4, AppColors.gradientGreenEnd.withOpacity(0.15)),
        ),
        Positioned(
          top: size.height * 0.1,
          left: -size.width * 0.15,
          child: _blurCircle(size.width * 0.5, Colors.green.withOpacity(0.1)),
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
    return Column(
      children: [
        Text(
          "Mon bilan carbone",
          style: TextStyle(
            fontSize: size.width * 0.07,
            fontWeight: FontWeight.bold,
            color: AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 3,
          width: 60,
          decoration: BoxDecoration(
            color: AppColors.gradientGreenEnd,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroScore(int score, int target, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.07),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.gradientGreenEnd.withOpacity(0.1), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          const Text("Ton empreinte annuelle", style: TextStyle(color: Colors.grey)),
          Text(
            "$score",
            style: TextStyle(
              fontSize: size.width * 0.14,
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const Text("kg CO₂e / an", style: TextStyle(color: Colors.grey)),
          SizedBox(height: size.height * 0.02),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.gradientGreenEnd.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.target, size: 18, color: AppColors.gradientGreenEnd),
                const SizedBox(width: 8),
                Text(
                  "Objectif 2050 : $target kg/an",
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.gradientGreenEnd),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryChart(BuildContext context, Map<String, double> scores) {
    final size = MediaQuery.of(context).size;
    final colors = [
      const Color(0xFFE8914A),
      const Color(0xFF65BA74),
      const Color(0xFFBDEE63),
      const Color(0xFF8DB654),
      const Color(0xFF4A9960),
    ];

    List<PieChartSectionData> sections = [];
    List<Widget> legendItems = [];
    double total = scores.values.fold(0, (sum, item) => sum + item);

    int i = 0;
    scores.forEach((key, value) {
      if (value > 0) {
        final color = colors[i % colors.length];
        sections.add(PieChartSectionData(
          color: color,
          value: value,
          radius: 35,
          title: '',
        ));
        legendItems.add(_buildLegendItem(color, key, value));
        i++;
      }
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 120,
              child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 25)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: legendItems,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text("${value.round()}kg", style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEquivalentsGrid(BuildContext context, List<dynamic>? equivalents, double score) {
    if (equivalents == null || equivalents.isEmpty) return const SizedBox();
    final size = MediaQuery.of(context).size;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: size.width < 360 ? 0.85 : 1.1,
      ),
      itemCount: equivalents.length > 4 ? 4 : equivalents.length,
      itemBuilder: (context, index) {
        final item = equivalents[index] as CarboneEquivalentEntity;
        final double finalValue = (score / 1000.0) * item.valeur1Tonne;

        return _buildEquivalentCard(
          icon: _getIconData(item.equivalentLabel.toLowerCase()),
          label: item.equivalentLabel,
          value: finalValue > 10 ? finalValue.round().toString() : finalValue.toStringAsFixed(1),
          gradient: index % 2 == 0
              ? [const Color(0xFF65BA74), const Color(0xFF8DB654)]
              : null, // Pas de gradient pour les impairs (fond blanc)
          textColor: index % 2 == 0 ? Colors.white : AppColors.lightTextPrimary,
        );
      },
    );
  }

  Widget _buildEquivalentCard({
    required IconData icon,
    required String label,
    required String value,
    List<Color>? gradient,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gradient == null ? Colors.white : null,
        gradient: gradient != null ? LinearGradient(colors: gradient) : null,
        borderRadius: BorderRadius.circular(20),
        border: gradient == null ? Border.all(color: AppColors.lightBorder) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 11),
          ),
          Text(
            value,
            style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, VoidCallback onContinue) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.gradientGreenEnd.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.gradientGreenEnd.withOpacity(0.1)),
          ),
          child: const Text(
            "Prêt à faire la différence ?\nDécouvre des actions simples pour réduire ton impact",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
        const SizedBox(height: 25),
        GradientButton(label: "Continuer", onPressed: onContinue),
      ],
    );
  }

  IconData _getIconData(String label) {
    if (label.contains('avion')) return LucideIcons.plane;
    if (label.contains('voiture')) return LucideIcons.car;
    if (label.contains('arbre')) return LucideIcons.treePine;
    if (label.contains('steak') || label.contains('beef')) return LucideIcons.beef;
    return LucideIcons.info;
  }
}