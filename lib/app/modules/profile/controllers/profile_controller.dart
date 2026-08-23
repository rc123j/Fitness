import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/auth_service.dart';

class ProfileController extends GetxController {
  final _apiClient = Get.find<ApiClient>();
  final _authService = Get.find<AuthService>();

  final isLoading = true.obs;
  final username = ''.obs;
  final userClass = 'Nutri Shape Member'.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final memberCode = ''.obs;
  final goalName = ''.obs;
  final fitPoints = 0.obs;
  final currentLevel = ''.obs;
  final streakCount = 0.obs;

  // Stats
  final workoutsCount = 0.obs;
  final mealsLogged = 0.obs;
  final weightChange = 0.0.obs;

  // Preferences
  final isMetric = true.obs;
  final notificationsEnabled = true.obs;
  final remindersEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Artificial delay for shimmer

    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      final data = response.data;
      final profile = data['profile'];
      final user = profile['user'];

      username.value = '${user['first_name']} ${user['last_name']}';
      email.value = user['email'] ?? '';
      phone.value = user['phone'] ?? '';
      memberCode.value = profile['member_code'] ?? '';
      goalName.value = profile['goal']?['goal_name'] ?? '';
      currentLevel.value = profile['wallet']?['current_level'] ?? 'Bronze';
      fitPoints.value = profile['wallet']?['fit_points'] ?? 0;
    } on DioException catch (_) {
      // Keep defaults
    } catch (_) {
      // Keep defaults
    } finally {
      isLoading.value = false;
    }
  }

  void toggleMetricImperial() {
    isMetric.value = !isMetric.value;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (_) {}
    await _authService.logout();
  }

  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      await _apiClient.delete(ApiEndpoints.deleteAccount);
      Get.snackbar(
        "Account Deleted",
        "Your account has been permanently deleted.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF00E5),
        colorText: Colors.white,
      );
      await _authService.logout(); // log them out after deletion
    } on DioException catch (e) {
      Get.snackbar(
        "Error",
        e.response?.data['message'] ??
            "Failed to delete account. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    isLoading.value = true;
    try {
      await _apiClient.post(
        ApiEndpoints.changePassword,
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
      return true;
    } on DioException catch (e) {
      Get.snackbar(
        "Error",
        e.response?.data['message'] ??
            "Failed to change password. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfileDetails({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.put(
        ApiEndpoints.profile,
        data: {'first_name': firstName, 'last_name': lastName, 'phone': phone},
      );

      // Update local values
      final profile = response.data['profile'];
      final user = profile['user'];
      username.value = '${user['first_name']} ${user['last_name']}';
      email.value = user['email'] ?? '';

      return true;
    } on DioException catch (e) {
      Get.snackbar(
        "Error",
        e.response?.data['message'] ??
            "Failed to update profile. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
