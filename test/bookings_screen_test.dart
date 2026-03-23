import 'package:d_table/app/app.dart';
import 'package:d_table/app/app_services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('bookings render seeded data and cancellation moves booking out of upcoming', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await signInDemoUser(tester);

    await goToBookings(tester);

    expect(find.text('Estate 101'), findsOneWidget);

    await tester.tap(find.text('Cancel').first);
    await tester.pumpAndSettle();

    expect(find.text('Estate 101'), findsNothing);

    await tester.tap(find.text('Past'));
    await tester.pumpAndSettle();

    expect(find.text('Estate 101'), findsOneWidget);
  });
}
