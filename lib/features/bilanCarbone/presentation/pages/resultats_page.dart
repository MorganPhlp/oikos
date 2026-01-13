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

  String _formatKgToTonnes(double kgValue, {int decimals = 1}) {
    double tonnes = kgValue / 1000;
    return tonnes.toStringAsFixed(decimals).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BilanBloc, BilanState>(
      builder: (context, state) {
        if (state is! BilanResultats) {
          return const Scaffold(body: Center(child: Loader()));
        }

        final double scoreKg = state.scoreTotal;
        final Map<String, double> scoresParCategorie = state.scoresParCategorie;
        final List<dynamic>? equivalents = state.equivalents;

        final size = MediaQuery.of(context).size;
        final isSmallScreen = size.width < 360;
        final String totalTonnesFormatted = _formatKgToTonnes(scoreKg, decimals: 1);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

                      // Score Hero (Style d'avant)
                      _buildHeroScore(scoreKg, 2000.0, context),
                      SizedBox(height: size.height * 0.03),

                      // Graphique (Style d'avant)
                      _buildCategoryChart(context, scoresParCategorie),
                      SizedBox(height: size.height * 0.04),

                      Text(
                        "$totalTonnesFormatted tonnes de CO₂ par an",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : size.width * 0.055,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "C'est l'équivalent de :",
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Nouveaux équivalents (épurés avec emojis)
                      _buildEquivalentsGrid(context, equivalents, scoreKg),

                      SizedBox(height: size.height * 0.04),
                      _buildFooter(context, () => Navigator.of(context).popUntil((route) => route.isFirst)),
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

  // --- COMPOSANTS DE STYLE (Thème original) ---

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

  Widget _buildHeroScore(double scoreKg, double targetKg, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String scoreFormatted = _formatKgToTonnes(scoreKg, decimals: 1);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.07),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.gradientGreenEnd.withOpacity(0.1), width: 2),
        boxShadow: [
          BoxShadow(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          Text("Ton empreinte annuelle", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
          Text(
            scoreFormatted,
            style: TextStyle(
              fontSize: size.width * 0.14,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text("tonnes CO₂e / an", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w500)),
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
                  "Objectif 2050 : 2 t/an",
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.gradientGreenEnd),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- NOUVEAUX ÉQUIVALENTS (Style épuré) ---

  Widget _buildEquivalentsGrid(BuildContext context, List<dynamic>? equivalents, double scoreKg) {
    if (equivalents == null || equivalents.isEmpty) return const SizedBox();
    final items = equivalents.take(4).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index] as CarboneEquivalentEntity;
        final double finalValue = (scoreKg / 1000.0) * item.valeur1Tonne;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.icone ?? '💡', style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 6),
              Text(
                finalValue > 10 ? finalValue.round().toString() : finalValue.toStringAsFixed(1).replaceAll('.', ','),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
              Text(
                item.equivalentLabel,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- AUTRES COMPOSANTS ---

  Widget _buildHeaderTitle(BuildContext context) {
    return Column(
      children: [
        Text("Mon bilan carbone", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 4),
        Container(height: 3, width: 40, decoration: BoxDecoration(color: AppColors.gradientGreenEnd, borderRadius: BorderRadius.circular(2))),
      ],
    );
  }

  Widget _buildCategoryChart(BuildContext context, Map<String, double> scoresKg) {
    final colors = [const Color(0xFFFF6B6B), const Color(0xFF4ECDC4), const Color(0xFFFFD93D), const Color(0xFF6BCB77), const Color(0xFF4D96FF)];
    List<PieChartSectionData> sections = [];
    List<Widget> legendItems = [];
    int i = 0;
    scoresKg.forEach((key, valueKg) {
      if (valueKg > 0) {
        final color = colors[i % colors.length];
        sections.add(PieChartSectionData(color: color, value: valueKg, radius: 30, title: ''));
        legendItems.add(Builder(
          builder: (context) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(key, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
            ],
          ),
        ));
        i++;
      }
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(25), border: Border.all(color: Theme.of(context).colorScheme.outline)),
      child: Column(
        children: [
          SizedBox(height: 140, child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 35))),
          const SizedBox(height: 20),
          Wrap(spacing: 15, runSpacing: 10, alignment: WrapAlignment.center, children: legendItems),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, VoidCallback onContinue) {
    return GradientButton(label: "Continuer", onPressed: onContinue);
  }
}