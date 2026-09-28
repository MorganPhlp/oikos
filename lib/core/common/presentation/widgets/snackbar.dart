import 'package:flutter/material.dart';

class OikosSnackBarContent extends StatelessWidget {
  final String message;
  final bool isError;

  const OikosSnackBarContent({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // On définit les couleurs selon l'état
    final iconColor = isError ? colorScheme.error : colorScheme.primary;
    final textColor = isError
        ? colorScheme.onErrorContainer
        : colorScheme.onPrimaryContainer;

    return Row(
      children: [
        Icon(
          isError ? Icons.lock_clock : Icons.check_circle_outline,
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
