import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';

class AuthPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading; // Nouveau : Pour afficher un loader

  const AuthPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Configuration de l'animation de rebond (scale)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si onPressed est null OU si on charge, le bouton est désactivé
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => _controller.forward() : null,
      onTapUp: isEnabled ? (_) => _controller.reverse() : null,
      onTapCancel: isEnabled ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          height: 55, // Légèrement plus haut pour une meilleure zone tactile
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // Changement de gradient si désactivé
            gradient: isEnabled
                ? const LinearGradient(
              colors: [
                AppColors.gradientGreenStart,
                AppColors.gradientGreenEnd,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
                : LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade400,
              ],
            ),
            // Ombre dynamique : disparaît si désactivé ou pressé
            boxShadow: isEnabled
                ? [
              BoxShadow(
                color: AppColors.gradientGreenEnd.withValues(alpha: 0.4),
                spreadRadius: -2,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isEnabled ? widget.onPressed : null,
              borderRadius: BorderRadius.circular(16),
              // Couleur de l'effet "splash" (onde)
              splashColor: Colors.white.withValues(alpha: 0.2),
              highlightColor: Colors.white.withValues(alpha: 0.1),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white), // Toujours blanc sur le gradient
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.text,
                      style: AppTypography.body.copyWith(
                        color: isEnabled ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}