import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/auth_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final agreeToTerms = true.obs;
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  final _apiClient = Get.find<ApiClient>();
  final _authService = Get.find<AuthService>();

  void togglePasswordVisibility() => obscurePassword.toggle();
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.toggle();
  void toggleAgreeToTerms() => agreeToTerms.toggle();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> register() async {
    final fullName = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      errorMessage.value = 'All fields are required.';
      return;
    }

    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match.';
      return;
    }

    if (password.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters.';
      return;
    }

    if (!agreeToTerms.value) {
      errorMessage.value = 'Please agree to the terms and conditions.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final nameParts = fullName.split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        },
      );

      // Write success flag to storage — LoginController reads and clears it on init
      GetStorage().write('_reg_success_msg', 'Account created! Please log in to continue.');

      // Simple navigation — no arguments, no timing dependency
      Get.offAllNamed('/login');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Registration failed. Please try again.';
      errorMessage.value = msg;
    } catch (e) {
      errorMessage.value = 'Connection error. Please check your network.';
    } finally {
      isLoading.value = false;
    }
  }
}
