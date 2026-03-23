import 'package:d_table/app/app.dart';
import 'package:d_table/app/app_services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('bookings render seeded data and cancellation moves booking out of upcoming', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);
    await primeSignedInServices(services);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();

    await goToBookings(tester);
    await scrollToInListView(tester, find.text('Maracas Tide'));

    expect(find.text('Maracas Tide'), findsOneWidget);

    await scrollToInListView(tester, find.text('Cancel'));
    await tester.tap(find.text('Cancel').first, warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel booking'));
    await tester.pumpAndSettle();

    expect(find.text('Maracas Tide'), findsNothing);

    await scrollToInListView(tester, find.text('Past'));
    await tester.tap(find.text('Past'));
    await tester.pumpAndSettle();

    expect(find.text('Maracas Tide'), findsOneWidget);
  });
}
