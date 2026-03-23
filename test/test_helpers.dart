import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> signInDemoUser(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).at(0), 'ari@dtable.app');
  await tester.enterText(find.byType(TextField).at(1), 'password123');
  await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
  await tester.pumpAndSettle();
}

Future<void> goToProfile(WidgetTester tester) async {
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();
}

Future<void> goToBookings(WidgetTester tester) async {
  await tester.tap(find.text('Bookings'));
  await tester.pumpAndSettle();
}

Future<void> enterSearch(WidgetTester tester, String value) async {
  await tester.enterText(find.byType(TextFormField), value);
  await tester.pumpAndSettle();
}
