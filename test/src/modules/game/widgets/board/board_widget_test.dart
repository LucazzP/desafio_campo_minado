import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular_test.dart';

import 'package:desafio_campo_minado/src/modules/game/widgets/board/board_widget.dart';

main() {
  testWidgets('BoardWidget has message', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(BoardWidget()));
    final textFinder = find.text('Board');
    expect(textFinder, findsOneWidget);
  });
}
