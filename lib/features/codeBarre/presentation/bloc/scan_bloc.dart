import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/aliment_entity.dart';
import '../../domain/usecases/get_aliment_by_code.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final GetAlimentByCode _getAlimentByCode;

  ScanBloc({required GetAlimentByCode getAlimentByCode})
      : _getAlimentByCode = getAlimentByCode,
        super(ScanInitial()) {

    on<ScanEvent>((event, emit) {
      // Logique pour réinitialiser quand on veut scanner un autre produit
      if (event is ScanReset) {
        emit(ScanInitial());
      }
    });

    on<ScanBarcodeDetected>(_onBarcodeDetected);
  }

  void _onBarcodeDetected(
      ScanBarcodeDetected event,
      Emitter<ScanState> emit,
      ) async {
    // Etat de chargement
    emit(ScanLoading());

    // On appelle le UseCase pour récupérer le produit
    final result = await _getAlimentByCode(event.barcode);

    // Selon le résultat, erreur ou succès
    result.fold(
          (failure) => emit(ScanFailure(failure.message)),
          (aliment) => emit(ScanSuccess(aliment)),
    );
  }
}