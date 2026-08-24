import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/api_endpoints.dart';

class ProgressController extends GetxController {
  final _apiClient = Get.find<ApiClient>();

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

  @override
  void onInit() {
    super.onInit();
    fetchProgressData();
  }

  Future<void> fetchProgressData() async {
    isLoading.value = true;

    try {
      // 1. Check Active Plan Status & Metrics
      final planRes = await _apiClient.get(ApiEndpoints.currentDietPlan);
      if (planRes.statusCode == 200 && planRes.data != null) {
        final planData = planRes.data['plan'];
        final activationData = planRes.data['activation'];

        if (planData != null && activationData != null) {
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
        final profile = data['profile'];
        final latestMetrics = data['latest_metrics'];

        if (profile != null) {
          startingWeight.value =
              double.tryParse(profile['weight_kg']?.toString() ?? '') ?? 0.0;
        }

        if (latestMetrics != null) {
          bmi.value = double.tryParse(latestMetrics['bmi']?.toString() ?? '') ?? 0.0;
          tdee.value = double.tryParse(latestMetrics['tdee']?.toString() ?? '')?.toInt() ?? 0;
          bmr.value = double.tryParse(latestMetrics['bmr']?.toString() ?? '')?.toInt() ?? 0;
          ibw.value = double.tryParse(latestMetrics['ibw']?.toString() ?? '') ?? 0.0;
        }
      }
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

          // Check adherence: They MUST hit at least 85% of their target to maintain the streak.
          final double minimumRequiredCalories = targetCalories.value * 0.85;

          if (cal >= minimumRequiredCalories) { 
            daysAdherent++;
            if (!streakBroken) streakCounter++;
          } else {
            // They missed meals or fell short. Streak breaks!
            streakBroken = true;
          }
        }
        
        weeklyAdherenceData.value = tempHistory;
        currentStreak.value = streakCounter;
        dietCompliance.value = rawHistory.isNotEmpty ? ((daysAdherent / rawHistory.length) * 100).round() : 0;
      }
    } catch (e) {
      debugPrint("Error fetching real history: $e");
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
