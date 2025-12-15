import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oikos/core/theme/app_colors.dart';

class CounterItem extends StatelessWidget {
  final String label;
  final String? iconEmoji; // ex: "📺"
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CounterItem({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.iconEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightInput, // Fond gris très clair
        borderRadius: BorderRadius.circular(14),
        // Ombre subtile comme sur le design
        boxShadow: [
          BoxShadow(
            color: AppColors.darkPrimaryForeground.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // LABEL + ICONE
          Expanded(
            child: Row(
              children: [
                if (iconEmoji != null && iconEmoji!.isNotEmpty) ...[
                  Text(iconEmoji!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.lightTextPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // CONTROLES (+ / -)
          Row(
            children: [
              _CounterButton(
                icon: Icons.remove,
                onTap: onDecrement,
                isActive: value > 0, // Désactivé si 0
              ),
              
              SizedBox(
                width: 40,
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ),
              
              _CounterButton(
                icon: Icons.add,
                onTap: onIncrement,
                isActive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Petit widget privé pour les boutons ronds verts
class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _CounterButton({
    required this.icon,
    required this.onTap,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? onTap : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppColors.gradientGreenEnd : AppColors.lightMuted,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : AppColors.lightMutedForeground,
          size: 20,
        ),
      ),
    );
  }
}