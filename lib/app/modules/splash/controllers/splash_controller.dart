import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/onboarding_draft_service.dart';
import '../../goal/views/goal_selection_screen.dart';
import '../../goal/views/physical_metrics_screen.dart';
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

    if (_authService.isOnboardingDone) {
      Get.offAllNamed('/main-navigation');
    } else {
      // Resume from whatever step the user reached before the restart
      _resumeOnboarding();
    }
  }

  /// Navigates straight to the screen matching the last saved onboarding step.
  void _resumeOnboarding() {
    final step = OnboardingDraftService.lastStep;
    final d = OnboardingDraftService.getDraft();

    if (step <= 1 || (d['goalTitle'] as String).isEmpty) {
      // No draft or only goal step touched — start fresh
      Get.offAllNamed('/goal-selection');
      return;
    }

    // Helper to safely extract values
    final goalTitle   = d['goalTitle']  as String;
    final goalId      = d['goalId']     as int;
    final gender      = d['gender']     as String;
    final age         = d['age']        as int;
    final height      = d['height']     as int;
    final weight      = d['weight']     as double;
    final actId       = d['activityLevelId']   as int;
    final actName     = d['activityLevelName'] as String;
    final tasteIds    = d['tastePreferenceIds'] as List<int>;
    final dietLabel   = d['dietLabel']  as String;
    final foodExcl    = d['foodExclusions'] as List<String>;
    final condIds     = d['medicalConditionIds'] as List<int>;
    final smoking     = d['smokingHabit'] as String;
    final alcohol     = d['alcoholHabit'] as String;

    switch (step) {
      case 1:
        // Step 1 saved — resume at Step 2 (physical metrics)
        Get.offAll(
          () => PhysicalMetricsScreen(goalTitle: goalTitle, goalId: goalId),
          transition: Transition.fadeIn,
        );
        break;

      case 2:
        // Step 2 saved — resume at Step 3 (activity level)
        Get.offAll(
          () => ActivityLevelScreen(
            goalTitle: goalTitle,
            goalId: goalId,
            gender: gender,
            age: age,
            height: height,
            weight: weight,
          ),
          transition: Transition.fadeIn,
        );
        break;

      case 3:
        // Step 3 saved — resume at Step 4 (dietary preferences)
        Get.offAll(
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
          transition: Transition.fadeIn,
        );
        break;

      case 4:
        // Step 4 saved — resume at Step 5 (health profile)
        Get.offAll(
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
            dietLabel: dietLabel.isEmpty ? 'Standard' : dietLabel,
            foodExclusions: foodExcl,
          ),
          transition: Transition.fadeIn,
        );
        break;

      case 5:
        // Step 5 saved — resume at Step 6 (lifestyle habits)
        Get.offAll(
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
            dietLabel: dietLabel.isEmpty ? 'Standard' : dietLabel,
            foodExclusions: foodExcl,
            medicalConditionIds: condIds,
          ),
          transition: Transition.fadeIn,
        );
        break;

      case 6:
        // Step 6 saved — resume at Step 7 (screening report)
        Get.offAll(
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
            dietLabel: dietLabel.isEmpty ? 'Standard' : dietLabel,
            foodExclusions: foodExcl,
            medicalConditionIds: condIds,
            symptomIds: const [],
            customConditions: const [],
            smokingHabit: smoking,
            alcoholHabit: alcohol,
          ),
          transition: Transition.fadeIn,
        );
        break;

      default:
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
