import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter/material.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

// Index of the Home tab inside MainNavigationView's IndexedStack.
const int _kHomeTabIndex = 0;

class HomeController extends GetxController {
  final _apiClient = Get.find<ApiClient>();
  Worker? _tabWorker;

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

  // Search bar query — filters homeMeals by meal type/food name.
  final mealSearchQuery = ''.obs;

  List<Map<String, dynamic>> get filteredHomeMeals {
    final query = mealSearchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return homeMeals;
    return homeMeals.where((meal) {
      final title = (meal['title'] ?? '').toString().toLowerCase();
      final desc = (meal['desc'] ?? '').toString().toLowerCase();
      return title.contains(query) || desc.contains(query);
    }).toList();
  }

  // Swiggy-style tab navigation state
  final activeTab = 0.obs; // 0 = Meal, 1 = Workout

  // Real-time progress trackers
  final currentCalories = 0.obs;
  final targetCalories = 2000.obs;
  final currentProtein = 0.obs;
  final targetProtein = 150.obs;
  final currentCarbs = 0.obs;
  final targetCarbs = 200.obs;
  final currentFat = 0.obs;
  final targetFat = 65.obs;
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

    // Home is kept alive inside an IndexedStack, so it never rebuilds/
    // refetches on its own when the user switches back to it. Re-fetch
    // (silently, no shimmer) whenever it becomes the active tab so changes
    // made elsewhere (e.g. marking a meal complete on the Meal tab) show up
    // without needing an app restart.
    if (Get.isRegistered<MainNavigationController>()) {
      _tabWorker = ever<int>(
        Get.find<MainNavigationController>().selectedIndex,
        (index) {
          if (index == _kHomeTabIndex) fetchProfile(silent: true);
        },
      );
    }
  }

  @override
  void onClose() {
    _tabWorker?.dispose();
    super.onClose();
  }

  Future<void> fetchProfile({bool silent = false}) async {
    if (!silent) {
      isLoading.value = true;
    }

    try {
      // Execute network requests concurrently for maximum speed
      final results = await Future.wait<dynamic>([
        _apiClient.get(ApiEndpoints.profile).catchError((_) => null as dynamic),
        _apiClient
            .get(ApiEndpoints.currentDietPlan)
            .catchError((_) => null as dynamic),
        _apiClient
            .get(ApiEndpoints.todayNutritionLog)
            .catchError((_) => null as dynamic),
        _apiClient
            .get(ApiEndpoints.progressLog)
            .catchError((_) => null as dynamic),
      ]);

      final profileRes = results[0] as Response?;
      final planRes = results[1] as Response?;
      final nutRes = results[2] as Response?;
      final progRes = results[3] as Response?;

      // 1. Process member profile
      if (profileRes?.data != null && profileRes!.data is Map) {
        final data = profileRes.data;
        final profile = data['profile'];
        final latestMetrics = data['latest_metrics'];

        if (profile != null && profile['user'] != null) {
          final user = profile['user'];
          userName.value = '${user['first_name']} ${user['last_name']}';
          memberCode.value = profile['member_code'] ?? '';
          goalName.value = profile['goal']?['goal_name'] ?? '';
          final rawGoal = goalName.value;
          if (rawGoal.toLowerCase().contains("athletic")) {
            planName.value = "Athletic Plan";
          } else if (rawGoal.isNotEmpty) {
            planName.value = rawGoal.toLowerCase().endsWith("plan")
                ? rawGoal
                : "$rawGoal Plan";
          } else {
            planName.value = "Fat Loss Plan";
          }
          activityLevel.value = profile['activity_level']?['title'] ?? '';
          currentLevel.value = profile['wallet']?['current_level'] ?? 'Bronze';
          fitPoints.value = profile['wallet']?['fit_points'] ?? 0;
          currentStreak.value = profile['wallet']?['current_streak'] ?? 0;
          currentWeight.value =
              double.tryParse(profile['weight_kg']?.toString() ?? '0.0') ?? 0.0;
          metrics = latestMetrics;
        }
      }

      // 2. Process current diet plan details
      List tempMeals = [];
      if (planRes != null && planRes.data != null && planRes.data is Map) {
        planDayNumber.value = planRes.data['current_day'] ?? 1;
        planDaysRemaining.value = planRes.data['days_remaining'] ?? 30;

        final List mealsList =
            planRes.data['diet_plan']?['diet_plan_meals'] ?? [];
        totalMealsToday.value = mealsList.isNotEmpty ? mealsList.length : 5;
        tempMeals = mealsList;
      }

      // 3. Process today's nutrition log
      List<int> loggedIds = [];
      if (nutRes != null && nutRes.data != null && nutRes.data is Map) {
        final nutData = nutRes.data;
        currentCalories.value =
            (nutData['consumed']?['calories'] as num?)?.toInt() ?? 0;
        targetCalories.value =
            (nutData['targets']?['calories'] as num?)?.toInt() ?? 2000;
        currentProtein.value =
            (nutData['consumed']?['protein'] as num?)?.toInt() ?? 0;
        targetProtein.value =
            (nutData['targets']?['protein'] as num?)?.toInt() ?? 150;
        currentCarbs.value =
            (nutData['consumed']?['carbs'] as num?)?.toInt() ?? 0;
        targetCarbs.value =
            (nutData['targets']?['carbs'] as num?)?.toInt() ?? 200;
        currentFat.value = (nutData['consumed']?['fat'] as num?)?.toInt() ?? 0;
        targetFat.value = (nutData['targets']?['fat'] as num?)?.toInt() ?? 65;

        final List rawLogged = nutData['logged_meal_ids'] ?? [];
        loggedIds = rawLogged
            .map((id) => int.tryParse(id?.toString() ?? ''))
            .whereType<int>()
            .toList();
        mealsCompletedToday.value = loggedIds.length;
      }

      // Map homeMeals timeline list from fetched diet plan meals & today's logs
      homeMeals.clear();
      final List<Map<String, dynamic>> tempHomeMeals = [];
      for (var meal in tempMeals) {
        final mealTypeName = meal['meal_type']?['name'] ?? 'Meal';
        final List foods = meal['foods'] ?? [];
        final String foodDesc = foods
            .map((f) => f['food_details']?['food_name'] ?? '')
            .join(', ');

        double protein = 0.0;
        double carbs = 0.0;
        double fat = 0.0;
        double calories = 0.0;

        // Foods carry multiple exchange options (option 1, 2, 3...) inside
        // their `notes` metadata; the Meal screen only totals the selected
        // option (option 1 by default). Summing every food here would double
        // (or triple) count and disagree with what the Meal screen shows.
        for (var f in foods) {
          int opt = 1;
          final String? notes = f['notes']?.toString();
          if (notes != null && notes.isNotEmpty) {
            try {
              final Map<String, dynamic> meta = jsonDecode(notes);
              opt = int.tryParse(meta['option']?.toString() ?? '1') ?? 1;
            } catch (_) {}
          }
          if (opt != 1) continue;

          calories += double.tryParse(f['calories']?.toString() ?? '0') ?? 0;
          protein += double.tryParse(f['protein']?.toString() ?? '0') ?? 0;
          carbs += double.tryParse(f['carbs']?.toString() ?? '0') ?? 0;
          fat += double.tryParse(f['fat']?.toString() ?? '0') ?? 0;
        }

        final int mealId = int.tryParse(meal['meal_id']?.toString() ?? '') ?? 1;
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
      const mealDisplayOrder = {1: 0, 2: 1, 3: 2, 6: 3, 7: 4, 4: 5, 5: 6};
      tempHomeMeals.sort((a, b) {
        final aOrder = mealDisplayOrder[a['meal_id'] as int] ?? 99;
        final bOrder = mealDisplayOrder[b['meal_id'] as int] ?? 99;
        return aOrder.compareTo(bOrder);
      });
      homeMeals.value = tempHomeMeals;

      // 4. Process progress logs history
      if (progRes != null && progRes.data != null && progRes.data is Map) {
        final progData = progRes.data;
        weightDifference.value =
            (progData['weight_difference_kg'] as num?)?.toDouble() ?? 0.0;

        final List logs = progData['logs'] ?? [];
        if (logs.isNotEmpty) {
          // Parse weights and dates for line chart
          weightHistoryLogs.clear();
          final recentLogs = logs.length > 5
              ? logs.sublist(logs.length - 5)
              : logs;
          final months = [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
          ];

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
              final double w =
                  double.tryParse(log['weight_kg']?.toString() ?? '0.0') ?? 0.0;
              if (w > 0) {
                weightHistoryLogs.add({
                  "date": label.isNotEmpty ? label : "Log",
                  "weight": w,
                });
              }
            } catch (_) {}
          }
        }

        // Fill dynamic fallback log entries to keep weight chart look good
        if (weightHistoryLogs.isEmpty) {
          weightHistoryLogs.addAll([
            {
              "date": "Start",
              "weight": currentWeight.value > 0 ? currentWeight.value : 70.0,
            },
            {
              "date": "Today",
              "weight": currentWeight.value > 0 ? currentWeight.value : 70.0,
            },
          ]);
        }
      }
    } catch (_) {
      // Keep defaults
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: Function to mark a meal as eaten
  void markMealAsEaten(int mealId, double kcal, double p, double c, double f) {
    // 1. Find meal and mark as completed
    final index = homeMeals.indexWhere((m) => m['meal_id'] == mealId);
    if (index != -1) {
      final updatedMeal = Map<String, dynamic>.from(homeMeals[index]);
      updatedMeal['tag'] = 'Completed';
      homeMeals[index] = updatedMeal;
    }

    // 2. Add macros
    currentCalories.value += kcal.toInt();
    currentProtein.value += p.toInt();
    currentCarbs.value += c.toInt();
    currentFat.value += f.toInt();

    // Note: A real app would make a POST request to an API here
  }
}
