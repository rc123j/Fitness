import 'package:dio/dio.dart';
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
      if (response.statusCode == 200) {
        // A 200 response confirms the user is authenticated and has a Member profile created (onboarding complete).
        _authService.setOnboardingDone(true);
        return true;
      }
      return true;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      // Only 401 (Unauthorized) or 403 (Forbidden) indicate an invalid or expired token.
      if (statusCode == 401 || statusCode == 403) {
        return false;
      }
      // Status code 404 indicates the user is logged in, but has not completed onboarding yet
      // (no Member profile row created in DB). We must return true to preserve their login session!
      // Any other error (network timeouts, offline, connection refused, 500 errors) should NOT force a logout.
      return true;
    } catch (e) {
      // For general timeout exceptions or any other unexpected errors, give the benefit of doubt and stay logged in.
      return true;
    }
  }
}
