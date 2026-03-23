import 'package:d_table/app/app.dart';
import 'package:d_table/app/app_services.dart';
import 'package:d_table/core/presentation/widgets/restaurant_media_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('discover search filters by name, cuisine, and location', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);
    await primeSignedInServices(services);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();

    services.discoverController.setQuery('Port of Spain');
    await tester.pumpAndSettle();
    await scrollToInCustomScrollView(tester, find.text('Estate 101'));
    expect(find.text('Estate 101'), findsOneWidget);
    expect(find.text('Maracas Tide'), findsNothing);

    services.discoverController.setQuery('Seafood');
    await tester.pumpAndSettle();
    await scrollToInCustomScrollView(tester, find.text('Maracas Tide'));
    expect(find.text('Maracas Tide'), findsOneWidget);
    expect(find.text('Estate 101'), findsNothing);

    services.discoverController.setQuery('Estate');
    await tester.pumpAndSettle();
    await scrollToInCustomScrollView(tester, find.text('Estate 101'));
    expect(find.text('Estate 101'), findsOneWidget);
    expect(find.text('Maracas Tide'), findsNothing);
  });

  testWidgets('discover empty state appears when no matches are found', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);
    await primeSignedInServices(services);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();

    await enterSearch(tester, 'Nowhere');
    await scrollToInCustomScrollView(
      tester,
      find.text('No restaurants match this search.'),
    );

    expect(find.text('No restaurants match this search.'), findsOneWidget);
  });

  testWidgets('favorite toggle updates discover card state', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);
    await primeSignedInServices(services);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();

    await scrollToInCustomScrollView(tester, find.text('Estate 101'));
    final estateCard = find.ancestor(
      of: find.text('Estate 101'),
      matching: find.byType(RestaurantMediaCard),
    );
    final favoriteIcon = find.descendant(
      of: estateCard,
      matching: find.byIcon(Icons.favorite_rounded),
    );

    expect(favoriteIcon, findsOneWidget);

    await tester.ensureVisible(favoriteIcon);
    await tester.tap(favoriteIcon, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border_rounded), findsWidgets);
  });
}
