import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/presentation/widgets/gradient_button.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_cubit.dart';

class ResultsPage extends StatelessWidget {
  final double score; // Score en kg CO2
  final Map<String, double> scoresParCategorie;
  final List<dynamic>? equivalents; // Liste d'entités (label, valeur, icone, unite)
  final VoidCallback onContinue;

  static Route route(BilanCubit cubit) {
  // On récupère l'état actuel (forcément BilanResultats ici)
  final state = cubit.state as BilanResultats;

  return MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: ResultsPage(
        score: state.scoreTotal,
        scoresParCategorie: state.scoresParCategorie,
        equivalents: state.equivalents,
        onContinue: () => /* Ton action ici */ {},
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
    // Score affiché tel quel (en kg)
    final int displayScore = score.round();
    const int parisTarget = 2000;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundDecorations(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset('assets/logos/oikos_logo.png', height: 60),
                  ),
                  const SizedBox(height: 30),
                  _buildHeaderTitle(),
                  const SizedBox(height: 30),

                  // Hero Score
                  _buildHeroScore(displayScore, parisTarget),
                  const SizedBox(height: 24),

                  // Graphique dynamique
                  _buildCategoryChart(),
                  const SizedBox(height: 30),

                  Text(
                    "$displayScore kg de CO₂ par an",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  const Text(
                    "C'est l'équivalent de :",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Grid des équivalents adaptée au score
                  _buildEquivalentsGrid(),

                  const SizedBox(height: 40),
                  _buildFooter(), // Accède bien à onContinue ici
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIQUE DES ÉQUIVALENTS ---
  Widget _buildEquivalentsGrid() {
    if (equivalents == null || equivalents!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final double scoreInTonnes = score / 1000.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.9,
      ),
      itemCount: equivalents!.length > 4 ? 4 : equivalents!.length,
      itemBuilder: (context, index) {
        // On caste l'item pour avoir l'autocomplétion
        final item = equivalents![index] as CarboneEquivalentEntity;
        
        final double finalValue = scoreInTonnes * item.valeur1Tonne;

        return _buildEquivalentCard(
          // Attention : 'icone' et 'unite' manquent dans ton entité actuelle
          icon: _getIconData(item.equivalentLabel.toLowerCase()), 
          label: item.equivalentLabel,
          value: finalValue > 10 ? finalValue.round().toString() : finalValue.toStringAsFixed(1),
          unit: "unités", // Valeur par défaut en attendant l'update de l'entité
          gradient: index % 2 == 0 
              ? [const Color(0xFF65BA74), const Color(0xFF8DB654)]
              : [const Color(0xFFBDEE63), const Color(0xFF8DB654)],
          textColor: index % 2 == 0 ? Colors.white : AppColors.lightTextPrimary,
        );
      },
    );
  }

  // --- GRAPHIQUE DYNAMIQUE ---
  Widget _buildCategoryChart() {
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
          radius: 55,
          titleStyle: const TextStyle(
            fontSize: 12,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBDEE63).withOpacity(0.2), width: 4),
      ),
      child: Column(
        children: [
          const Text("Répartition par catégorie", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              // Graphique à gauche
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 160,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 30,
                      sections: sections.isNotEmpty 
                          ? sections 
                          : [PieChartSectionData(color: Colors.grey.shade200, value: 1)],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
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

  Widget _buildHeroScore(int score, int target) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gradientGreenEnd.withOpacity(0.1), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Column(
        children: [
          const Text("Ton empreinte annuelle", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(
            "$score",
            style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary),
          ),
          const Text("kg CO₂e par an", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.gradientGreenEnd.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.gradientGreenEnd.withOpacity(0.2)),
          ),
          child: const Text(
            "Prêt à faire la différence ?\nDécouvre des actions simples pour réduire ton impact",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 20),
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

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -40,
          child: _blurCircle(180, AppColors.gradientGreenEnd.withOpacity(0.2)),
        ),
        Positioned(
          top: 40,
          left: -60,
          child: _blurCircle(200, Colors.green.withOpacity(0.1)),
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

  Widget _buildHeaderTitle() {
    return Column(
      children: [
        const Text(
          "Mon bilan carbone",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 150,
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
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required List<Color> gradient,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: gradient.first.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 28),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 11), textAlign: TextAlign.center),
          Text(value, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(unit, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 11)),
        ],
      ),
    );
  }
}