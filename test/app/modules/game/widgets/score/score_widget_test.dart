import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular_test.dart';

import 'package:desafio_campo_minado/app/modules/game/widgets/score/score_widget.dart';

main() {
  testWidgets('ScoreWidget has message', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(ScoreWidget()));
    final textFinder = find.text('Score');
    expect(textFinder, findsOneWidget);
  });
}
