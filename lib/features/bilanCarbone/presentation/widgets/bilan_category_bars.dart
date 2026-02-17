import 'package:flutter/material.dart';

class BilanCategoryBars extends StatelessWidget {
  final Map<String, double> scoresKg;
  final double totalKg;

  const BilanCategoryBars({
    super.key,
    required this.scoresKg,
    required this.totalKg,
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

    var i = 0;

    return Column(
      children: scoresKg.entries.where((e) => e.value > 0).map((entry) {
        final color = colors[i++ % colors.length];
        final percentage = totalKg == 0 ? 0.0 : (entry.value / totalKg) * 100;

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
                    '${percentage.toStringAsFixed(0)}%',
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: totalKg == 0 ? 0 : (entry.value / totalKg),
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
}
