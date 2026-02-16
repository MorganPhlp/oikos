import 'package:flutter/material.dart';

class DecorativeSeparator extends StatelessWidget {
  const DecorativeSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, color.withValues(alpha: 0.3)],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.3), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
