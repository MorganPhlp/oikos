import 'package:flutter/material.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';

class BilanEquivalentsList extends StatelessWidget {
  final List<CarboneEquivalentEntity> items;
  final double scoreKg;
  final int maxItems;

  const BilanEquivalentsList({
    super.key,
    required this.items,
    required this.scoreKg,
    this.maxItems = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: items.take(maxItems).map((item) {
        final double finalValue = (scoreKg / 1000.0) * item.valeur1Tonne;

        final String valueText = finalValue > 10
            ? finalValue.round().toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]} ',
              )
            : finalValue.toStringAsFixed(1).replaceAll('.', ',');

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
                      valueText,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.equivalentLabel,
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
}
