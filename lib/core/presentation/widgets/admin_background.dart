import 'package:flutter/material.dart';
import 'package:oikos/core/theme/admin_theme.dart';

/// Applies the current admin gradient as a full-area background.
///
/// Must be used inside the admin [Theme] scope (i.e. inside [AdminScaffold])
/// so that [GradientBackground] is available via the theme extensions.
///
/// Usage:
/// ```dart
/// AdminBackground(child: YourPageContent())
/// ```
class AdminBackground extends StatelessWidget {
  final Widget child;

  const AdminBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final gradient = GradientBackground.of(context).gradient;
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: child,
    );
  }
}
