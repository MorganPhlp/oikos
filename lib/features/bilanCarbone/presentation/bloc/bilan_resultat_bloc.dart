import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/detail_bilan_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/calculer_bilan_categories_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/choix_categories_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/definir_objectif_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/demarrer_approfondissement_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/preparer_choix_objectifs_use_case.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_equivalents_carbone_use_case.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_event.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_resultat_state.dart';

class BilanResultatBloc extends Bloc<ResultatEvent, ResultatState> {
  final DemarrerApprofondissementUseCase demarrerApproUseCase;
  final ChoixCategoriesUseCase choixCategoriesUseCase;
  final PreparerChoixObjectifsUseCase preparerObjectifsUseCase;
  final DefinirObjectifUseCase definirObjectifUseCase;
  final CalculerBilanCategoriesUseCase calculerCategoriesUseCase;
  final RecupererEquivalentsCarboneUseCase equivalentsUseCase;

  double? _scoreTotalCached;
  DetailBilanEntity? _detailBilanCached;
  List<CategorieEmpreinteEntity> _categoriesDisponibles = [];

  BilanResultatBloc({
    required this.demarrerApproUseCase,
    required this.choixCategoriesUseCase,
    required this.preparerObjectifsUseCase,
    required this.definirObjectifUseCase,
    required this.calculerCategoriesUseCase,
    required this.equivalentsUseCase,
  }) : super(ResultatInitial()) {
    on<DemarrerAnalyseEvent>(_onDemarrerAnalyse);
    on<ValiderCategoriesEvent>(_onValiderCategories);
    on<ValiderObjectifEvent>(_onValiderObjectif);
    on<RetourAuChoixCategoriesEvent>(_onRetourCategories);
  }

  Future<void> _onDemarrerAnalyse(
    DemarrerAnalyseEvent event,
    Emitter<ResultatState> emit,
  ) async {
    emit(ResultatLoading());
    try {
      _categoriesDisponibles = await demarrerApproUseCase.call();
      emit(ResultatChoixCategories(_categoriesDisponibles));
    } catch (e) {
      emit(
        const ResultatError(
          "Impossible de charger les catégories d'approfondissement.",
        ),
      );
    }
  }

  Future<void> _onValiderCategories(
    ValiderCategoriesEvent event,
    Emitter<ResultatState> emit,
  ) async {
    emit(ResultatLoading());
    try {
      // 1. On enregistre les catégories choisies par l'utilisateur
      await choixCategoriesUseCase.call(categories: event.categories);

      // 2. On prépare les objectifs de réduction basés sur ces catégories
      final resultat = await preparerObjectifsUseCase.call();

      // On met le score en cache pour l'écran final
      _scoreTotalCached = resultat.scoreActuel;
      _detailBilanCached = resultat.detailBilan;

      emit(
        ResultatChoixObjectifs(
          scoreActuel: resultat.scoreActuel,
          objectifs: resultat.objectifs,
        ),
      );
    } catch (e) {
      emit(const ResultatError("Erreur lors de la préparation des objectifs."));
    }
  }

  Future<void> _onValiderObjectif(
    ValiderObjectifEvent event,
    Emitter<ResultatState> emit,
  ) async {
    emit(ResultatLoading());
    try {
      definirObjectifUseCase.call(event.objectif.valeur);

      // Récupération des données finales pour l'affichage
      final equivalents = await equivalentsUseCase.call();

      emit(
        ResultatFinal(
          scoreTotal: _scoreTotalCached ?? 0.0,
          scoresParCategorie: _detailBilanCached ?? DetailBilanEntity.empty(),
          equivalents: equivalents,
        ),
      );
    } catch (e) {
      emit(
        const ResultatError(
          "Erreur lors de la génération des résultats finaux.",
        ),
      );
    }
  }

  void _onRetourCategories(
    RetourAuChoixCategoriesEvent event,
    Emitter<ResultatState> emit,
  ) {
    emit(ResultatChoixCategories(_categoriesDisponibles));
  }
}
