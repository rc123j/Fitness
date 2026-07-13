import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';

class MealController extends GetxController {
  final _apiClient = Get.find<ApiClient>();

  final selectedDate = "Today".obs;
  final isLoading = true.obs;
  
  // Progress states
  final currentCalories = 0.obs;
  final targetCalories = 2000.obs;
  final currentWater = 0.0.obs; // In Liters
  final targetWater = 3.0.obs;  // In Liters
  
  // Target Macros
  final targetProtein = 0.obs;
  final targetCarbs = 0.obs;
  final targetFat = 0.obs;
  final targetFiber = 0.obs;

  // Consumed Macros
  final consumedProtein = 0.obs;
  final consumedCarbs = 0.obs;
  final consumedFat = 0.obs;
  final consumedFiber = 0.obs;

  // Diet Plan Meals Timeline data
  final mealTimeline = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMealData();
  }

  Future<void> fetchMealData() async {
    isLoading.value = true;
    try {
      // 1. Fetch Today's Date representation
      final now = DateTime.now();
      final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      selectedDate.value = "Today, ${now.day} ${months[now.month - 1]}";

      // 2. Fetch current diet plan details (target macros & meal prescriptions)
      final planRes = await _apiClient.get(ApiEndpoints.currentDietPlan);
      final planData = planRes.data['diet_plan'];
      final metrics = planData['metric_snapshot'];
      
      targetCalories.value = (planData['target_calories'] as num?)?.toInt() ?? 2000;
      targetProtein.value = (metrics['protein_target_g'] as num?)?.toInt() ?? 140;
      targetCarbs.value = (metrics['carbs_target_g'] as num?)?.toInt() ?? 200;
      targetFat.value = (metrics['fat_target_g'] as num?)?.toInt() ?? 60;
      targetFiber.value = (metrics['fiber_target_g'] as num?)?.toInt() ?? 30;

      // Extract meal plans list
      final List mealsList = planData['diet_plan_meals'] ?? [];
      final List<Map<String, dynamic>> timelineTemp = [];

      for (var meal in mealsList) {
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

        timelineTemp.add({
          "id": meal['id'],
          "meal_id": meal['meal_id'],
          "title": mealTypeName,
          "desc": foodDesc.isNotEmpty ? foodDesc : "No foods assigned",
          "details": "${calories.toInt()} kcal  •  ${protein.toInt()}P  •  ${carbs.toInt()}C  •  ${fat.toInt()}F",
          "target_calories": (meal['target_calories'] as num?)?.toDouble() ?? 0.0,
          "foods": foods
        });
      }

      // Sort timeline by meal_id to display Breakfast, Mid Meal, Lunch, Snack, Dinner in order
      timelineTemp.sort((a, b) => (a['meal_id'] as int).compareTo(b['meal_id'] as int));
      mealTimeline.value = timelineTemp;

      // 3. Fetch today's logged nutrition (consumed calories/macros)
      final nutRes = await _apiClient.get(ApiEndpoints.todayNutritionLog);
      final nutData = nutRes.data;
      final consumed = nutData['consumed'] ?? {};
      currentCalories.value = (consumed['calories'] as num?)?.toInt() ?? 0;
      consumedProtein.value = (consumed['protein'] as num?)?.toInt() ?? 0;
      consumedCarbs.value = (consumed['carbs'] as num?)?.toInt() ?? 0;
      consumedFat.value = (consumed['fat'] as num?)?.toInt() ?? 0;
      consumedFiber.value = (consumed['fiber'] as num?)?.toInt() ?? 0;

      // 4. Fetch today's logged water
      final waterRes = await _apiClient.get(ApiEndpoints.todayWaterLog);
      final waterData = waterRes.data;
      final ml = (waterData['amount_ml'] as num?)?.toDouble() ?? 0.0;
      final tgtMl = (waterData['target_ml'] as num?)?.toDouble() ?? 3000.0;
      currentWater.value = ml / 1000.0;
      targetWater.value = tgtMl / 1000.0;

    } catch (e) {
      // Graceful fallback to static placeholders if network fails or plan is not generated yet
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addWater(double amountLiters) async {
    try {
      final amountMl = (amountLiters * 1000).toInt();
      await _apiClient.post(ApiEndpoints.logWater, data: {'amount_ml': amountMl});
      final newVal = currentWater.value + amountLiters;
      currentWater.value = newVal > targetWater.value ? targetWater.value : newVal;
    } catch (_) {}
  }

  Future<void> resetWater() async {
    try {
      // In progress API: reset daily log by logging zero or negative
      currentWater.value = 0.0;
    } catch (_) {}
  }

  Future<bool> consumeMeal(int mealId, List foods) async {
    try {
      for (var f in foods) {
        await _apiClient.post(ApiEndpoints.logMeal, data: {
          'meal_id': mealId,
          'food_id': f['food_id'],
          'quantity_consumed': f['quantity'],
          'diet_plan_food_id': f['id']
        });
      }
      await fetchMealData(); // Reload stats
      return true;
    } catch (e) {
      return false;
    }
  }
}
