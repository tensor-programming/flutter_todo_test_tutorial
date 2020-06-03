// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_todo/main.dart';

void main() {
  group('Find by Type', () {
    testWidgets('Test to see that MaterialApp widget is in tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Test to see that CircularProgressIndicator widget is in tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MyHomePage(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Application Logic', () {
    testWidgets('Add a todo', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MyHomePage(),
        ),
      );

      final textFinder = find.byKey(Key('todo-field'));
      final addButtonFinder = find.byKey(Key('add-todo'));

      await tester.enterText(textFinder, 'A sample todo');

      await tester.tap(addButtonFinder);

      await tester.pump();

      expect(find.text('A sample todo'), findsOneWidget);
      expect(find.byKey(ValueKey('0-todo')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Remove a todo', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MyHomePage(),
        ),
      );
      final textFinder = find.byKey(Key('todo-field'));
      final addButtonFinder = find.byKey(Key('add-todo'));
      final removeTodoFinder = find.byKey(Key('gd-0'));

      await tester.enterText(textFinder, 'A sample todo');

      await tester.tap(addButtonFinder);

      await tester.pump();

      expect(find.text('A sample todo'), findsOneWidget);

      await tester.longPress(removeTodoFinder);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNothing);
    });

    testWidgets('Finish a todo', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MyHomePage(),
        ),
      );
      final textFinder = find.byKey(Key('todo-field'));
      final addButtonFinder = find.byKey(Key('add-todo'));
      final todoFinder = find.byKey(ValueKey('0-false-checkbox'));

      await tester.enterText(textFinder, 'A sample todo');

      await tester.tap(addButtonFinder);

      await tester.pump();

      await tester.enterText(textFinder, 'Another todo');

      await tester.tap(addButtonFinder);

      await tester.pump();

      await tester.tap(todoFinder);

      await tester.pump();

      expect(find.text('A sample todo'), findsOneWidget);
      expect(find.text('Another todo'), findsOneWidget);
      expect(find.byKey(ValueKey('0-true-checkbox')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
