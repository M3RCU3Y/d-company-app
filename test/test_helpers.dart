import 'package:d_table/app/app_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> signInDemoUser(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).at(0), 'ari@dtable.app');
  await tester.enterText(find.byType(TextField).at(1), 'password123');
  await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
  await tester.pumpAndSettle();
}

Future<void> primeSignedInServices(AppServices services) async {
  await services.authController.signIn(
    email: 'ari@dtable.app',
    password: 'password123',
  );
  await services.discoverController.initialize();
  await services.bookingsController.refresh();
  await services.profileController.initialize();
  await services.favoritesController.initialize();
  await services.restaurantDashboardController.initialize();
  await services.adminController.refresh();
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

Future<void> scrollToInCustomScrollView(
  WidgetTester tester,
  Finder target,
) async {
  final scrollables = find.byType(CustomScrollView);
  if (scrollables.evaluate().isEmpty) {
    return;
  }

  for (var index = 0; index < 10; index++) {
    if (target.evaluate().isNotEmpty) {
      await tester.ensureVisible(target.first);
      await tester.pumpAndSettle();
      break;
    }
    await tester.drag(scrollables.first, const Offset(0, -350));
    await tester.pumpAndSettle();
  }
}

Future<void> scrollToInListView(
  WidgetTester tester,
  Finder target,
) async {
  final scrollables = find.byType(ListView);
  if (scrollables.evaluate().isEmpty) {
    return;
  }

  for (var index = 0; index < 10; index++) {
    if (target.evaluate().isNotEmpty) {
      await tester.ensureVisible(target.first);
      await tester.pumpAndSettle();
      break;
    }
    await tester.drag(scrollables.first, const Offset(0, -300));
    await tester.pumpAndSettle();
  }
}
