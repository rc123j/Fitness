import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/auth_service.dart';

class ProfileController extends GetxController {
  final _apiClient = Get.find<ApiClient>();
  final _authService = Get.find<AuthService>();

  final isLoading = true.obs;
  final username = ''.obs;
  final userClass = 'NutriFit Member'.obs;
  final email = ''.obs;
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

    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      final data = response.data;
      final profile = data['profile'];
      final user = profile['user'];

      username.value = '${user['first_name']} ${user['last_name']}';
      email.value = user['email'] ?? '';
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
}
