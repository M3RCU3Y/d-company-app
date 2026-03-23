import 'package:d_table/app/app.dart';
import 'package:d_table/app/app_services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('profile changes can be saved and notification tools are reachable', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await signInDemoUser(tester);
    await goToProfile(tester);

    await tester.enterText(find.byType(TextField).at(0), 'Ari Updated');
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile updated.'), findsOneWidget);

    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();

    expect(find.text('Notification center'), findsOneWidget);
  });

  testWidgets('restaurant dashboard can approve a pending reservation', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await signInDemoUser(tester);
    await goToProfile(tester);

    await tester.tap(find.text('Restaurant mode'));
    await tester.pumpAndSettle();

    expect(find.text('Estate 101'), findsOneWidget);
    await tester.tap(find.text('Approve').first);
    await tester.pumpAndSettle();

    expect(find.text('Confirmed'), findsWidgets);
  });

  testWidgets('admin can approve a pending restaurant', (tester) async {
    final services = AppServices.bootstrap();
    addTearDown(services.dispose);

    await tester.pumpWidget(DTableApp(services: services));
    await tester.pumpAndSettle();
    await signInDemoUser(tester);
    await goToProfile(tester);

    await tester.tap(find.text('Admin mode'));
    await tester.pumpAndSettle();

    expect(find.text('Harbor Flame'), findsOneWidget);
    await tester.tap(find.text('Approve').first);
    await tester.pumpAndSettle();

    expect(find.text('Harbor Flame'), findsNothing);
  });
}
