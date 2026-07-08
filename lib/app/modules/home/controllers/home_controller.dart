import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/auth_service.dart';

class HomeController extends GetxController {
  final _apiClient = Get.find<ApiClient>();
  final _authService = Get.find<AuthService>();

  final isLoading = true.obs;
  final userName = ''.obs;
  final memberCode = ''.obs;
  final goalName = ''.obs;
  final activityLevel = ''.obs;
  final currentLevel = ''.obs;
  final fitPoints = 0.obs;

  Map<String, dynamic>? metrics;

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
      final latestMetrics = data['latest_metrics'];

      final user = profile['user'];
      userName.value = '${user['first_name']} ${user['last_name']}';
      memberCode.value = profile['member_code'] ?? '';
      goalName.value = profile['goal']?['goal_name'] ?? '';
      activityLevel.value = profile['activity_level']?['title'] ?? '';
      currentLevel.value = profile['wallet']?['current_level'] ?? 'Bronze';
      fitPoints.value = profile['wallet']?['fit_points'] ?? 0;
      metrics = latestMetrics;
    } on DioException catch (_) {
      // Keep defaults
    } catch (_) {
      // Keep defaults
    } finally {
      isLoading.value = false;
    }
  }
}
