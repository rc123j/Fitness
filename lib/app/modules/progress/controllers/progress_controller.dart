import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

// Index of the Progress tab inside MainNavigationView's IndexedStack.
const int _kProgressTabIndex = 2;

class ProgressController extends GetxController {
  final _apiClient = Get.find<ApiClient>();
  Worker? _tabWorker;

  final isLoading = false.obs;

  // Corner Case: No Active Plan
  final hasActivePlan = false.obs;

  // 30-Day Journey State
  final currentDay = 1.obs;
  final daysRemaining = 30.obs;

  // Consistency State
  final currentStreak = 0.obs;
  final dietCompliance = 0.obs; // Percentage

  // Starting Health Snapshot
  final bmi = 0.0.obs;
  final tdee = 0.obs;
  final bmr = 0.obs;
  final ibw = 0.0.obs;
  final startingWeight = 0.0.obs;

  // Transformation Gallery
  // The map stores local UI milestones mapped to their image URLs (empty if not uploaded).
  final transformationPhotos = {
    'Day 1': '',
    'Week 1': '',
    'Week 2': '',
    'Week 3': '',
    'Day 30': '',
  }.obs;

  // 7-Day Adherence Data Points (Mon-Sun)
  final targetCalories = 2150.obs;
  final weeklyAdherenceData = <Map<String, dynamic>>[].obs;

  // Today's Report (daily-only for now; weekly view lands later)
  final todayConsumedCalories = 0.obs;
  final todayConsumedProtein = 0.obs;
  final todayConsumedCarbs = 0.obs;
  final todayConsumedFat = 0.obs;
  final todayTargetProtein = 0.obs;
  final todayTargetCarbs = 0.obs;
  final todayTargetFat = 0.obs;

  // Weight Tracker
  final isLoggingWeight = false.obs;
  final currentWeight = 0.0.obs;
  final weightDifferenceKg = 0.0.obs; // negative = lost, positive = gained
  final weightHistory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProgressData();

