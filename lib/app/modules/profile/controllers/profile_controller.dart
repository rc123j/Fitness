import 'package:get/get.dart';

class ProfileController extends GetxController {
  final username = "Arjun Mehta".obs;
  final userClass = "NutriFit Member".obs;
  final streakCount = 45.obs;

  // Stats
  final workoutsCount = 68.obs;
  final mealsLogged = 134.obs;
  final weightChange = (-5.2).obs;
  final fitPoints = 2450.obs;

  // Premium status
  final isPremium = true.obs;

  // Progress metrics for rings
  final weightVal = 72.8.obs;
  final bodyFatVal = 16.2.obs;
  final muscleMassVal = 34.5.obs;
  final bmiVal = 23.4.obs;

  // Preferences
  final isMetric = true.obs;
  final notificationsEnabled = true.obs;
  final remindersEnabled = true.obs;

  void toggleMetricImperial() {
    isMetric.value = !isMetric.value;
  }

  void logout() {
    // Clear credentials or routing to login
    Get.offAllNamed('/login');
  }
}
