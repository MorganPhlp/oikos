import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BilanCategoryPieChart extends StatelessWidget {
  final Map<String, double> scoresKg;

  const BilanCategoryPieChart({
    super.key,
    required this.scoresKg,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFD93D),
      const Color(0xFF6BCB77),
      const Color(0xFF4D96FF),
    ];

    final sections = <PieChartSectionData>[];
    var i = 0;
    scoresKg.forEach((_, valueKg) {
      if (valueKg > 0) {
        sections.add(
          PieChartSectionData(
            color: colors[i++ % colors.length],
            value: valueKg,
            radius: 35,
            title: '',
          ),
        );
      }
    });

    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 45,
          sectionsSpace: 2,
        ),
      ),
    );
  }
}
