import 'package:flutter/material.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';

class EcarterActionsModal extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;
  final IconData? icon;

  const EcarterActionsModal({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onDismiss,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle de tirage
          Container(
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 32),

          // Icône contextuelle optionnelle
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colorScheme.primary, size: 32),
            ),
          const SizedBox(height: 24),

          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),

          // Utilisation de tes GradientButton
          Column(
            children: [
              GradientButton(
                label: "Ne plus me proposer",
                onPressed: onConfirm,
              ),
              const SizedBox(height: 12),
              GradientButton(
                label: "J'ai changé d'avis, cela m'intéresse toujours",
                isSecondary: true, // Pour le style outline "Annuler"
                onPressed: onDismiss,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
