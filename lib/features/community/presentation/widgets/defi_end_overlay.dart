import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'defi_end_animation.dart';

class DefiEndOverlay extends StatelessWidget {
  final DefiEntity defi;
  final VoidCallback? onClose; // Optionnel : pour fermer quand on clique

  const DefiEndOverlay({super.key, required this.defi, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fond flou + sombre
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),
        ),

        // Animation centrée
        Center(child: DefiEndAnimation(defi: defi)),

        // Clic pour fermer overlay si on veut
        if (onClose != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
            ),
          ),
      ],
    );
  }
}
