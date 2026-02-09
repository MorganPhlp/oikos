import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/*
* On y met toute la partie visuelle
*  (boutons retour, flash, cadre de visée).
* */


class ScannerOverlay extends StatelessWidget {
  final MobileScannerController controller;
  final bool isLoading;

  const ScannerOverlay({
    super.key,
    required this.controller,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bouton Retour
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(backgroundColor: Colors.black54),
                ),
                // Bouton Flash
                IconButton(
                  icon: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, state, child) {
                      final isFlashOn = state.torchState == TorchState.on;
                      return Icon(
                        isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      );
                    },
                  ),
                  onPressed: () => controller.toggleTorch(),
                  style: IconButton.styleFrom(backgroundColor: Colors.black54),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Cadre de visée
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const Spacer(),
          // Texte d'info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isLoading ? 'Recherche en cours...' : 'Scannez un code-barres',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}