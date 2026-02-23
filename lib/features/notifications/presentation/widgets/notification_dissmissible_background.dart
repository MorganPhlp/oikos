import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationDismissibleBackground extends StatelessWidget {
  const NotificationDismissibleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 32),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(LucideIcons.trash2, color: Colors.white),
    );
  }
}
