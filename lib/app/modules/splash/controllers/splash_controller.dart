import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/onboarding_draft_service.dart';
import '../../goal/views/goal_selection_screen.dart';
import '../../goal/views/gender_screen.dart';
import '../../goal/views/age_screen.dart';
import '../../goal/views/height_screen.dart';
import '../../goal/views/weight_screen.dart';
import '../../goal/views/activity_level_screen.dart';
import '../../goal/views/dietary_preferences_screen.dart';
import '../../goal/views/health_profile_screen.dart';
import '../../goal/views/lifestyle_habits_screen.dart';
import '../../goal/views/screening_report_screen.dart';

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
    final isValid = await _validateTokenWithServer();
    if (!isValid) {
      await _authService.clearSession();
      Get.offAllNamed('/login');
      return;
    }

    if (_authService.userRole == 'CONSULTANT' || _authService.userRole == 'ADMIN') {
      _authService.setOnboardingDone(true);
      Get.offAllNamed('/main-navigation');
      return;
    }

    if (_authService.isOnboardingDone) {
      Get.offAllNamed('/main-navigation');
    } else {
      // Resume from whatever step the user reached before the restart
      _resumeOnboarding();
    }
  }

  /// Rebuilds the full screen stack up to the last saved onboarding step,
  /// so the back button has real history to pop through instead of landing
  /// on a screen with an empty navigation stack (Get.offAll wipes history).
  Future<void> _resumeOnboarding() async {
    final step = OnboardingDraftService.lastStep;
    final d = OnboardingDraftService.getDraft();

    if (step <= 1 || (d['goalTitle'] as String).isEmpty) {
      // No draft or only goal step touched — start fresh
      Get.offAllNamed('/goal-selection');
      return;
    }

    // Helper to safely extract values
    final goalTitle = d['goalTitle'] as String;
    final goalId = d['goalId'] as int;
    final gender = d['gender'] as String;
    final age = d['age'] as int;
    final height = d['height'] as int;
    final weight = d['weight'] as double;
    final actId = d['activityLevelId'] as int;
    final actName = d['activityLevelName'] as String;
    final tasteIds = d['tastePreferenceIds'] as List<int>;
    final dietLabel = d['dietLabel'] as String;
    final foodExcl = d['foodExclusions'] as List<String>;
    final condIds = d['medicalConditionIds'] as List<int>;
    final smoking = d['smokingHabit'] as String;
    final alcohol = d['alcoholHabit'] as String;
    final resolvedDietLabel = dietLabel.isEmpty ? 'Standard' : dietLabel;

    // Ordered chain of every onboarding screen. Index N is the screen
    // resumed at when `step == N` was the last one saved.
    final List<Widget Function()> chain = [
      () => const GoalSelectionScreen(),
      () => GenderScreen(goalTitle: goalTitle, goalId: goalId),
      () => AgeScreen(goalTitle: goalTitle, goalId: goalId, gender: gender),
      () => HeightScreen(
        goalTitle: goalTitle,
        goalId: goalId,
        gender: gender,
        age: age,
      ),
      () => WeightScreen(
        goalTitle: goalTitle,
        goalId: goalId,
        gender: gender,
        age: age,
        height: height,
      ),
      () => ActivityLevelScreen(
        goalTitle: goalTitle,
        goalId: goalId,
        gender: gender,
        age: age,
        height: height,
        weight: weight,
      ),
      () => DietaryPreferencesScreen(
        goalTitle: goalTitle,
        goalId: goalId,
        gender: gender,
        age: age,
        height: height,
        weight: weight,
        activityLevelId: actId,
        activityLevelName: actName,
      ),
      () => HealthProfileScreen(
        goalTitle: goalTitle,
        goalId: goalId,
        gender: gender,
        age: age,
        height: height,
        weight: weight,
        activityLevelId: actId,
        activityLevelName: actName,
        tastePreferenceIds: tasteIds,
        dietLabel: resolvedDietLabel,
        foodExclusions: foodExcl,
      ),
      () => LifestyleHabitsScreen(
        goalTitle: goalTitle,
        goalId: goalId,
        gender: gender,
        age: age,
        height: height,
        weight: weight,
        activityLevelId: actId,
        activityLevelName: actName,
        tastePreferenceIds: tasteIds,
        dietLabel: resolvedDietLabel,
        foodExclusions: foodExcl,
        medicalConditionIds: condIds,
      ),
      () => ScreeningReportScreen(
        goalTitle: goalTitle,
        goalId: goalId,
        gender: gender,
        age: age,
        height: height,
        weight: weight,
        activityLevelId: actId,
        activityLevelName: actName,
        tastePreferenceIds: tasteIds,
        dietLabel: resolvedDietLabel,
        foodExclusions: foodExcl,
        medicalConditionIds: condIds,
        symptomIds: const [],
        customConditions: const [],
        smokingHabit: smoking,
        alcoholHabit: alcohol,
      ),
    ];

    if (step < 1 || step >= chain.length) {
      Get.offAllNamed('/goal-selection');
      return;
    }

    Get.offAll(chain[0], transition: Transition.noTransition);
    for (var i = 1; i <= step; i++) {
      Get.to(chain[i], transition: Transition.noTransition);
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
