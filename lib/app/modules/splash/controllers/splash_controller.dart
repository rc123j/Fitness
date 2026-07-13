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
    if (!_authService.isLoggedIn) {
      await Future.delayed(const Duration(milliseconds: 3500));
      Get.offAllNamed('/login');
      return;
    }

    if (_authService.isOnboardingDone) {
      Get.offAllNamed('/main-navigation');
    } else {
      Get.offAllNamed('/goal-selection');
    }
  }
}
