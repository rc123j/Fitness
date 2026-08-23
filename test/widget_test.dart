import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutri_shape/app/modules/splash/views/splash_view.dart';
import 'package:nutri_shape/app/modules/splash/controllers/splash_controller.dart';
import 'package:nutri_shape/app/services/auth_service.dart';

class MockAuthService extends GetxService implements AuthService {
  @override
  bool get isLoggedIn => false;

  @override
  bool get isOnboardingDone => false;

  @override
  String? get userRole => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('SplashView loads successfully as initial route', (WidgetTester tester) async {
    // Register the mock services needed for SplashView
    Get.put<AuthService>(MockAuthService());
    Get.put(SplashController());

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        home: const SplashView(),
        getPages: [
          GetPage(
            name: '/login',
            page: () => const SizedBox(),
          ),
        ],
      ),
    );

    // Verify that the splash screen loads and displays the tagline
    expect(find.text('FUEL YOUR BEST SELF'), findsOneWidget);

    // Settle splash navigation timers to avoid pending timer errors
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}
