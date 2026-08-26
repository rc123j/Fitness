import 'dart:convert';
import 'package:dio/dio.dart' show DioException;
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

  Map<String, dynamic>? get macroAchieved => aiInsights['macro_achieved'] is Map
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

  // Date (day-only) the member's current diet plan was activated on.
  // Null until the first successful fetch. Used to lock out dates before
  // the plan existed, the same way future dates are locked.
  DateTime? _activatedAtDate;

  // Set of completed meal_ids (1=Breakfast, etc.) for today
  final completedMealIds = <int>{}.obs;

  // Track expanded state for each meal slot (dietPlanMealId)
  final expandedMealIds = <int>{}.obs;

  // Meal-completion timing state, from the backend's `meal_marking` block.
  // Drives whether "Mark as Complete" is tappable and what label it shows.
  final markingIsToday = true.obs;
  final markingIsPast = false.obs;
  final mealUnlocked = <int, bool>{}.obs; // meal_id -> is its window open now
  final mealUnlockLabel = <int, String>{}.obs; // meal_id -> "7:00 PM"

  /// Whether this meal slot can be marked complete right now (viewing today
  /// AND the slot's time of day has arrived). Past/future days -> false.
  bool isMealMarkable(int mealId) =>
      markingIsToday.value && (mealUnlocked[mealId] ?? false);

  /// Label to show when a slot isn't markable yet, e.g. "Unlocks 7:00 PM".
  String mealLockLabel(int mealId) {
    if (markingIsPast.value) return "Log closed for this day";
    if (!markingIsToday.value) return "Not available";
    final t = mealUnlockLabel[mealId];
    return t != null && t.isNotEmpty ? "Unlocks $t" : "Locked";
  }

  // Calorie & Nutrition history logging
  final calorieHistoryList = <Map<String, dynamic>>[].obs;
  final historyTargetCalories = 2000.obs;
  final historyAverageCalories = 0.obs;
  final historyAdherenceRate = 0.obs;

  /// Per-day intake (calories + macros + which meal slots were logged),
  /// newest day first, with days before the plan was activated dropped —
  /// the member never logged anything for those. Backs the "Daily Intake"
  /// chart on the Nutrition History screen.
  List<Map<String, dynamic>> get dailyIntakeHistory {
    final list = calorieHistoryList
        .where(
          (d) => !isDateBeforeActivation(d['date']?.toString() ?? ''),
        )
        .toList();
    list.sort(
      (a, b) => (b['date']?.toString() ?? '').compareTo(
        a['date']?.toString() ?? '',
      ),
    );
    return list;
  }

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

        // Meal-completion timing (per-slot unlock state) from the backend.
        final marking = planRes.data['meal_marking'];
        if (marking is Map) {
          markingIsToday.value = marking['is_today'] == true;
          markingIsPast.value = marking['is_past'] == true;
          final newUnlocked = <int, bool>{};
          final newLabels = <int, String>{};
          final w = marking['windows'];
          if (w is Map) {
            w.forEach((key, val) {
              final mid = int.tryParse(key.toString());
              if (mid != null && val is Map) {
                newUnlocked[mid] = val['unlocked'] == true;
                newLabels[mid] = val['unlocks_at_label']?.toString() ?? '';
              }
            });
          }
          mealUnlocked.value = newUnlocked;
          mealUnlockLabel.value = newLabels;
        }

        final activatedAtStr = planRes.data['activated_at']?.toString();
        final parsedActivatedAt = activatedAtStr != null
            ? DateTime.tryParse(activatedAtStr)
            : null;
        if (parsedActivatedAt != null) {
          _activatedAtDate = DateTime(
            parsedActivatedAt.year,
            parsedActivatedAt.month,
            parsedActivatedAt.day,
          );
        }

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

  // Today's date with the time-of-day zeroed out, so it can be safely
  // compared against other day-only dates.
  DateTime get _todayDateOnly {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // Whichever date is currently selected (day-only), falling back to today
  // when nothing has been explicitly picked.
  DateTime get _selectedDateOnly {
    if (selectedQueryDate.value.isEmpty) return _todayDateOnly;
    final parts = selectedQueryDate.value.split('-');
    if (parts.length != 3) return _todayDateOnly;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return _todayDateOnly;
    return DateTime(y, m, d);
  }

  /// Returns true when the currently selected date is strictly in the future (after today).
  bool get isFutureDate => _selectedDateOnly.isAfter(_todayDateOnly);

  /// Returns true when the currently selected date is before the member's
  /// diet plan was activated (e.g. viewing "yesterday" on the member's
  /// very first day) — there was never a real plan for that day.
  bool get isBeforeActivation {
    if (_activatedAtDate == null) return false;
    return _selectedDateOnly.isBefore(_activatedAtDate!);
  }

  /// True when the selected day's meal plan should be hidden behind the
  /// lock screen — either it hasn't been revealed yet (future) or the plan
  /// didn't exist yet on that day (before activation).
  bool get isLockedDate => isFutureDate || isBeforeActivation;

  /// True when [dateStr] (yyyy-MM-dd) falls before the member's plan was
  /// activated — used to keep history views (e.g. the meal attendance log)
  /// from showing days the member never actually joined for as "missed".
  bool isDateBeforeActivation(String dateStr) {
    if (_activatedAtDate == null) return false;
    final parts = dateStr.split('-');
    if (parts.length != 3) return false;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return false;
    return DateTime(y, m, d).isBefore(_activatedAtDate!);
  }

  /// How many days until the selected future date (0 if today or past).
  int get daysUntilSelected {
    if (!isFutureDate) return 0;
    return _selectedDateOnly.difference(_todayDateOnly).inDays;
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

  /// Returns null on success, or a user-facing error message on failure
  /// (e.g. "You can mark this meal from 7:00 PM.").
  Future<String?> markMealAsCompleted(
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
          // The day the user is looking at — the backend rejects anything
          // that isn't the member's current local day.
          if (selectedQueryDate.value.isNotEmpty)
            'logged_date': selectedQueryDate.value,
        },
      );
      completedMealIds.add(mealId);
      await fetchMealData(silent: true); // silent refresh — no spinner
      await fetchCalorieHistory();
      _refreshDependentScreens();
      return null;
    } on DioException catch (e) {
      return _errorMessage(e, fallback: 'Could not log this meal. Try again.');
    } catch (_) {
      return 'Could not log this meal. Try again.';
    }
  }

  /// Returns null on success, or a user-facing error message on failure.
  Future<String?> unmarkMealAsCompleted(int dietPlanMealId, int mealId) async {
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
      return null;
    } on DioException catch (e) {
      return _errorMessage(e, fallback: 'Could not update this meal. Try again.');
    } catch (_) {
      return 'Could not update this meal. Try again.';
    }
  }

  String _errorMessage(DioException e, {required String fallback}) {
    final data = e.response?.data;
    if (data is Map) {
      final m = data['message'] ?? data['error'];
      if (m != null && m.toString().isNotEmpty) return m.toString();
    }
    return fallback;
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
      // Pull the full 30-day window (backend caps at 30). The Meal
      // Attendance Log still renders one week at a time, but the "Daily
      // Intake" breakdown below it walks the whole plan history.
      final res = await _apiClient.get("${ApiEndpoints.calorieHistory}?days=30");
      final data = res.data;

      historyTargetCalories.value =
          double.tryParse(data['target_calories']?.toString() ?? '')?.toInt() ??
          2000;

      final activatedAtStr = data['activated_at']?.toString();
      final parsedActivatedAt = activatedAtStr != null
          ? DateTime.tryParse(activatedAtStr)
          : null;
      if (parsedActivatedAt != null) {
        _activatedAtDate = DateTime(
          parsedActivatedAt.year,
          parsedActivatedAt.month,
          parsedActivatedAt.day,
        );
      }

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
      historyAdherenceRate.value = ((daysAdherent / activeDays) * 100).round();
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