    // The Progress tab is kept alive inside an IndexedStack, so it never
    // rebuilds/re-fetches on its own when the user switches back to it.
    // Re-fetch whenever it becomes the active tab so meals logged elsewhere
    // (e.g. the Meal tab) are reflected here without needing an app restart.
    if (Get.isRegistered<MainNavigationController>()) {
      _tabWorker = ever<int>(
        Get.find<MainNavigationController>().selectedIndex,
        (index) {
          if (index == _kProgressTabIndex) fetchProgressData();
        },
      );
    }
  }

  @override
  void onClose() {
    _tabWorker?.dispose();
    super.onClose();
  }

  Future<void> fetchProgressData() async {
    isLoading.value = true;

    try {
      // 1. Check Active Plan Status & Metrics
      final planRes = await _apiClient.get(ApiEndpoints.currentDietPlan);
      if (planRes.statusCode == 200 && planRes.data != null) {
        // The endpoint returns { activation_id, activated_at, expires_at,
        // current_day, days_remaining, diet_plan: {...} } — activation
        // fields are flattened at the top level, not nested under an
        // "activation" key, and the plan itself is "diet_plan" not "plan".
        final planData = planRes.data['diet_plan'];
        final activationData = planRes.data;

        if (planData != null) {
          hasActivePlan.value = true;
          targetCalories.value =
              double.tryParse(planData['target_calories']?.toString() ?? '')?.toInt() ?? 2000;

          // Calculate days remaining based on activation date
          final activatedAtStr = activationData['activated_at'];
          final expiresAtStr = activationData['expires_at'];

          if (activatedAtStr != null && expiresAtStr != null) {
            final activatedDate = DateTime.parse(activatedAtStr);
            final expiresDate = DateTime.parse(expiresAtStr);
            final now = DateTime.now();

            final totalDays = expiresDate.difference(activatedDate).inDays;
            final daysPassed = now.difference(activatedDate).inDays;

            currentDay.value = (daysPassed + 1).clamp(1, 30);
            daysRemaining.value = (totalDays - daysPassed).clamp(0, 30);

            // Corner Case: Day 31 Expiration
            if (daysRemaining.value == 0 && currentDay.value >= 30) {
              _showPlanExpiredDialog();
            }
          }

          // 3. Setup Adherence Data by hitting real backend
          await _fetchRealAdherenceHistory();
          await _fetchTodayReport();
        } else {
          hasActivePlan.value = false;
        }
      } else {
        hasActivePlan.value = false;
      }

      // 2. Fetch profile metrics for Starting Snapshot
      final profileRes = await _apiClient.get(ApiEndpoints.profile);
      if (profileRes.statusCode == 200 && profileRes.data != null) {
        final data = profileRes.data;
        final latestMetrics = data['latest_metrics'];

        if (latestMetrics != null) {
          bmi.value = double.tryParse(latestMetrics['bmi']?.toString() ?? '') ?? 0.0;
          tdee.value = double.tryParse(latestMetrics['tdee']?.toString() ?? '')?.toInt() ?? 0;
          bmr.value = double.tryParse(latestMetrics['bmr']?.toString() ?? '')?.toInt() ?? 0;
          ibw.value = double.tryParse(latestMetrics['ibw']?.toString() ?? '') ?? 0.0;
        }
      }

      // 3. Weight tracker (starting/current weight + trend), independent of
      // diet-plan activation — a member can log weigh-ins regardless.
      await _fetchWeightData();
    } catch (e) {
      debugPrint("Error fetching progress: $e");
      // Fallback state on error
      hasActivePlan.value = false;
    }

    isLoading.value = false;
  }

  Future<void> _fetchRealAdherenceHistory() async {
    try {
      final res = await _apiClient.get(ApiEndpoints.calorieHistory);
      if (res.statusCode == 200 && res.data != null) {
        final List rawHistory = res.data['history'] ?? [];
        final List<Map<String, dynamic>> tempHistory = [];
        
        int daysAdherent = 0;
        int streakCounter = 0;
        bool streakBroken = false;
        
        // We only evaluate streak/compliance for days they were actually enrolled.
        int activeDaysInHistory = currentDay.value.clamp(1, 7);
        int evaluatedDays = 0;

        // The API returns the last 7 days. We parse it to calculate compliance and streak.
        for (var day in rawHistory.reversed) {
          final double cal = double.tryParse(day['calories']?.toString() ?? '0.0') ?? 0.0;
          final String dateStr = day['date']?.toString() ?? '';
          
          String shortDay = 'Day';
          if (dateStr.isNotEmpty) {
            try {
              final d = DateTime.parse(dateStr);
              final daysList = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
              shortDay = daysList[d.weekday - 1];
            } catch (_) {}
          }

          tempHistory.insert(0, {
            "day": shortDay,
            "calories": cal.toInt(),
            "target": targetCalories.value,
          });

          // Only evaluate adherence for days they were actually active
          if (evaluatedDays < activeDaysInHistory) {
            final double minimumRequiredCalories = targetCalories.value - 300;
            final double maximumAllowedCalories = targetCalories.value + 100;

            if (cal >= minimumRequiredCalories && cal <= maximumAllowedCalories) {
              daysAdherent++;
              if (!streakBroken) streakCounter++;
            } else {
              // They fell short or overshot their target. Streak breaks!
              streakBroken = true;
            }
            evaluatedDays++;
          }
        }
        
        weeklyAdherenceData.value = tempHistory;
        currentStreak.value = streakCounter;
        dietCompliance.value = activeDaysInHistory > 0 ? ((daysAdherent / activeDaysInHistory) * 100).round() : 0;
      }
    } catch (e) {
      debugPrint("Error fetching real history: $e");
    }
  }

  Future<void> _fetchTodayReport() async {
    try {
      final res = await _apiClient.get(ApiEndpoints.todayNutritionLog);
      if (res.statusCode == 200 && res.data != null) {
        final data = res.data;
        final consumed = data['consumed'] ?? {};
        final targets = data['targets'] ?? {};

        todayConsumedCalories.value = (consumed['calories'] as num?)?.round() ?? 0;
        todayConsumedProtein.value = (consumed['protein'] as num?)?.round() ?? 0;
        todayConsumedCarbs.value = (consumed['carbs'] as num?)?.round() ?? 0;
        todayConsumedFat.value = (consumed['fat'] as num?)?.round() ?? 0;

        todayTargetProtein.value = (targets['protein'] as num?)?.round() ?? 0;
        todayTargetCarbs.value = (targets['carbs'] as num?)?.round() ?? 0;
        todayTargetFat.value = (targets['fat'] as num?)?.round() ?? 0;
      }
    } catch (e) {
      debugPrint("Error fetching today's report: $e");
    }
  }

  Future<void> _fetchWeightData() async {
    try {
      final res = await _apiClient.get(ApiEndpoints.progressLog);
      if (res.statusCode == 200 && res.data != null) {
        final data = res.data;

        startingWeight.value =
            double.tryParse(data['starting_weight']?.toString() ?? '') ??
            startingWeight.value;
        currentWeight.value =
            double.tryParse(data['current_weight']?.toString() ?? '') ?? 0.0;
        weightDifferenceKg.value =
            double.tryParse(data['weight_difference_kg']?.toString() ?? '') ?? 0.0;

        final List rawLogs = data['logs'] ?? [];
        final tempHistory = <Map<String, dynamic>>[];
        for (var log in rawLogs) {
          final w = double.tryParse(log['weight_kg']?.toString() ?? '') ?? 0.0;
          final dateStr = log['logged_date']?.toString() ?? '';
          if (w > 0) {
            tempHistory.add({'date': dateStr, 'weight': w});
          }
        }
        // Keep only the most recent entries so the trend line stays readable.
        weightHistory.value = tempHistory.length > 10
            ? tempHistory.sublist(tempHistory.length - 10)
            : tempHistory;
      }
    } catch (e) {
      debugPrint("Error fetching weight history: $e");
    }
  }

  Future<bool> logWeight(double weightKg) async {
    isLoggingWeight.value = true;
    try {
      final res = await _apiClient.post(
        ApiEndpoints.logWeight,
        data: {'weight_kg': weightKg},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        await _fetchWeightData();
        Get.snackbar(
          "Weight Logged",
          "Your weight has been updated to ${weightKg.toStringAsFixed(1)} kg.",
          backgroundColor: const Color(0xff00FF87).withOpacity(0.9),
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error logging weight: $e");
      Get.snackbar(
        "Error",
        "Failed to log weight. Please try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoggingWeight.value = false;
    }
  }

  void handlePhotoAction(String milestone) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xff121220),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$milestone Photo",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Update your transformation gallery.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: Color(0xffB100FF),
              ),
              title: const Text(
                "Take Photo",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.back();
                _uploadPhoto(milestone, 'camera');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: Color(0xffB100FF),
              ),
              title: const Text(
                "Choose from Gallery",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.back();
                _uploadPhoto(milestone, 'gallery');
              },
            ),
            // Corner Case: Deleting/Retaking
            if (transformationPhotos[milestone] != null &&
                transformationPhotos[milestone]!.isNotEmpty) ...[
              const Divider(color: Colors.white12),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  "Remove Photo",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Get.back();
                  final currentPhotos = Map<String, String>.from(
                    transformationPhotos,
                  );
                  currentPhotos[milestone] = '';
                  transformationPhotos.value = currentPhotos;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _uploadPhoto(String milestone, String source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70, // compress slightly
    );

    if (image == null) return; // User canceled

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xffB100FF))),
      barrierDismissible: false,
    );
    
    try {
      final formData = dio.FormData.fromMap({
        'photo': await dio.MultipartFile.fromFile(image.path, filename: image.name),
      });

      // We need to use the dio instance directly from api_client if it supports raw paths, 
      // or we can just call post with the formData.
      // Assuming _apiClient.post handles formData properly:
      final res = await _apiClient.post('/api/progress/photo', data: formData);

      Get.back(); // close dialog

      if (res.statusCode == 200) {
        final photoUrl = res.data['photo_url'];
        final currentPhotos = Map<String, String>.from(transformationPhotos);
        // Replace with the real backend URL. Assuming baseUrl is prefixed by the UI if needed, 
        // or we just use ApiEndpoints.baseUrl + photoUrl
        currentPhotos[milestone] = '${ApiEndpoints.baseUrl}$photoUrl';
        transformationPhotos.value = currentPhotos;

        Get.snackbar(
          "Photo Uploaded!",
          "Looking great! Your transformation photo for $milestone has been securely saved.",
          backgroundColor: const Color(0xff00FF87).withOpacity(0.9),
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.snackbar("Error", "Failed to upload photo. Please try again.", backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      debugPrint("Photo upload error: $e");
      Get.snackbar("Error", "An error occurred while uploading.", backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void _showPlanExpiredDialog() {
    Get.defaultDialog(
      title: "30 Days Complete! 🎉",
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: const Color(0xff121220),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            color: Color(0xff00FF87),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            "Congratulations on finishing your 30-day journey! It's time to step on the scale and record your final weight so we can generate your next optimized plan.",
            style: TextStyle(color: Colors.white.withOpacity(0.8), height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffB100FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              // Navigate to a new weight input screen (to be implemented later)
              Get.back();
            },
            child: const Text(
              "Enter Final Weight",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
