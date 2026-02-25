import 'dart:ui';
import 'package:flutter/material.dart';

class VoteButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool alreadyVoted;
  final bool? voteValue; // true = Accepté, false = Refusé
  final VoidCallback onTap;

  const VoteButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.alreadyVoted,
    required this.onTap,
    this.voteValue,
  });

  @override
  State<VoteButton> createState() => _VoteButtonState();
}

class _VoteButtonState extends State<VoteButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: widget.alreadyVoted ? _buildSuccessBadge(theme) : _buildButton(),
    );
  }

  Widget _buildButton() {
    return InkWell(
      key: const ValueKey('btn_active'),
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: widget.color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 16, color: widget.color),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessBadge(ThemeData theme) {
    final theme = Theme.of(context);
    // Détermination de la couleur et du texte selon la valeur du vote
    final statusColor = widget.voteValue == true
        ? theme.colorScheme.primary
        : theme.colorScheme.error;
    final statusText = widget.voteValue == true
        ? "Tu as voté pour"
        : "Tu as voté contre";
    final statusIcon = widget.voteValue == true
        ? Icons.check_circle
        : Icons.cancel;

    return Container(
      key: const ValueKey('btn_success'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(statusIcon, color: statusColor, size: 18),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
