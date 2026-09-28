import 'package:flutter/material.dart';

class NotificationIconContainer extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const NotificationIconContainer({
    super.key,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class UnreadIndicator extends StatelessWidget {
  const UnreadIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 4,
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
