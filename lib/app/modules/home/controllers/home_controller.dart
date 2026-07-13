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

  // Real-time progress trackers
  final currentCalories = 0.obs;
  final targetCalories = 2000.obs;
  final currentWater = 0.0.obs; // In Liters
  final targetWater = 3.0.obs;  // In Liters
  final currentSteps = 0.obs;
  final targetSteps = 10000.obs;
  final currentWeight = 0.0.obs;
  final weightDifference = 0.0.obs; // weight loss/gain tracking

  Map<String, dynamic>? metrics;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;

    try {
      // 1. Fetch member profile
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
      currentWeight.value = double.tryParse(profile['weight_kg']?.toString() ?? '0.0') ?? 0.0;
      metrics = latestMetrics;

      // 2. Fetch today's calorie / macronutrient aggregates
      try {
        final nutRes = await _apiClient.get(ApiEndpoints.todayNutritionLog);
        final nutData = nutRes.data;
        currentCalories.value = (nutData['consumed']?['calories'] as num?)?.toInt() ?? 0;
        targetCalories.value = (nutData['targets']?['calories'] as num?)?.toInt() ?? 2000;
      } catch (_) {}

      // 3. Fetch today's water logging aggregates
      try {
        final waterRes = await _apiClient.get(ApiEndpoints.todayWaterLog);
        final waterData = waterRes.data;
        final ml = (waterData['amount_ml'] as num?)?.toDouble() ?? 0.0;
        final tgtMl = (waterData['target_ml'] as num?)?.toDouble() ?? 3000.0;
        currentWater.value = ml / 1000.0;
        targetWater.value = tgtMl / 1000.0;
      } catch (_) {}

      // 4. Fetch progress logs history (weight delta, step count)
      try {
        final progRes = await _apiClient.get(ApiEndpoints.progressLog);
        final progData = progRes.data;
        weightDifference.value = (progData['weight_difference_kg'] as num?)?.toDouble() ?? 0.0;
        
        final List logs = progData['logs'] ?? [];
        if (logs.isNotEmpty) {
          final todayStr = DateTime.now().toIso8601String().split('T')[0];
          final todayLog = logs.firstWhere(
            (l) => l['logged_date'] == todayStr,
            orElse: () => null,
          );
          if (todayLog != null) {
            currentSteps.value = (todayLog['steps'] as num?)?.toInt() ?? 0;
          } else {
            currentSteps.value = 0;
          }
        } else {
          currentSteps.value = 0;
        }
      } catch (_) {}

    } on DioException catch (_) {
      // Keep defaults
    } catch (_) {
      // Keep defaults
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addWater(double amountLiters) async {
    try {
      final amountMl = (amountLiters * 1000).toInt();
      await _apiClient.post(ApiEndpoints.logWater, data: {'amount_ml': amountMl});
      // Optimistically update UI
      final newVal = currentWater.value + amountLiters;
      currentWater.value = newVal > targetWater.value ? targetWater.value : newVal;
    } catch (_) {}
  }

  Future<void> addSteps(int stepsToAdd) async {
    try {
      final newSteps = currentSteps.value + stepsToAdd;
      await _apiClient.post(ApiEndpoints.logSteps, data: {'steps': newSteps});
      currentSteps.value = newSteps;
    } catch (_) {}
  }
}
