import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class SplashController extends GetxController {
  final _authService = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_authService.isLoggedIn) {
      if (_authService.isOnboardingDone) {
        Get.offAllNamed('/main-navigation');
      } else {
        Get.offAllNamed('/goal-selection');
      }
    } else {
      Get.offAllNamed('/login');
    }
  }
}
