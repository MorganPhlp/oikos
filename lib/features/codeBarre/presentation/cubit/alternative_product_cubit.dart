import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/aliment_entity.dart';
import '../../domain/usecases/get_alternative_product.dart';
import 'alternative_product_state.dart';

class AlternativeProductCubit extends Cubit<AlternativeProductState> {
  final GetAlternativeProduct _getAlternativeProduct;

  AlternativeProductCubit({
    required GetAlternativeProduct getAlternativeProduct,
  }) : _getAlternativeProduct = getAlternativeProduct,
        super(AlternativeProductInitial());

  Future<void> loadAlternative(AlimentEntity produitScanne) async {
    // On signale à l'UI que ça charge
    emit(AlternativeProductLoading());

    // On appelle le UseCase créé à l'étape 2
    final result = await _getAlternativeProduct(produitScanne);

    result.fold(
          (failure) => emit(AlternativeProductError(failure.message)),
          (alternative) {
        if (alternative != null) {
          // Si on trouve mieux
          emit(AlternativeProductSuccess(alternative));
        } else {
          // Pas d'alternative ou produit déjà top
          emit(AlternativeProductNotFound());
        }
      },
    );
  }
}