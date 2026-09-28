import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions/domain/entities/excluded_preference.dart';
import 'package:oikos/features/actions/domain/repositories/action_repository.dart';
import 'package:oikos/features/profile/presentation/widgets/excluded_actions_sheet.dart';

class PreferencesRepository implements ActionRepository {
  bool fail = true;
  String? restoredUser;
  final item = const ExcludedPreference(
    ExclusionKind.category,
    'Transport',
    'Transport',
  );
  @override
  Future<Either<Failure, List<ExcludedPreference>>> getExcludedPreferences(
    String userId,
  ) async => right([item]);
  @override
  Future<Either<Failure, void>> restoreExcludedPreference(
    String userId,
    ExcludedPreference preference,
  ) async {
    restoredUser = userId;
    return fail ? left(Failure('Connexion indisponible')) : right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'restoration retains the preference on failure and removes it after success',
    (tester) async {
      final repository = PreferencesRepository();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExcludedActionsSheet(repository: repository, userId: 'alice'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rétablir'));
      await tester.pumpAndSettle();
      expect(find.text('Connexion indisponible'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
      repository.fail = false;
      await tester.tap(find.text('Rétablir'));
      await tester.pumpAndSettle();
      expect(repository.restoredUser, 'alice');
      expect(find.text('Transport'), findsNothing);
      expect(find.text('Aucune préférence écartée.'), findsOneWidget);
    },
  );
}
