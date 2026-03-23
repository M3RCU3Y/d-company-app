import 'package:d_table/app/app.dart';
import 'package:d_table/app/app_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('profile changes can be saved and notification tools are reachable', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);
    await primeSignedInServices(services);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await goToProfile(tester);

    final nameField = find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == 'Name',
    );
    await scrollToInListView(tester, nameField);
    await tester.enterText(nameField, 'Ari Updated');
    await scrollToInListView(tester, find.text('Save profile'));
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile updated.'), findsOneWidget);

    await scrollToInListView(tester, find.text('Notifications'));
    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();

    expect(find.text('Notification center'), findsOneWidget);
  });

  testWidgets('restaurant dashboard can approve a pending reservation', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);
    await primeSignedInServices(services);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await goToProfile(tester);

    await scrollToInListView(tester, find.text('Restaurant mode'));
    await tester.tap(find.text('Restaurant mode'));
    await tester.pumpAndSettle();

    expect(find.text('Estate 101'), findsOneWidget);
    await scrollToInListView(tester, find.text('Approve'));
    await tester.tap(find.text('Approve').first);
    await tester.pumpAndSettle();

    expect(find.text('Confirmed'), findsWidgets);
  });

  testWidgets('admin can approve a pending restaurant', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);
    await primeSignedInServices(services);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await goToProfile(tester);

    await scrollToInListView(tester, find.text('Admin mode'));
    await tester.tap(find.text('Admin mode'));
    await tester.pumpAndSettle();

    await scrollToInListView(tester, find.text('Harbor Flame'));
    expect(find.text('Harbor Flame'), findsOneWidget);
    await scrollToInListView(tester, find.text('Approve'));
    await tester.tap(find.text('Approve').first);
    await tester.pumpAndSettle();

    expect(find.text('Harbor Flame'), findsNothing);
  });
}
