import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/widgets/loader.dart';
import 'dart:ui';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_state.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  /// Formate les kg en tonnes avec une virgule (ex: 8,4)
  String _formatKgToTonnes(double kgValue, {int decimals = 1}) {
    double tonnes = kgValue / 1000;
    return tonnes.toStringAsFixed(decimals).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return BlocBuilder<BilanResultatBloc, ResultatState>(
      builder: (context, state) {
        // État de chargement
        if (state is! ResultatFinal) {
          return const Scaffold(body: Center(child: Loader()));
        }

        // Récupération des données du Bloc
        final double scoreKg = state.scoreTotal;
        final Map<String, double> scoresParCategorie = state.scoresParCategorie.toMap();
        final List<dynamic> equivalents = state.equivalents is Map
            ? (state.equivalents as Map).values.toList()
            : (state.equivalents as List? ?? []);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              _buildBackgroundDecorations(context),
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      
                      // Logo Oikos
                      Center(
                        child: Image.asset(
                          'assets/logos/oikos_logo.png',
                          height: isSmallScreen ? size.height * 0.06 : size.height * 0.08,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      
                      _buildHeaderTitle(context),
                      SizedBox(height: size.height * 0.03),

                      // Score Principal
                      _buildHeroScore(scoreKg, context),
                      SizedBox(height: size.height * 0.04),

                      // Graphique en camembert
                      _buildCategoryChart(context, scoresParCategorie),
                      SizedBox(height: size.height * 0.03),

                      // Barres de répartition par catégorie
                      _buildCategoryBars(context, scoresParCategorie, scoreKg),
                      
                      SizedBox(height: size.height * 0.05),

                      // Section Equivalents
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "C'est l'équivalent de :",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      
                      _buildEquivalentsList(context, equivalents, scoreKg),

                      SizedBox(height: size.height * 0.04),
                      
                      // Bouton de sortie (utilise ton GradientButton thémé)
                      GradientButton(
                        label: "Retour à l'accueil", 
                        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                      ),
                      
                      SizedBox(height: size.height * 0.03),
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

  // --- 1. TITRE DE LA PAGE ---
  Widget _buildHeaderTitle(BuildContext context) {
    return Column(
      children: [
        Text(
          "Mon bilan carbone",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 3,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.gradientGreenEnd,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  // --- 2. SCORE PRINCIPAL (HERO) ---
  Widget _buildHeroScore(double scoreKg, BuildContext context) {
    final theme = Theme.of(context);
    final String scoreFormatted = _formatKgToTonnes(scoreKg, decimals: 1);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.gradientGreenEnd.withValues(alpha: 0.1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Ton empreinte annuelle",
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          Text(
            scoreFormatted,
            style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
          ),
          Text(
            "tonnes CO₂e / an",
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.gradientGreenEnd.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.target, size: 18, color: AppColors.gradientGreenEnd),
                SizedBox(width: 8),
                Text(
                  "Objectif 2050 : 2 t/an",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.gradientGreenEnd,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. CAMEMBERT ---
  Widget _buildCategoryChart(BuildContext context, Map<String, double> scoresKg) {
    final colors = [
      const Color(0xFFFF6B6B), const Color(0xFF4ECDC4),
      const Color(0xFFFFD93D), const Color(0xFF6BCB77), const Color(0xFF4D96FF),
    ];
    List<PieChartSectionData> sections = [];
    int i = 0;
    scoresKg.forEach((key, valueKg) {
      if (valueKg > 0) {
        sections.add(PieChartSectionData(
          color: colors[i++ % colors.length],
          value: valueKg,
          radius: 35,
          title: '',
        ));
      }
    });

    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(sections: sections, centerSpaceRadius: 45, sectionsSpace: 2),
      ),
    );
  }

  // --- 4. BARRES DE CATÉGORIES (POURCENTAGES) ---
  Widget _buildCategoryBars(BuildContext context, Map<String, double> scores, double total) {
    final colors = [
      const Color(0xFFFF6B6B), const Color(0xFF4ECDC4),
      const Color(0xFFFFD93D), const Color(0xFF6BCB77), const Color(0xFF4D96FF),
    ];
    int i = 0;

    return Column(
      children: scores.entries.where((e) => e.value > 0).map((entry) {
        final color = colors[i++ % colors.length];
        final percentage = (entry.value / total) * 100;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    "${percentage.toStringAsFixed(0)}%",
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: entry.value / total,
                  minHeight: 8,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- 5. LISTE VERTICALE DES ÉQUIVALENTS ---
  Widget _buildEquivalentsList(BuildContext context, List<dynamic> items, double scoreKg) {
    final theme = Theme.of(context);

    return Column(
      children: items.take(5).map((itemData) {
        final item = itemData as CarboneEquivalentEntity;
        // Ta logique de calcul originale
        final double finalValue = (scoreKg / 1000.0) * item.valeur1Tonne;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Text(item.icone ?? '💡', style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Formatage des nombres (milliers et virgules)
                      finalValue > 10
                          ? finalValue.round().toString().replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]} ')
                          : finalValue.toStringAsFixed(1).replaceAll('.', ','),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.equivalentLabel, // Contient déjà la description
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- DÉCORATIONS ---
  Widget _buildBackgroundDecorations(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: -size.height * 0.05,
          right: -size.width * 0.1,
          child: _blurCircle(size.width * 0.4, AppColors.gradientGreenEnd.withValues(alpha: 0.1)),
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
}