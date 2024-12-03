// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lesson6/main.dart';
import 'package:lesson6/view/Studentpage_screen.dart';

void main() {
  testWidgets('Department dropdown selection updates correctly',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(
      home: StudentpageScreen(),
    ));

    // Verify initial state (no selected department)
    expect(find.text('Select Department'), findsOneWidget);
    expect(find.text('Computer Science'), findsNothing);

    // Open the dropdown and select a department
    await tester.tap(find.text('Select Department'));
    await tester.pumpAndSettle();

    // Tap the "Computer Science" option
    await tester.tap(find.text('Computer Science').last);
    await tester.pumpAndSettle();

    // Verify that "Computer Science" is now displayed
    expect(find.text('Computer Science'), findsOneWidget);
  });
}
