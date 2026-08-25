import 'dart:convert';
import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../home/controllers/home_controller.dart';
import '../../progress/controllers/progress_controller.dart';

class MealController extends GetxController {
  final _apiClient = Get.find<ApiClient>();

  final selectedQueryDate = "".obs;
  final selectedDate = "Today".obs;
  final isLoading = true.obs;

  // Offset (in weeks) of the calendar strip from the week containing today.
  // 0 = current week, 1 = next week, -1 = previous week, etc.
  final weekOffset = 0.obs;

  // Progress states
  final currentCalories = 0.obs;
  final targetCalories = 2000.obs;
  final currentWater = 0.0.obs; // In Liters
  final targetWater = 3.0.obs; // In Liters

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

  // AI Insights (parsed from the diet plan's ai_insights_json — see fetchMealData)
  final aiInsights = <String, dynamic>{}.obs;
  final selectedInsightTab = 0.obs;

  List<String> get adviceList =>
      (aiInsights['advice'] as List?)?.map((e) => e.toString()).toList() ?? [];

  List<Map<String, dynamic>> get diseaseGuidance =>
      (aiInsights['disease_guidance'] as List?)
          ?.whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList() ??
      [];

  Map<String, dynamic>? get priorityNutrients =>
      aiInsights['priority_nutrients'] is Map
          ? Map<String, dynamic>.from(aiInsights['priority_nutrients'])
          : null;

  Map<String, dynamic>? get suggestedProteinPowder =>
      aiInsights['suggested_protein_powder'] is Map
          ? Map<String, dynamic>.from(aiInsights['suggested_protein_powder'])
          : null;

  List<Map<String, dynamic>> get suggestedFiberFoods =>
      (aiInsights['suggested_fiber_foods'] as List?)
          ?.whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList() ??
      [];

  Map<String, dynamic>? get lifeStageGuidance =>
      aiInsights['life_stage_guidance'] is Map
          ? Map<String, dynamic>.from(aiInsights['life_stage_guidance'])
          : null;

  Map<String, dynamic>? get macroAchieved =>
      aiInsights['macro_achieved'] is Map
          ? Map<String, dynamic>.from(aiInsights['macro_achieved'])
          : null;

  String get accuracyNote => aiInsights['accuracy_note']?.toString() ?? '';

  Map<String, dynamic>? get anthropometrics =>
      aiInsights['anthropometrics'] is Map
          ? Map<String, dynamic>.from(aiInsights['anthropometrics'])
          : null;

  // Track selected option (1, 2, 3, 4) for each meal slot (key is dietPlanMealId)
  final selectedOptions = <int, int>{}.obs;

  // Track current day in the 30-day rotation
  final currentDay = 1.obs;

  // Set of completed meal_ids (1=Breakfast, etc.) for today
  final completedMealIds = <int>{}.obs;

  // Track expanded state for each meal slot (dietPlanMealId)
  final expandedMealIds = <int>{}.obs;

