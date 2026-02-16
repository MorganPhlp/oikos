import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/widgets/loader.dart';
import 'dart:ui';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_state.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_category_bars.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_category_pie_chart.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_equivalents_list.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_hero_score.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

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
        final List<CarboneEquivalentEntity> equivalents = state.equivalents;

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
                      BilanHeroScore(scoreKg: scoreKg),
                      SizedBox(height: size.height * 0.04),

                      // Graphique en camembert
                      BilanCategoryPieChart(scoresKg: scoresParCategorie),
                      SizedBox(height: size.height * 0.03),

                      // Barres de répartition par catégorie
                      BilanCategoryBars(scoresKg: scoresParCategorie, totalKg: scoreKg),
                      
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
                      
                      BilanEquivalentsList(items: equivalents, scoreKg: scoreKg),

                      SizedBox(height: size.height * 0.04),
                      
                      // Bouton de sortie (utilise ton GradientButton thémé)
                      GradientButton(
                        label: "Retour à l'accueil", 
                        onPressed: () => context.go('/home'),
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