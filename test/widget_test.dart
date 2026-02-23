import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_hero_score.dart';

void main() {
  testWidgets('BilanHeroScore renders formatted tonnes and objective', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BilanHeroScore(
            scoreKg: 2500,
            objectifLabel: 'Objectif 2050 : 2 t/an',
          ),
        ),
      ),
    );

    expect(find.text('Ton empreinte annuelle'), findsOneWidget);
    expect(find.text('2,5'), findsOneWidget);
    expect(find.text('tonnes CO₂e / an'), findsOneWidget);
    expect(find.text('Objectif 2050 : 2 t/an'), findsOneWidget);
  });
}
