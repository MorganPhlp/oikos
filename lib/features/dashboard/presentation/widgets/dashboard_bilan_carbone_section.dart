import 'package:flutter/material.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_category_bars.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_category_pie_chart.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_equivalents_list.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_hero_score.dart';

class DashboardBilanCarboneSection extends StatelessWidget {
  final double scoreKg;
  final Map<String, double> scoresParCategorieKg;
  final List<CarboneEquivalentEntity> equivalents;

  const DashboardBilanCarboneSection({
    super.key,
    required this.scoreKg,
    required this.scoresParCategorieKg,
    required this.equivalents,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Bilan Carbone',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        BilanHeroScore(scoreKg: scoreKg),
        const SizedBox(height: 20),
        BilanCategoryPieChart(scoresKg: scoresParCategorieKg),
        const SizedBox(height: 16),
        BilanCategoryBars(scoresKg: scoresParCategorieKg, totalKg: scoreKg),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "C'est l'équivalent de :",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 12),
        BilanEquivalentsList(items: equivalents, scoreKg: scoreKg),
      ],
    );
  }
}
