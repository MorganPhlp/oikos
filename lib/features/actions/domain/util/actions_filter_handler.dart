import '../entities/action_entity.dart';
import '../entities/filter_data.dart';

extension ActionFilterHandler on List<ActionEntity> {
  List<ActionEntity> applyFilters({
    required String searchQuery,
    required FilterData filters,
  }) {
    // Filtrage
    var list = where((action) {
      if (filters.frequency != null && action.frequency != filters.frequency) {
        return false;
      }
      if (filters.category != null && action.categoryName != filters.category) {
        return false;
      }
      if (filters.tags.isNotEmpty &&
          !filters.tags.any((t) => action.tags.contains(t))) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        return action.title.toLowerCase().contains(q) ||
            action.categoryName.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    // Tri
    return list..sort(
      (a, b) => switch (filters.sortBy) {
        'points_desc' => b.impactScore.compareTo(a.impactScore),
        'points_asc' => a.impactScore.compareTo(b.impactScore),
        'difficulty' => _weight(a.difficulty).compareTo(_weight(b.difficulty)),
        _ => 0,
      },
    );
  }

  int _weight(String diff) => switch (diff.toLowerCase()) {
    'facile' => 0,
    'moyen' || 'moyenne' => 1,
    'difficile' => 2,
    _ => 3,
  };
}
