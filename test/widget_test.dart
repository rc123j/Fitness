import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:fitness/app/routes/app_pages.dart';

void main() {
  testWidgets('SplashView loads successfully as initial route', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );

    // Verify that the splash screen loads and displays the tagline
    expect(find.text('FUEL YOUR BEST SELF'), findsOneWidget);
  });
}
