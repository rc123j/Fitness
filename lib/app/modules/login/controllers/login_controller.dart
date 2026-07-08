import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  final _apiClient = Get.find<ApiClient>();
  final _authService = Get.find<AuthService>();

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
      );

      if (_authService.isOnboardingDone) {
        Get.offAllNamed('/main-navigation');
      } else {
        Get.offAllNamed('/goal-selection');
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Login failed. Please try again.';
      errorMessage.value = msg;
    } catch (e) {
      errorMessage.value = 'Connection error. Please check your network.';
    } finally {
      isLoading.value = false;
    }
  }
}
