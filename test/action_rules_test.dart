import 'package:flutter_test/flutter_test.dart';
import 'package:oikos/features/actions/domain/entities/action_entity.dart';
import 'package:oikos/features/actions/domain/entities/filter_data.dart';
import 'package:oikos/features/actions/domain/util/actions_filter_handler.dart';

ActionEntity action(
  String id,
  String difficulty,
  int xp, {
  String category = 'Transport',
  String frequency = 'quotidienne',
}) => ActionEntity(
  id: id,
  title: 'Action $id',
  description: '',
  categoryName: category,
  difficulty: difficulty,
  impactScore: xp,
  iconName: 'bike',
  tips: [],
  frequency: frequency,
  tags: ['sans voiture'],
);
void main() {
  test(
    'difficulty sorting handles database values without mutating catalog',
    () {
      final actions = [
        action('hard', 'difficile', 50),
        action('easy', 'facile', 10),
        action('medium', 'moyenne', 20),
      ];
      expect(
        actions
            .applyFilters(
              searchQuery: '',
              filters: FilterData(sortBy: 'difficulty'),
            )
            .map((a) => a.id),
        ['easy', 'medium', 'hard'],
      );
      expect(actions.first.id, 'hard');
    },
  );
  test('search, category, frequency and tags are combined', () {
    final actions = [
      action('bike', 'facile', 10),
      action('food', 'facile', 20, category: 'Alimentation'),
      action('train', 'moyenne', 30, frequency: 'mensuelle'),
    ];
    final filtered = actions.applyFilters(
      searchQuery: 'BIKE',
      filters: FilterData(
        category: 'Transport',
        frequency: 'quotidienne',
        tags: {'sans voiture'},
      ),
    );
    expect(filtered.map((a) => a.id), ['bike']);
    expect(
      actions.applyFilters(searchQuery: 'unknown', filters: FilterData()),
      isEmpty,
    );
  });
  test('ranking by impact uses the canonical score', () {
    final actions = [
      action('low', 'facile', 10),
      action('high', 'difficile', 50),
    ];
    expect(
      actions
          .applyFilters(
            searchQuery: '',
            filters: FilterData(sortBy: 'points_desc'),
          )
          .first
          .id,
      'high',
    );
  });
}
