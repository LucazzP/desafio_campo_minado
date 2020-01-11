import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular_test.dart';

import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_widget.dart';

main() {
  testWidgets('SquareWidget has message', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(SquareWidget()));
    final textFinder = find.text('Square');
    expect(textFinder, findsOneWidget);
  });
}
