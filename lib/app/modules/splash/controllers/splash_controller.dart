import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/auth_service.dart';

class SplashController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _apiClient = Get.find<ApiClient>();

  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!_authService.isLoggedIn) {
      // No token at all — fresh install or logged out
      Get.offAllNamed('/login');
      return;
    }

    // Token exists — verify onboarding status from backend (source of truth)
    try {
      final response = await _apiClient.get('/api/members/profile');
      // Profile exists → onboarding is complete
      _authService.setOnboardingDone(true);
      Get.offAllNamed('/main-navigation');
    } catch (e) {
      // Profile not found (404) → onboarding incomplete
      // Any other error (401 expired token) → api_client auto-handles refresh
      // If refresh also fails → api_client calls logout() → token is cleared
      if (_authService.isLoggedIn) {
        // Still logged in → 404, no profile → send to onboarding
        _authService.setOnboardingDone(false);
        Get.offAllNamed('/goal-selection');
      } else {
        // Token was cleared by api_client (expired + refresh failed) → login
        Get.offAllNamed('/login');
      }
    }
  }
}
