import 'package:flutter/material.dart';
import 'package:oikos/core/theme/oikos_button_theme.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool isLoading;
  final bool isSecondary;
  final bool isTertiary; // Pour switcher entre Vert et Orange
  final Widget? icon;
  final double? width;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
    this.isLoading = false,
    this.isSecondary = false,
    this.isTertiary = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonTheme = theme.extension<OikosButtonTheme>();
    final bool effectivelyDisabled = disabled || isLoading || onPressed == null;

    // 1. On centralise la décoration
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: effectivelyDisabled 
              ? (buttonTheme?.disabledColor ?? theme.disabledColor) 
              : (isSecondary 
                  ? (buttonTheme?.secondaryGradient) 
                  : null),

      border: isSecondary && !effectivelyDisabled
        ? Border.all(color: theme.colorScheme.primary, width: 2)
        : null,

      gradient: (effectivelyDisabled || isSecondary) 
          ? null 
          : (isTertiary ? buttonTheme?.tertiaryGradient : buttonTheme?.primaryGradient),
            boxShadow: effectivelyDisabled ? null : theme.brightness == Brightness.dark ? null : [
              BoxShadow(
                color: isTertiary ? (buttonTheme?.tertiaryShadowColor ?? Colors.orange) 
                  : (buttonTheme?.shadowColor ?? Colors.black12),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          );

    return Container(
      width: width ?? double.infinity,
      decoration: decoration,
      child: ElevatedButton(
        onPressed: effectivelyDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(double.infinity, 55),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent, // Ajouté pour éviter les teintes M3
          elevation: 0,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: isLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 10)],
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: effectivelyDisabled ? theme.disabledColor : isSecondary ? theme.colorScheme.primary : theme.colorScheme.onPrimary,
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