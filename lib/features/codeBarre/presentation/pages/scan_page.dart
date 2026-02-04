import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oikos/core/utils/show_snackbar.dart';
import 'package:oikos/features/codeBarre/presentation/bloc/scan_bloc.dart';
import 'package:oikos/features/codeBarre/presentation/pages/product_modal.dart';
import 'package:oikos/features/codeBarre/presentation/pages/scanner_overlay.dart';
import 'package:oikos/init_dependencies.dart';

/*
*
* Gère l'orchestration Bloc + Caméra
* */

class ScanPage extends StatefulWidget {
  static const routeName = '/scan';

  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // pour relancer le scan proprement
  void _resetScan() {
    if (mounted) {
      context.read<ScanBloc>().add(ScanReset());
      controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ScanBloc>(),
      child: Scaffold(
        backgroundColor: Colors.black, // Fond noir pour éviter les flashs blancs
        body: BlocConsumer<ScanBloc, ScanState>(
          listener: (context, state) {
            if (state is ScanFailure) {
              showSnackBar(context, state.message);
              // On attend 2 secondes avant de relancer après une erreur
              Future.delayed(const Duration(seconds: 2), _resetScan);
            } else if (state is ScanSuccess) {
              controller.stop(); // On fige la caméra
              _showProductBottomSheet(context, state);
            }
          },
          builder: (context, state) {
            final isLoading = state is ScanLoading;

            return Stack(
              children: [
                // La Caméra
                MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    // On ne scanne que si on n'est pas déjà en train de charger
                    if (barcodes.isNotEmpty && !isLoading) {
                      final code = barcodes.first.rawValue;
                      if (code != null) {
                        context.read<ScanBloc>().add(ScanBarcodeDetected(code));
                      }
                    }
                  },
                ),

                // L'Overlay (Boutons, Cadre...)
                ScannerOverlay(
                  controller: controller,
                  isLoading: isLoading,
                ),

                // Loader central pour le chargement
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // affiche la fiche du produit
  void _showProductBottomSheet(BuildContext parentContext, ScanSuccess state) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProductModal(
        aliment: state.aliment,
        onAddPressed: () {
          Navigator.pop(ctx);
          // TODO: Ajouter la logique d'ajout final ici
          _resetScan();
        },
      ),
    ).then((_) {
      // Quand la modale se ferme (swipe ou clic extérieur), on relance le scan
      _resetScan();
    });
  }
}