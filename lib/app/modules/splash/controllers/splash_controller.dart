import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';

class SplashController extends GetxController {
  final _authService = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    // Always show splash for at least 2s
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!_authService.isLoggedIn) {
      Get.offAllNamed('/login');
      return;
    }

    // Token exists locally — verify it is still valid on the backend.
    // If the user was deleted from the DB or the token expired, this will
    // return a 401/error and we force them back to login.
    final isValid = await _validateTokenWithServer();
    if (!isValid) {
      await _authService.clearSession();
      Get.offAllNamed('/login');
      return;
    }

    if (_authService.isOnboardingDone) {
      Get.offAllNamed('/main-navigation');
    } else {
      Get.offAllNamed('/goal-selection');
    }
  }

  Future<bool> _validateTokenWithServer() async {
    try {
      final apiClient = Get.find<ApiClient>();
      // Use a short 5s timeout — we don't want the splash to hang.
      final response = await apiClient
          .get(ApiEndpoints.profile)
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } on Exception catch (e) {
      final msg = e.toString().toLowerCase();
      // If the server is simply unreachable (offline / wrong IP / server down),
      // don't block the user — let them through and let the next real API call
      // handle auth. Only hard 401/403 responses should force a logout.
      if (msg.contains('timeout') ||
          msg.contains('connection refused') ||
          msg.contains('network') ||
          msg.contains('socketexception')) {
        return true; // Server unreachable ≠ invalid user, give benefit of doubt
      }
      // For 401 / 403 or other clear auth failures, invalidate.
      return false;
    }
  }
}
