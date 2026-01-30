import 'package:flutter/material.dart';
import 'package:oikos/core/theme/oikos_button_theme.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool isLoading;
  final bool isTertiary; // Pour switcher entre Vert et Orange
  final Widget? icon;
  final double? width;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
    this.isLoading = false,
    this.isTertiary = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonTheme = theme.extension<OikosButtonTheme>();
    
    final bool effectivelyDisabled = disabled || isLoading || onPressed == null;

    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        gradient: effectivelyDisabled 
            ? null 
            : (isTertiary ? buttonTheme?.tertiaryGradient : buttonTheme?.primaryGradient),
        
        color: effectivelyDisabled 
            ? (buttonTheme?.disabledColor ?? Colors.grey.shade300) 
            : null,
        
        borderRadius: BorderRadius.circular(15),
        boxShadow: effectivelyDisabled ? [] : [
          BoxShadow(
            color: isTertiary 
                ? (buttonTheme?.tertiaryGradient?.colors.last.withValues(alpha: 0.2) ?? Colors.orange.withValues(alpha: 0.2))
                : (buttonTheme?.shadowColor ?? Colors.black12),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: effectivelyDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(double.infinity, 55),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24, width: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!, 
                    const SizedBox(width: 10)
                  ],
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: effectivelyDisabled 
                          ? Colors.grey.shade600 
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}