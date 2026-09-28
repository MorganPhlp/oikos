class ActionEntity {
  final String id;
  final String title;
  final String description;
  final String categoryName;
  final List<String> tags;
  final String difficulty;
  final int impactScore;
  final String iconName;
  final List<String> tips;
  final String frequency;

  const ActionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryName,
    this.tags = const [],
    required this.difficulty,
    required this.impactScore,
    required this.iconName,
    required this.tips,
    required this.frequency,
  });
}
