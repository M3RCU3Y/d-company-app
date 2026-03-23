import 'package:d_table/app/app.dart';
import 'package:d_table/app/app_services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('reservation flow opens form, validates slot selection, and submits', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await signInDemoUser(tester);

    await tester.tap(find.text('Estate 101'));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Reserve for'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send reservation request'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a reservation time before sending your request.'), findsOneWidget);

    await tester.tap(find.textContaining('seats left').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send reservation request'));
    await tester.pumpAndSettle();

    expect(find.text('Reservation request sent.'), findsOneWidget);
    expect(find.text('Upcoming bookings'), findsOneWidget);
  });
}
