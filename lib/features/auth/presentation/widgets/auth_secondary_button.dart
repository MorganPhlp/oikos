import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';

class AuthSecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<AuthSecondaryButton> createState() => _AuthSecondaryButtonState();
}

class _AuthSecondaryButtonState extends State<AuthSecondaryButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
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
          height: 55, // Même hauteur que le PrimaryButton pour la symétrie
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent, // Fond transparent
            // Optionnel : Décommentez la ligne ci-dessous si vous voulez une bordure fine
            // border: Border.all(color: AppColors.lightTextGreen.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isEnabled ? widget.onPressed : null,
              borderRadius: BorderRadius.circular(16),
              // L'effet de clic (onde) prend une teinte verte très légère
              splashColor: AppColors.lightTextGreen.withValues(alpha: 0.1),
              highlightColor: AppColors.lightTextGreen.withValues(alpha: 0.05),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.lightTextGreen,
                    strokeWidth: 2.5,
                  ),
                )
                    : Text(
                  widget.text,
                  style: AppTypography.body.copyWith(
                    color: isEnabled
                        ? AppColors.lightTextGreen
                        : Colors.grey, // Gris si désactivé
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}