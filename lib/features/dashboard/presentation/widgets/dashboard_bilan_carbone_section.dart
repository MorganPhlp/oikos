import 'package:flutter/material.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_category_bars.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_category_pie_chart.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_equivalents_list.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_hero_score.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_info_button.dart';

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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bilan Carbone',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 8),
            const DashboardInfoButton(
              title: 'Bilan Carbone',
              message:
                  "Affiche la répartition de ton empreinte par catégorie pour ton dernier bilan. Pratique pour repérer les catégories les plus importantes.",
            ),
          ],
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
