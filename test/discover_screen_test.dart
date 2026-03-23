import 'package:d_table/app/app.dart';
import 'package:d_table/app/app_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('discover search filters by name, cuisine, and location', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await signInDemoUser(tester);

    expect(find.text('Estate 101'), findsOneWidget);
    expect(find.text('Maracas Tide'), findsOneWidget);

    await enterSearch(tester, 'Seafood');

    expect(find.text('Maracas Tide'), findsOneWidget);
    expect(find.text('Estate 101'), findsNothing);
  });

  testWidgets('discover empty state appears when no matches are found', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await signInDemoUser(tester);

    await enterSearch(tester, 'Nowhere');

    expect(find.text('No restaurants match this search.'), findsOneWidget);
  });

  testWidgets('favorite toggle updates discover card state', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await signInDemoUser(tester);

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border_rounded), findsWidgets);
  });
}
