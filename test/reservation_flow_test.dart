import 'package:d_table/app/app.dart';
import 'package:d_table/app/app_services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('reservation flow opens form, validates slot selection, and submits', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);
    await primeSignedInServices(services);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();

    await scrollToInCustomScrollView(tester, find.text('Estate 101'));
    await tester.tap(find.text('Estate 101'), warnIfMissed: false);
    await tester.pumpAndSettle();

    await scrollToInCustomScrollView(tester, find.textContaining('Reserve for'));
    await tester.tap(find.textContaining('Reserve for'), warnIfMissed: false);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send reservation request'));
    await tester.pumpAndSettle();
    expect(find.text('Reserve a table'), findsOneWidget);
    expect(find.text('Send reservation request'), findsOneWidget);

    await scrollToInListView(tester, find.textContaining('seats left'));
    await tester.tap(find.textContaining('seats left').first, warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Send request for'));
    await tester.pumpAndSettle();

    expect(find.text('Request sent'), findsOneWidget);
    await tester.tap(find.text('View bookings'));
    await tester.pumpAndSettle();

    expect(find.text('Upcoming bookings'), findsOneWidget);
  });
}
