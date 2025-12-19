// features/bilanCarbone/domain/usecases/enregistrer_et_simuler_reponse_usecase.dart

import 'dart:convert';

import 'package:oikos/features/bilanCarbone/domain/entities/question_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/type_widget.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/simulation_repository.dart';


class EnregistrerReponseUseCase {
  final SimulationRepository simulationRepo;
  final ReponseRepository reponseRepo;
  final BilanSessionRepository bilanSessionRepo;
  List<ReponseUtilisateurEntity> reponses = [];

  EnregistrerReponseUseCase({
    required this.simulationRepo,
    required this.reponseRepo,
    required this.bilanSessionRepo,
  });

  Future<void> call({
    required QuestionBilanEntity question, 
    required dynamic valeur,
  }) async {
    // 1. Récupérer l'ID utilisateur
    final bilanId = await bilanSessionRepo.getBilanId();
    if (bilanId == null) {
      
      throw Exception("ID utilisateur manquant. Impossible d'enregistrer la réponse.");
    }
    
    // 2. Enregistrer la réponse dans la base de données (Persistance)
    await reponseRepo.saveReponse(
      ReponseUtilisateurEntity(
        bilanId: bilanId,
        questionId: question.id,
        valeur: valeur,
      )
    );
    // 3. Envoyer la réponse au moteur de simulation (État temporaire)
    final Map<String, dynamic> situationFormattee = _formaterPourSimulation(question, valeur);

    simulationRepo.updateSituation(situationFormattee);  
  }

  Map<String, dynamic> _formaterPourSimulation(QuestionBilanEntity question, dynamic valeur) {
    final Map<String, dynamic> situation = {};
    final String parentSlug = question.slug;
    if (valeur == null) return situation;
    // On s'assure d'avoir une String pour les tests de format JSON
    final String rawValue = valeur.toString();
    // --- CAS 1 : CHOIX MULTIPLE (Liste JSON) ---
    // Transforme ["élec", "gaz"] en {"chauffage . élec": "'oui'", ...}
    if (question.typeWidget == TypeWidget.choixMultiple || rawValue.startsWith('[')) {
      try {
        final List<dynamic> values = (valeur is String) ? jsonDecode(rawValue) : valeur;
        for (var v in values) {
          if (v != null) {
            situation['$parentSlug . $v'] = "'oui'";
          }
        }
        return situation;
      } catch (e) {
        print("Erreur parsing Liste pour $parentSlug");
      }
    }
    // --- CAS 2 : COMPTEUR (Map JSON) ---
    // Transforme {"smartphone": 2} en {"numérique . smartphone": 2}
    if (question.typeWidget == TypeWidget.compteur || rawValue.startsWith('{')) {
      try {
        final Map<String, dynamic> counts = (valeur is String) ? jsonDecode(rawValue) : valeur;
        counts.forEach((key, val) {
          if (val != null) {
            situation['$parentSlug . $key'] = val;
          }
        });
        return situation;
      } catch (e) {
        print("Erreur parsing Map pour $parentSlug");
      }
    }
    // --- CAS 3 : VALEURS CLASSIQUES (Nombre ou Texte) ---
    final numericValue = double.tryParse(rawValue);
    if (numericValue != null) {
      situation[parentSlug] = numericValue;
    } else if (rawValue.isNotEmpty) {
      // Ajout des simples quotes pour les catégories Publicodes
      situation[parentSlug] = "'$rawValue'";
    }
    return situation;
  }
}