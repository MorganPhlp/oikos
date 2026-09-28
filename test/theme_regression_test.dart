import 'package:flutter/material.dart';
import 'package:oikos/core/common/presentation/widgets/theme_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oikos/core/common/cubits/theme/theme_cubit.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/core/theme/action_card_theme.dart';
import 'package:oikos/core/theme/oikos_button_theme.dart';
import 'package:oikos/features/admin/presentation/widget/global_vue_page/category_breakdown.dart';

void main() {
  test('shared themes provide mobile and administration semantics', () {
    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      final admin = theme.extension<AdminColors>()!;
      expect(admin.primary, theme.colorScheme.primary);
      expect(admin.foreground, theme.colorScheme.onSurface);
      expect(theme.extension<ActionCardTheme>(), isNotNull);
      expect(theme.extension<OikosButtonTheme>(), isNotNull);
    }
  });
  testWidgets('theme toggle updates shared colors and empty statistics', (
    tester,
  ) async {
    final cubit = ThemeCubit();
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) => MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            home: Scaffold(
              body: Column(
                children: [
                  const ThemeSelector(),
                  const CategoryBreakdown(data: []),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('Aucun bilan détaillé disponible.'), findsOneWidget);
    await tester.tap(find.text('Système'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sombre').last);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(CategoryBreakdown))).brightness,
      Brightness.dark,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await cubit.close();
  });
}
