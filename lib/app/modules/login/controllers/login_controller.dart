import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  // Password visibility toggle
  final obscurePassword = true.obs;
  void togglePasswordVisibility() => obscurePassword.toggle();

  // One-shot success message (written by RegisterController, read once here, cleared immediately)
  // Plain String — NOT reactive — no Obx binding = zero chance of crash during navigation
  String? successMessage;

  final _apiClient = Get.find<ApiClient>();
  final _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    // Read the one-shot registration success flag from storage
    final storage = GetStorage();
    final msg = storage.read<String>('_reg_success_msg');
    if (msg != null) {
      successMessage = msg;
      storage.remove('_reg_success_msg'); // clear immediately so it never shows again
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email and password are required.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data;
      _authService.saveSession(
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
        userId: data['user']['id'],
        email: data['user']['email'],
        role: data['user']['role'],
        isOnboarded: data['user']['isOnboarded'] ?? false,
      );

      if (_authService.isOnboardingDone) {
        Get.offAllNamed('/main-navigation');
      } else {
        Get.offAllNamed('/goal-selection');
      }
    } on DioException catch (e) {
      debugPrint("DioException occurred during login: $e");
      String msg = 'Login failed. Please try again.';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          msg = data['message'] ?? msg;
        } else if (data is String) {
          if (data.trim().startsWith('<')) {
            msg = 'Server returned an invalid response (HTML Error).';
          } else {
            msg = data;
          }
        }
      } else {
        msg = 'Connection error: ${e.message ?? e.type.toString()}';
      }
      errorMessage.value = msg;
    } catch (e, stack) {
      debugPrint("Generic error occurred during login: $e");
      debugPrint(stack.toString());
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
