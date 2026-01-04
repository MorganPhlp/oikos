part of 'bilan_bloc.dart';


abstract class BilanState extends Equatable {
  const BilanState();

  @override
  List<Object?> get props => [];
}

// 1. État de chargement (au lancement ou calcul long)
class BilanLoading extends BilanState {}

// 2. État principal : Une question est affichée
class BilanQuestionDisplayed extends BilanState {
  final QuestionBilanEntity question; // La question
  final int index;          // Numéro de la question (ex: 3)
  final int totalQuestions; // Total des questions prévues
  final dynamic valeurPrecedente; // Valeur déjà donnée (si retour arrière)

  const BilanQuestionDisplayed({
    required this.question,
    required this.index,
    required this.totalQuestions,
    this.valeurPrecedente,
  });

  @override
  List<Object?> get props => [question, index, totalQuestions, valeurPrecedente];
}

// 3. État final : Le questionnaire est fini
class BilanTermine extends BilanState {}

// 4. État d'erreur
class BilanError extends BilanState {
  final String message;
  const BilanError(this.message);
  @override
  List<Object?> get props => [message];
}

class BilanChoixCategories extends BilanState {
  final List <CategorieEmpreinteEntity> categories;
  const BilanChoixCategories(this.categories);
  
  @override
  List<Object?> get props => [categories];
}

class BilanResultats extends BilanState {
  final double scoreTotal;
  final Map<String, double> scoresParCategorie;
  final List<CarboneEquivalentEntity>? equivalents;


  const BilanResultats({
    required this.scoreTotal,
    required this.scoresParCategorie,
    this.equivalents,
  });

  @override
  List<Object?> get props => [scoreTotal, scoresParCategorie, equivalents];
}

class BilanChoixObjectifs extends BilanState {
  final List<ObjectifEntity> objectifs;
  final double scoreActuel;

  const BilanChoixObjectifs({
    required this.objectifs,
    required this.scoreActuel,
  });

  @override
  List<Object?> get props => [objectifs, scoreActuel];
}