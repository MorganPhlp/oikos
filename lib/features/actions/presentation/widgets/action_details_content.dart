import 'package:flutter/material.dart';
import '../../domain/entities/action_entity.dart';

class ActionDetailContent extends StatelessWidget {
  final ActionEntity action;

  const ActionDetailContent({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'Objectif : ${action.description}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildAccordion(
            context,
            title: 'Comment faire ?',
            icon: Icons.list_alt,
            initiallyExpanded: true,
            content: Column(
              children: action.tips
                  .map((t) => _buildTipRow(context, t))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _buildAccordion(
            context,
            title: 'Pourquoi c\'est important ?',
            icon: Icons.lightbulb_outline,
            initiallyExpanded: false,
            content: _buildImportanceContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTipRow(BuildContext context, String tip) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(tip, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildImportanceContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chaque petit geste compte ! En adoptant cette habitude, vous contribuez à réduire votre empreinte environnementale.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.groups, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Rejoignez des milliers de citoyens engagés !'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccordion(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool initiallyExpanded,
    required Widget content,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: Icon(icon, color: colorScheme.primary, size: 22),
          title: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
