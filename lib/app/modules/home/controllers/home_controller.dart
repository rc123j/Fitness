import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';

class HomeController extends GetxController {
  final _apiClient = Get.find<ApiClient>();

  final isLoading = true.obs;
  final userName = ''.obs;
  final memberCode = ''.obs;
  final goalName = ''.obs;
  final activityLevel = ''.obs;
  final currentLevel = ''.obs;
  final fitPoints = 0.obs;
  final currentStreak = 0.obs;
  final homeMeals = <Map<String, dynamic>>[].obs;
  final weightHistoryLogs = <Map<String, dynamic>>[].obs;

  // Real-time progress trackers
  final currentCalories = 0.obs;
  final targetCalories = 2000.obs;
  final currentWater = 0.0.obs; // In Liters
  final targetWater = 3.0.obs;  // In Liters
  final currentSteps = 0.obs;
  final targetSteps = 10000.obs;
  final currentWeight = 0.0.obs;
  final weightDifference = 0.0.obs; // weight loss/gain tracking

  // Goal Plan and Meal Aggregates
  final planName = ''.obs;
  final planDayNumber = 1.obs;
  final planDaysRemaining = 30.obs;
  final mealsCompletedToday = 0.obs;
  final totalMealsToday = 5.obs;

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
      planName.value = goalName.value.isNotEmpty ? "${goalName.value} Plan" : "Fat Loss Plan";
      activityLevel.value = profile['activity_level']?['title'] ?? '';
      currentLevel.value = profile['wallet']?['current_level'] ?? 'Bronze';
      fitPoints.value = profile['wallet']?['fit_points'] ?? 0;
      currentStreak.value = profile['wallet']?['current_streak'] ?? 0;
      currentWeight.value = double.tryParse(profile['weight_kg']?.toString() ?? '0.0') ?? 0.0;
      metrics = latestMetrics;

      // 2. Fetch current diet plan details for day/days remaining tracking
      List tempMeals = [];
      try {
        final planRes = await _apiClient.get(ApiEndpoints.currentDietPlan);
        planDayNumber.value = planRes.data['current_day'] ?? 1;
        planDaysRemaining.value = planRes.data['days_remaining'] ?? 30;
        
        final List mealsList = planRes.data['diet_plan']?['diet_plan_meals'] ?? [];
        totalMealsToday.value = mealsList.isNotEmpty ? mealsList.length : 5;
        tempMeals = mealsList;
      } catch (_) {}

      // 3. Fetch today's calorie / macronutrient aggregates & completed meals count
      List loggedIds = [];
      try {
        final nutRes = await _apiClient.get(ApiEndpoints.todayNutritionLog);
        final nutData = nutRes.data;
        currentCalories.value = (nutData['consumed']?['calories'] as num?)?.toInt() ?? 0;
        targetCalories.value = (nutData['targets']?['calories'] as num?)?.toInt() ?? 2000;
        
        loggedIds = nutData['logged_meal_ids'] ?? [];
        mealsCompletedToday.value = loggedIds.length;
      } catch (_) {}

      // Map homeMeals timeline list from fetched diet plan meals & today's logs
      homeMeals.clear();
      final List<Map<String, dynamic>> tempHomeMeals = [];
      for (var meal in tempMeals) {
        final mealTypeName = meal['meal_type']?['name'] ?? 'Meal';
        final List foods = meal['foods'] ?? [];
        final String foodDesc = foods.map((f) => f['food_details']?['food_name'] ?? '').join(', ');

        double protein = 0.0;
        double carbs = 0.0;
        double fat = 0.0;
        double calories = 0.0;

        for (var f in foods) {
          calories += double.tryParse(f['calories']?.toString() ?? '0') ?? 0;
          protein += double.tryParse(f['protein']?.toString() ?? '0') ?? 0;
          carbs += double.tryParse(f['carbs']?.toString() ?? '0') ?? 0;
          fat += double.tryParse(f['fat']?.toString() ?? '0') ?? 0;
        }

        final int mealId = meal['meal_id'] ?? 1;
        final bool isCompleted = loggedIds.contains(mealId);

        // Icon and color mapping per meal type
        var color = const Color(0xffFF7A00);
        var icon = Icons.restaurant_rounded;
        if (mealTypeName == 'Breakfast') {
          color = const Color(0xff00FF87);
          icon = Icons.emoji_food_beverage_rounded;
        } else if (mealTypeName == 'Lunch') {
          color = const Color(0xffFF7A00);
          icon = Icons.lunch_dining_rounded;
        } else if (mealTypeName == 'Dinner') {
          color = const Color(0xffFF3E3E);
          icon = Icons.soup_kitchen_rounded;
        } else {
          color = const Color(0xffB100FF);
          icon = Icons.local_drink_rounded;
        }

        tempHomeMeals.add({
          "meal_id": mealId,
          "title": mealTypeName,
          "desc": foodDesc.isNotEmpty ? foodDesc : "No foods assigned",
          "kcal": "${calories.toInt()} kcal",
          "macros": "${protein.toInt()}P • ${carbs.toInt()}C • ${fat.toInt()}F",
          "tag": isCompleted ? "Completed" : "Pending",
          "color": color,
          "icon": icon,
        });
      }
      tempHomeMeals.sort((a, b) => (a['meal_id'] as int).compareTo(b['meal_id'] as int));
      homeMeals.value = tempHomeMeals;

      // 4. Fetch today's water logging aggregates
      try {
        final waterRes = await _apiClient.get(ApiEndpoints.todayWaterLog);
        final waterData = waterRes.data;
        final ml = (waterData['amount_ml'] as num?)?.toDouble() ?? 0.0;
        final tgtMl = (waterData['target_ml'] as num?)?.toDouble() ?? 3000.0;
        currentWater.value = ml / 1000.0;
        targetWater.value = tgtMl / 1000.0;
      } catch (_) {}

      // 5. Fetch progress logs history (weight delta, step count)
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

          // Parse weights and dates for line chart
          weightHistoryLogs.clear();
          final recentLogs = logs.length > 5 ? logs.sublist(logs.length - 5) : logs;
          final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
          
          for (var log in recentLogs) {
            try {
              final String fullDate = log['logged_date'] ?? '';
              String label = '';
              if (fullDate.isNotEmpty) {
                final parts = fullDate.split('-');
                if (parts.length == 3) {
                  final dayVal = int.tryParse(parts[2]) ?? 1;
                  final monthVal = int.tryParse(parts[1]) ?? 1;
                  label = "$dayVal ${months[monthVal - 1]}";
                }
              }
              final double w = double.tryParse(log['weight_kg']?.toString() ?? '0.0') ?? 0.0;
              if (w > 0) {
                weightHistoryLogs.add({
                  "date": label.isNotEmpty ? label : "Log",
                  "weight": w,
                });
              }
            } catch (_) {}
          }
        } else {
          currentSteps.value = 0;
        }

        // Fill dynamic fallback log entries to keep weight chart look good
        if (weightHistoryLogs.isEmpty) {
          weightHistoryLogs.addAll([
            {"date": "Start", "weight": currentWeight.value > 0 ? currentWeight.value : 70.0},
            {"date": "Today", "weight": currentWeight.value > 0 ? currentWeight.value : 70.0},
          ]);
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
