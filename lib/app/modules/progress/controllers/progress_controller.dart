import 'package:get/get.dart';

class ProgressController extends GetxController {
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
