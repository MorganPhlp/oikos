import 'package:flutter/material.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';

class OikosConfirmModal extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final bool isDestructive;
  final Color? confirmColor;

  const OikosConfirmModal({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.isDestructive = true,
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: colorScheme.surface,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      title: Center(
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                isTertiary: isDestructive && confirmColor == null,

                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                label: confirmLabel,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                onPressed: () => Navigator.pop(context),
                label: "Annuler",
                isSecondary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