  // Calorie & Nutrition history logging
  final calorieHistoryList = <Map<String, dynamic>>[].obs;
  final historyTargetCalories = 2000.obs;
  final historyAverageCalories = 0.obs;
  final historyAdherenceRate = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMealData();
    fetchCalorieHistory();
  }

  Future<void> fetchMealData({bool silent = false}) async {
    if (!silent) isLoading.value = true;
    if (!silent)
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Artificial delay for shimmer
    try {
      final queryParam = selectedQueryDate.value.isNotEmpty
          ? "?date=${selectedQueryDate.value}"
          : "";

      // 1. Fetch current diet plan details (target macros & meal prescriptions)
      final planRes = await _apiClient.get(
        "${ApiEndpoints.currentDietPlan}$queryParam",
      );

      if (planRes.data != null) {
        currentDay.value = planRes.data['current_day'] ?? 1;

        final planData = planRes.data['diet_plan'];
        if (planData != null) {
          
          if (planData['ai_insights_json'] != null) {
            try {
              final parsed = planData['ai_insights_json'] is String
                  ? jsonDecode(planData['ai_insights_json'])
                  : planData['ai_insights_json'];
              aiInsights.value = Map<String, dynamic>.from(parsed);
            } catch (e) {
              aiInsights.clear();
            }
          } else {
            aiInsights.clear();
          }
          // Avoid landing on a stale tab index if the available sections
          // differ for this day (e.g. fewer tabs shown).
          selectedInsightTab.value = 0;

          final metrics = planData['metric_snapshot'];

          targetCalories.value =
              double.tryParse(
                planData['target_calories']?.toString() ?? '',
              )?.toInt() ??
              2000;
          if (metrics != null) {
            targetProtein.value =
                double.tryParse(
                  metrics['protein_target_g']?.toString() ?? '',
                )?.toInt() ??
                140;
            targetCarbs.value =
                double.tryParse(
                  metrics['carbs_target_g']?.toString() ?? '',
                )?.toInt() ??
                200;
            targetFat.value =
                double.tryParse(
                  metrics['fat_target_g']?.toString() ?? '',
                )?.toInt() ??
                60;
            targetFiber.value =
                double.tryParse(
                  metrics['fiber_target_g']?.toString() ?? '',
                )?.toInt() ??
                30;
          } else {
            // Default targets if metrics snapshot is missing
            targetProtein.value = 140;
            targetCarbs.value = 200;
            targetFat.value = 60;
            targetFiber.value = 30;
          }

          // Extract meal plans list
          final List mealsList = planData['diet_plan_meals'] ?? [];
          final List<Map<String, dynamic>> timelineTemp = [];

          for (var meal in mealsList) {
            if (meal == null) continue;
            final int dietPlanMealId =
                int.tryParse(meal['id']?.toString() ?? '') ?? 0;
            selectedOptions.putIfAbsent(dietPlanMealId, () => 1);
            expandedMealIds.add(
              dietPlanMealId,
            ); // meal cards are expanded by default

            final mealTypeName = meal['meal_type']?['name'] ?? 'Meal';
            final List foods = meal['foods'] ?? [];

            // Group foods by option index (1, 2, 3) parsed from notes JSON
            final Map<int, List<dynamic>> optionFoods = {1: [], 2: [], 3: []};
            for (var f in foods) {
              if (f == null) continue;
              int opt = 1;
              final String? notes = f['notes']?.toString();
              if (notes != null && notes.isNotEmpty) {
                try {
                  final Map<String, dynamic> meta = jsonDecode(notes);
                  opt = int.tryParse(meta['option']?.toString() ?? '1') ?? 1;
                } catch (_) {}
              }
              optionFoods.putIfAbsent(opt, () => []).add(f);
            }

            timelineTemp.add({
              "id": dietPlanMealId,
              "meal_id":
                  int.tryParse(meal['meal_id']?.toString() ?? '') ??
                  1, // meal_type ID
              "title": mealTypeName,
              "optionFoods": optionFoods,
              "target_calories":
                  double.tryParse(meal['target_calories']?.toString() ?? '') ??
                  0.0,
            });
          }

          // Sort timeline by logical meal display order:
          // Breakfast(1) → Mid Meal(2) → Lunch(3) → Pre-Workout(6) → Post-Workout(7) → Evening Snack(4) → Dinner(5)
          const mealDisplayOrder = {1: 0, 2: 1, 3: 2, 6: 3, 7: 4, 4: 5, 5: 6};
          timelineTemp.sort((a, b) {
            final aOrder = mealDisplayOrder[a['meal_id'] ?? 1] ?? 99;
            final bOrder = mealDisplayOrder[b['meal_id'] ?? 1] ?? 99;
            return aOrder.compareTo(bOrder);
          });
          mealTimeline.value = timelineTemp;
        }
      }

      // Update selected date header dynamically with Day info
      final now = DateTime.now();
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

      if (selectedQueryDate.value.isNotEmpty) {
        final parts = selectedQueryDate.value.split('-');
        final dayVal = parts.length == 3
            ? int.tryParse(parts[2]) ?? now.day
            : now.day;
        final monthVal = parts.length == 3
            ? int.tryParse(parts[1]) ?? now.month
            : now.month;
        selectedDate.value =
            "Day ${currentDay.value} of 30 • $dayVal ${months[monthVal - 1]}";
      } else {
        selectedDate.value =
            "Day ${currentDay.value} of 30 • ${now.day} ${months[now.month - 1]}";
      }

      // 2. Fetch today's logged nutrition (consumed calories/macros) & list of logged meals
      try {
        final nutRes = await _apiClient.get(
          "${ApiEndpoints.todayNutritionLog}$queryParam",
        );
        if (nutRes.data != null) {
          final nutData = nutRes.data;
          final consumed = nutData['consumed'] ?? {};
          currentCalories.value =
              double.tryParse(
                consumed['calories']?.toString() ?? '',
              )?.toInt() ??
              0;
          consumedProtein.value =
              double.tryParse(consumed['protein']?.toString() ?? '')?.toInt() ??
              0;
          consumedCarbs.value =
              double.tryParse(consumed['carbs']?.toString() ?? '')?.toInt() ??
              0;
          consumedFat.value =
              double.tryParse(consumed['fat']?.toString() ?? '')?.toInt() ?? 0;
          consumedFiber.value =
              double.tryParse(consumed['fiber']?.toString() ?? '')?.toInt() ??
              0;

          final List loggedIds = nutData['logged_meal_ids'] ?? [];
          completedMealIds.clear();
          for (var id in loggedIds) {
            final parsedId = int.tryParse(id?.toString() ?? '');
            if (parsedId != null) {
              completedMealIds.add(parsedId);
            }
          }
        }
      } catch (e) {
        print("Error fetching logged nutrition: $e");
      }

      // 3. Fetch today's logged water
      try {
        final waterRes = await _apiClient.get(
          "${ApiEndpoints.todayWaterLog}$queryParam",
        );
        if (waterRes.data != null) {
          final waterData = waterRes.data;
          final ml =
              double.tryParse(waterData['amount_ml']?.toString() ?? '') ?? 0.0;
          final tgtMl =
              double.tryParse(waterData['target_ml']?.toString() ?? '') ??
              3000.0;
          currentWater.value = ml / 1000.0;
          targetWater.value = tgtMl / 1000.0;
        }
      } catch (e) {
        print("Error fetching logged water: $e");
      }
    } catch (e, stack) {
      print("===== MEAL CONTROLLER FETCH ERROR =====");
      print("Error: $e");
      print("Stacktrace: $stack");
      // Graceful fallback to static placeholders if network fails
    } finally {
      isLoading.value = false;
    }
  }

  void goToPreviousWeek() {
    if (weekOffset.value > -4) weekOffset.value -= 1;
  }

  void goToNextWeek() {
    if (weekOffset.value < 4) weekOffset.value += 1;
  }

  void jumpToToday() {
    weekOffset.value = 0;
    selectedQueryDate.value = "";
    fetchMealData();
  }

  void selectDate(String dateStr) {
    selectedQueryDate.value = dateStr;
    fetchMealData();
  }

  // Human-readable label for whichever date is currently selected
  // (falls back to today when nothing is explicitly selected).
  String get dayLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime target = today;

    if (selectedQueryDate.value.isNotEmpty) {
      final parts = selectedQueryDate.value.split('-');
      if (parts.length == 3) {
        final y = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        final d = int.tryParse(parts[2]);
        if (y != null && m != null && d != null) target = DateTime(y, m, d);
      }
    }

    final diff = target.difference(today).inDays;
    if (diff == 0) return "Today";
    if (diff == 1) return "Tomorrow";
    if (diff == 2) return "Day After Tomorrow";
    if (diff == -1) return "Yesterday";

    const months = [
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
    return "${target.day} ${months[target.month - 1]}";
  }

  /// Returns true when the currently selected date is strictly in the future (after today).
  bool get isFutureDate {
    if (selectedQueryDate.value.isEmpty) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final parts = selectedQueryDate.value.split('-');
    if (parts.length != 3) return false;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return false;
    final selected = DateTime(y, m, d);
    return selected.isAfter(today);
  }

  /// How many days until the selected future date (0 if today or past).
  int get daysUntilSelected {
    if (!isFutureDate) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final parts = selectedQueryDate.value.split('-');
    final y = int.tryParse(parts[0])!;
    final m = int.tryParse(parts[1])!;
    final d = int.tryParse(parts[2])!;
    return DateTime(y, m, d).difference(today).inDays;
  }

  Future<void> addWater(double amountLiters) async {
    try {
      final amountMl = (amountLiters * 1000).toInt();
      await _apiClient.post(
        ApiEndpoints.logWater,
        data: {'amount_ml': amountMl},
      );
      final newVal = currentWater.value + amountLiters;
      currentWater.value = newVal > targetWater.value
          ? targetWater.value
          : newVal;
    } catch (_) {}
  }

  Future<void> resetWater() async {
    try {
      currentWater.value = 0.0;
    } catch (_) {}
  }

  Future<bool> markMealAsCompleted(
    int dietPlanMealId,
    int mealId, {
    int selectedOption = 1,
  }) async {
    try {
      await _apiClient.post(
        ApiEndpoints.markMealComplete,
        data: {
          'diet_plan_meal_id': dietPlanMealId,
          'selected_option': selectedOption,
        },
      );
      completedMealIds.add(mealId);
      await fetchMealData(silent: true); // silent refresh — no spinner
      await fetchCalorieHistory();
      _refreshDependentScreens();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> unmarkMealAsCompleted(int dietPlanMealId, int mealId) async {
    try {
      final dateParam = selectedQueryDate.value.isNotEmpty
          ? selectedQueryDate.value
          : null;
      await _apiClient.post(
        ApiEndpoints.unmarkMealComplete,
        data: {
          'diet_plan_meal_id': dietPlanMealId,
          if (dateParam != null) 'date': dateParam,
        },
      );
      completedMealIds.remove(mealId);
      await fetchMealData(silent: true); // silent refresh — no spinner
      await fetchCalorieHistory();
      _refreshDependentScreens();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Home and Progress each show their own summary of today's meals, but
  /// both are kept alive in the background (IndexedStack) and don't know a
  /// meal was just marked complete/incomplete here. Push a silent refresh
  /// to them directly so they're already correct the moment the user
  /// switches tabs, instead of needing a restart or waiting on their own
  /// tab-switch listener to catch up.
  void _refreshDependentScreens() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().fetchProfile(silent: true);
    }
    if (Get.isRegistered<ProgressController>()) {
      Get.find<ProgressController>().fetchProgressData();
    }
  }

  Future<void> fetchCalorieHistory() async {
    try {
      final res = await _apiClient.get(ApiEndpoints.calorieHistory);
      final data = res.data;

      historyTargetCalories.value =
          double.tryParse(data['target_calories']?.toString() ?? '')?.toInt() ??
          2000;

      final List rawHistory = data['history'] ?? [];
      final List<Map<String, dynamic>> tempHistory = [];

      double totalCal = 0.0;
      int daysAdherent = 0;

      for (var day in rawHistory) {
        final List mealsLogged = day['meals_logged'] ?? [];
        final double cal =
            double.tryParse(day['calories']?.toString() ?? '0.0') ?? 0.0;

        totalCal += cal;
        if (mealsLogged.isNotEmpty) {
          daysAdherent += 1;
        }

        tempHistory.add(Map<String, dynamic>.from(day));
      }

      // The window always spans 7 days, padded with zero-entries for any
      // day before the plan was activated. Average/adherence over a fixed
      // 7 would silently crush a new user's numbers, so only divide by the
      // days the plan has actually been active (capped at the window size).
      final int activeDays = _activeDaysInWindow(
        data['activated_at']?.toString(),
        rawHistory.length,
      );

      calorieHistoryList.value = tempHistory;
      historyAverageCalories.value = (totalCal / activeDays).round();
      historyAdherenceRate.value =
          ((daysAdherent / activeDays) * 100).round();
    } catch (_) {}
  }

  int _activeDaysInWindow(String? activatedAtStr, int windowSize) {
    if (windowSize <= 0) return 1;
    if (activatedAtStr == null || activatedAtStr.isEmpty) return windowSize;

    final activatedDate = DateTime.tryParse(activatedAtStr);
    if (activatedDate == null) return windowSize;

    final daysSinceActivation =
        DateTime.now().difference(activatedDate).inDays + 1;
    return daysSinceActivation.clamp(1, windowSize);
  }
}
