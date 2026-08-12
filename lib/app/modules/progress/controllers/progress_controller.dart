import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';

class ProgressController extends GetxController {
  final _apiClient = Get.find<ApiClient>();

  final isLoading = false.obs;

  // Timeframe state: "7 Days", "30 Days", "3 Months", "1 Year", "All Time"
  final selectedTimeframe = "30 Days".obs;

  // Progress photos timeframe: "30 Days", "90 Days", "All Time"
  final selectedPhotoTimeframe = "30 Days".obs;
  
  // Selected index in the transformation timeline (0 = Day 1, 1 = Day 15, 2 = Day 30, etc.)
  final activeTimelineIndex = 2.obs;

  // Overall progress percentage
  final overallProgress = 72.obs;

  // Current metrics
  final weight = 68.4.obs;
  final weightChange = (-2.6).obs;

  final bodyFat = 18.7.obs;
  final bodyFatChange = (-3.1).obs;

  final muscleMass = 32.6.obs;
  final muscleMassChange = 2.4.obs;

  final bmi = 23.1.obs;
  final bmiChange = (-0.8).obs;

  // New Health Report Metrics
  final tdee = 2450.obs;
  final bmr = 1800.obs;
  final ibw = 72.0.obs;
  final targetCalories = 2150.obs;

  // 7-Day Adherence Data Points
  final weeklyAdherenceData = <Map<String, dynamic>>[].obs;

  // Weight Trend Data Points (Date, Weight)
  final weightTrendData = <Map<String, dynamic>>[
    {"date": "16 Apr", "weight": 71.0},
    {"date": "21 Apr", "weight": 70.1},
    {"date": "26 Apr", "weight": 69.3},
    {"date": "01 May", "weight": 69.0},
    {"date": "06 May", "weight": 68.6},
    {"date": "11 May", "weight": 68.4},
    {"date": "15 May", "weight": 68.4},
  ].obs;

  // Body Composition Values
  final muscleMassKg = 32.6.obs; // 48.7%
  final bodyFatKg = 18.7.obs;   // 18.7%
  final otherKg = 16.1.obs;     // 32.6%

  // Achievements Count
  final achievementsCount = 12.obs;

  // Goal weight
  final goalWeight = 65.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProgressData();
  }

  Future<void> fetchProgressData() async {
    isLoading.value = true;
    try {
      // 1. Fetch weight and steps history logs
      final response = await _apiClient.get(ApiEndpoints.progressLog);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        weight.value = (data['current_weight'] as num?)?.toDouble() ?? weight.value;
        weightChange.value = (data['weight_difference_kg'] as num?)?.toDouble() ?? weightChange.value;

        final logsList = data['logs'] as List?;
        if (logsList != null && logsList.isNotEmpty) {
          final List<Map<String, dynamic>> trend = [];
          for (var item in logsList) {
            final double wt = (item['weight_kg'] as num?)?.toDouble() ?? 0.0;
            final String dateStr = item['logged_date']?.toString() ?? "";
            
            // Format "2026-07-21" to "21 Jul"
            String formattedDate = dateStr;
            if (dateStr.length >= 10) {
              try {
                final date = DateTime.parse(dateStr);
                final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                formattedDate = "${date.day} ${months[date.month - 1]}";
              } catch (_) {}
            }
            if (wt > 0) {
              trend.add({"date": formattedDate, "weight": wt});
            }
          }
          if (trend.isNotEmpty) {
            weightTrendData.value = trend;
          }
        }
        
        // Setup mock 7-day adherence data (Calories vs Target)
        final List<Map<String, dynamic>> adherence = [];
        final today = DateTime.now();
        final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
        for (int i = 6; i >= 0; i--) {
          final d = today.subtract(Duration(days: i));
          // Mock data: sometimes hitting target, sometimes over
          int cal = 1900 + (d.day * 50) % 600; 
          adherence.add({
            "day": days[d.weekday - 1],
            "calories": cal,
            "target": targetCalories.value,
          });
        }
        weeklyAdherenceData.value = adherence;

      }
    } catch (_) {
      // Fallback gracefully on network failures
    }

    try {
      // 2. Fetch body composition, BMI, and target weight from profile metrics
      final profileRes = await _apiClient.get(ApiEndpoints.profile);
      if (profileRes.statusCode == 200 && profileRes.data != null) {
        final data = profileRes.data;
        final profile = data['profile'];
        final latestMetrics = data['latest_metrics'];

        if (profile != null) {
          weight.value = (profile['weight_kg'] as num?)?.toDouble() ?? weight.value;
        }

        if (latestMetrics != null) {
          bmi.value = (latestMetrics['bmi'] as num?)?.toDouble() ?? bmi.value;
          tdee.value = (latestMetrics['tdee'] as num?)?.toInt() ?? tdee.value;
          bmr.value = (latestMetrics['bmr'] as num?)?.toInt() ?? bmr.value;
          ibw.value = (latestMetrics['ibw'] as num?)?.toDouble() ?? ibw.value;
          
          final double fatPct = (latestMetrics['body_fat_pct'] as num?)?.toDouble() ?? 0.0;
          final double musclePct = (latestMetrics['muscle_mass_pct'] as num?)?.toDouble() ?? 0.0;
          
          if (fatPct > 0) {
            bodyFat.value = fatPct;
            bodyFatKg.value = double.parse((weight.value * (fatPct / 100)).toStringAsFixed(1));
          }
          if (musclePct > 0) {
            muscleMass.value = double.parse((weight.value * (musclePct / 100)).toStringAsFixed(1));
            muscleMassKg.value = muscleMass.value;
          }

          otherKg.value = double.parse((weight.value - bodyFatKg.value - muscleMassKg.value).toStringAsFixed(1));
        }
      }
    } catch (_) {}
    isLoading.value = false;
  }

  void changeTimeframe(String timeframe) {
    selectedTimeframe.value = timeframe;
    // Mock updates to metrics based on timeframe if needed
    if (timeframe == "7 Days") {
      weightChange.value = -0.5;
      bodyFatChange.value = -0.8;
      muscleMassChange.value = 0.3;
      bmiChange.value = -0.1;
    } else if (timeframe == "30 Days") {
      weightChange.value = -2.6;
      bodyFatChange.value = -3.1;
      muscleMassChange.value = 2.4;
      bmiChange.value = -0.8;
    } else {
      weightChange.value = -4.2;
      bodyFatChange.value = -5.0;
      muscleMassChange.value = 4.1;
      bmiChange.value = -1.5;
    }
  }
}
