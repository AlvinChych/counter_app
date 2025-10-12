// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:counter_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counting up and down updates the display', (tester) async {
    await tester.pumpWidget(const CounterApp());

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('+'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('−'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('−'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Reset requires confirmation before clearing tally', (tester) async {
    await tester.pumpWidget(const CounterApp());

    await tester.tap(find.text('+'));
    await tester.pump();
    await tester.tap(find.text('+'));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.restart_alt));
    await tester.pumpAndSettle();
    expect(find.text('Reset counter?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.restart_alt));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reset'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
  });
}
