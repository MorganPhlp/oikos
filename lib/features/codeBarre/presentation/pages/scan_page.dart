import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oikos/core/utils/show_snackbar.dart';
import 'package:oikos/features/codeBarre/presentation/bloc/scan_bloc.dart';
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

  bool _isProcessing = false;

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
          listener: (context, state) async {

            if (state is ScanFailure) {
              showSnackBar(context, state.message);
              // On attend 2 secondes avant de relancer après une erreur
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  context.read<ScanBloc>().add(ScanReset());
                  controller.start();
                  setState(() { _isProcessing = false; });
                }
              });
            }
            else if (state is ScanSuccess) {
              controller.stop(); // On fige la caméra

              // On navigue vers la page de détails en passant l'aliment trouvé
              await context.push('/scan/details', extra: state.aliment);

              // Au retour de la page détails :
              if (mounted) {
                // 1. On reset le bloc
                context.read<ScanBloc>().add(ScanReset());
                // 2. On redémarre la caméra
                controller.start();
                // 3. On enlève le verrou pour permettre un nouveau scan
                setState(() {
                  _isProcessing = false;
                });
              }

            }
          },
          builder: (context, state) {
            final isLoading = state is ScanLoading;
            if (isLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }


            return Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;

                    // SI on est déjà en train de traiter un code OU qu'il n'y a pas de code -> ON STOPPE
                    if (_isProcessing || barcodes.isEmpty) return;

                    final code = barcodes.first.rawValue;
                    if (code != null) {
                      // On verrouille immédiatement
                      setState(() {
                        _isProcessing = true;
                      });

                      // On lance l'événement
                      context.read<ScanBloc>().add(ScanBarcodeDetected(code));
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

}