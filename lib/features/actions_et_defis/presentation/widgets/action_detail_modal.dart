import 'package:flutter/material.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/features/actions_et_defis/presentation/widgets/action_stats.dart';
import 'package:oikos/features/actions_et_defis/presentation/widgets/category_chip.dart';

import '../../../../core/theme/oikos_button_theme.dart';
import '../../domain/entities/action_entity.dart';

class ActionDetailModal extends StatelessWidget {
  final ActionEntity action;
  final Function(ActionEntity action) onAdd;
  final Function(String actionId)? onEcarter;
  final bool isAlreadyAdded;

  const ActionDetailModal({
    super.key,
    required this.action,
    required this.onAdd,
    this.onEcarter,
    this.isAlreadyAdded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final buttonTheme = theme.extension<OikosButtonTheme>();
    final actionTheme = theme.extension<ActionCardTheme>()!;
    final categoryColor = actionTheme.getCategoryColor(action.categoryName);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Stack(
            children: [
              ListView(
                controller: controller,
                padding: EdgeInsets.zero,
                children: [
                  _buildHeader(context, categoryColor),
                  const SizedBox(height: 24),
                  Padding(
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
                        const SizedBox(
                          height: 140,
                        ), // Espace pour la bottom bar
                      ],
                    ),
                  ),
                ],
              ),
              // Bouton Fermer
              Positioned(top: 16, right: 16, child: _buildCloseButton(context)),
              // Barre d'action fixe en bas
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomBar(context, buttonTheme, categoryColor),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Color categoryColor) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Column(
        children: [
          // Cercle Icone
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  categoryColor.withValues(alpha: 0.15),
                  categoryColor.withValues(alpha: 0.35),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: categoryColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(action.icon, size: 32, color: categoryColor),
          ),
          const SizedBox(height: 16),
          Text(
            action.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Badge Catégorie réutilisable
          CategoryChip(
            categoryName: action.categoryName,
            style: CategoryChipStyle.filled,
          ),
          const SizedBox(height: 24),
          // Ligne de Stats réutilisable
          OikosActionStats(
            impactScore: action.impactScore,
            difficulty: action.difficulty,
            frequencyLabel: _getFreqLabel(action.frequency),
            primaryColor: categoryColor,
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
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

  Widget _buildBottomBar(
    BuildContext context,
    OikosButtonTheme? buttonTheme,
    Color categoryColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isAlreadyAdded)
            _buildAlreadyAddedBadge(theme, colorScheme, categoryColor)
          else ...[
            GradientButton(
              onPressed: () => onAdd(action),
              label: 'Ajouter à mes actions',
            ),
            if (onEcarter != null) ...[
              const SizedBox(height: 12),
              _buildDismissButton(context, theme, colorScheme),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildAlreadyAddedBadge(
    ThemeData theme,
    ColorScheme colorScheme,
    Color categoryColor,
  ) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 22, color: categoryColor),
          const SizedBox(width: 10),
          Text(
            'Déjà dans mes actions',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissButton(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return TextButton(
      onPressed: () => _showDismissDialog(context, theme, colorScheme),
      child: Text(
        'Pas pour moi',
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.5),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _showDismissDialog(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Écarter cette action ?',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Elle ne sera plus visible dans votre catalogue, mais vous pourrez la retrouver dans vos paramètres.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Column(
            children: [
              GradientButton(
                isTertiary: true,
                onPressed: () {
                  onEcarter?.call(action.id);
                  Navigator.pop(context); // Ferme Dialog
                  Navigator.pop(context); // Ferme Modal
                },
                label: "Oui, écarter",
              ),
              const SizedBox(height: 12),
              GradientButton(
                isSecondary: true,
                onPressed: () => Navigator.pop(context),
                label: "Annuler",
              ),
            ],
          ),
        ],
      ),
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
      margin: const EdgeInsets.only(bottom: 12),
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

  Widget _buildCloseButton(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.close, size: 20),
    );
  }

  String _getFreqLabel(String freq) {
    switch (freq.toLowerCase()) {
      case 'journalier':
        return 'Quotidien';
      case 'hebdomadaire':
        return 'Hebdo';
      case 'mensuel':
        return 'Mensuel';
      default:
        return 'Unique';
    }
  }
}
