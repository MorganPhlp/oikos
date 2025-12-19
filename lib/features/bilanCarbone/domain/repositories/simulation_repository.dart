abstract class SimulationRepository {
  /// Initialise le moteur de simulation (charge le JS et les règles)
  Future<void> init();

  /// Met à jour la situation avec de nouvelles réponses
  /// Note : Ta méthode prend une Map, donc l'interface doit prendre une Map
  void updateSituation(Map<String, dynamic> reponses);

  /// Vérifie si une question est pertinente pour la suite
  Future<bool> isQuestionApplicable(String questionSlug);

  Map<String, dynamic> getAccumulatedSituation();
  Future<double> getScore( {String objective = "bilan"} );
}