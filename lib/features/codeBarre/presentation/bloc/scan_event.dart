part of 'scan_bloc.dart';

sealed class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object> get props => [];
}

// L'utilisateur a scanné un code-barres
class ScanBarcodeDetected extends ScanEvent {
  final String barcode;

  const ScanBarcodeDetected(this.barcode);

  @override
  List<Object> get props => [barcode];
}

// L'utilisateur veut réinitialiser le scan pour en faire un nouveau
class ScanReset extends ScanEvent {}