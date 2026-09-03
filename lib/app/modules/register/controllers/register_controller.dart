import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/auth_service.dart';
import '../../../services/onboarding_draft_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralCodeController = TextEditingController();

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final agreeToTerms = true.obs;
  final isLoading = false.obs;
  final isValidatingCode = false.obs;
  final isReferralCodeValid = false.obs;
  final referralStatusMessage = Rxn<String>();
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
    referralCodeController.dispose();
    super.onClose();
  }

  Future<void> validateReferralCode() async {
    final code = referralCodeController.text.trim();
    if (code.isEmpty) {
      referralStatusMessage.value = null;
      isReferralCodeValid.value = false;
      return;
    }

    isValidatingCode.value = true;
    referralStatusMessage.value = null;

    try {
      final res = await _apiClient.post(
        ApiEndpoints.validateReferral,
        data: {'referral_code': code},
      );
      if (res.statusCode == 200 && res.data != null && res.data['valid'] == true) {
        isReferralCodeValid.value = true;
        referralStatusMessage.value = '✓ ${res.data['message']} (+50 FitPoints)';
      } else {
        isReferralCodeValid.value = false;
        referralStatusMessage.value = res.data?['message'] ?? 'Invalid referral code.';
      }
    } catch (e) {
      isReferralCodeValid.value = false;
      referralStatusMessage.value = 'Invalid referral code. Please check.';
    } finally {
      isValidatingCode.value = false;
    }
  }

  Future<void> register() async {
    final fullName = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final referralCode = referralCodeController.text.trim();

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

      final data = <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      };

      if (referralCode.isNotEmpty) {
        data['referral_code'] = referralCode;
        OnboardingDraftService.saveReferralCode(referralCode);
      }

      await _apiClient.post(
        ApiEndpoints.register,
        data: data,
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
