import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha:0.8),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const _CircleIconButton(icon: LucideIcons.user),
          const Spacer(),
          Image.asset("assets/logos/oikos_logo.png", height: 32, fit: BoxFit.contain),
          const SizedBox(width: 12),
          Container(
            width: 1, 
            height: 24, 
            color: colorScheme.outline.withValues(alpha:0.2),
          ),
          const SizedBox(width: 12),
          Icon(LucideIcons.leaf, color: colorScheme.primary), 
          const Spacer(),
          const _ScoreBadge(score: "1250"),
          const SizedBox(width: 8),
          const _CircleIconButton(icon: LucideIcons.bell, hasNotification: true),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final bool hasNotification;

  const _CircleIconButton({required this.icon, this.hasNotification = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // TODO : Ajouter la navigation ou l'action associée
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha:0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 20, color: colorScheme.onSurface),
            ),
          ),
        ),
        if (hasNotification)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 2),
              ),
              child: Center(
                child: Text(
                  "3", 
                  style: TextStyle(
                    color: colorScheme.onError, 
                    fontSize: 8, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final String score;
  const _ScoreBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha:0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.zap, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            score, 
            style: TextStyle(
              color: colorScheme.onSurface, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}