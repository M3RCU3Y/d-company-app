import 'package:d_table/app/app_services.dart';
import 'package:d_table/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('app boots into auth then home shell and navigation works', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsWidgets);

    await signInDemoUser(tester);

    expect(find.text('D Table'), findsOneWidget);

    await goToBookings(tester);
    expect(find.text('Upcoming bookings'), findsOneWidget);

    await goToProfile(tester);
    expect(find.text('Account details'), findsOneWidget);
  });
}
