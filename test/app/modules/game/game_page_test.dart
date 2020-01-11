import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular_test.dart';

import 'package:desafio_campo_minado/app/modules/game/game_page.dart';

main() {
  testWidgets('GamePage has title', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(GamePage(title: 'Game')));
    final titleFinder = find.text('Game');
    expect(titleFinder, findsOneWidget);
  });
}
