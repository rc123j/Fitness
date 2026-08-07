import 'dart:math' as dart_math;
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/auth_service.dart';
import '../../../services/onboarding_draft_service.dart';
import 'congratulations_screen.dart';

class ScreeningReportScreen extends StatefulWidget {
  final String goalTitle;
  final int goalId;
  final String gender;
  final int age;
  final int height;
  final double weight;
  final int activityLevelId;
  final String activityLevelName;
  // New: dietary & health profile fields
  final List<int> tastePreferenceIds;
  final String dietLabel;
  final List<String> foodExclusions;
  final List<int> medicalConditionIds;
  final List<int> symptomIds;
  final List<String> customConditions;
  final String? smokingHabit;
  final String? alcoholHabit;

  const ScreeningReportScreen({
    super.key,
    required this.goalTitle,
    required this.goalId,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevelId,
    required this.activityLevelName,
    required this.tastePreferenceIds,
    required this.dietLabel,
    required this.foodExclusions,
    required this.medicalConditionIds,
    required this.symptomIds,
    required this.customConditions,
    this.smokingHabit,
    this.alcoholHabit,
  });

  @override
  State<ScreeningReportScreen> createState() => _ScreeningReportScreenState();
}

class _ScreeningReportScreenState extends State<ScreeningReportScreen> {
  final _apiClient = Get.find<ApiClient>();
  final _authService = Get.find<AuthService>();
  bool _isLoading = false;
  String? _error;
  String? _memberCode;

  // Pre-initialize with safe defaults to prevent LateInitializationError during hot reloads
  double bmi = 22.0;
  double bmr = 1500.0;
  double ibw = 60.0;
  double pctIbw = 100.0;
  double tdee = 2000.0;
  int targetCalories = 2000;
  int proteinTargetG = 90;
  int carbsTargetG = 225;
  int fatTargetG = 55;
  String bmiClassification = "Normal Weight";
  Color bmiColor = const Color(0xff00E5FF);

  @override
  void initState() {
    super.initState();
    calculateMetrics();
  }

  void calculateMetrics() {
    // 1. BMI = Match manager spreadsheet formula exactly: weight / ((height/100) * 2) -> 20.11 for 70kg, 174cm
    double heightM = widget.height / 100.0;
    if (heightM > 0) {
      bmi = widget.weight / (heightM * 2.0);
    } else {
      bmi = 22.0;
    }

    if (bmi.isNaN || bmi.isInfinite) {
      bmi = 22.0;
    }

    // BMI categories from Exchange-List.xlsx > Sheet 2: BMI Ratio
    if (bmi < 18.0) {
      bmiClassification = "Underweight";
      bmiColor = const Color(0xffFFD200); // Amber Yellow
    } else if (bmi < 25.0) {
      bmiClassification = "Normal";
      bmiColor = const Color(0xff00E5FF); // Vibrant Cyan
    } else if (bmi < 30.0) {
      bmiClassification = "Overweight";
      bmiColor = const Color(0xffFF7A00); // Vibrant Orange
    } else {
      bmiClassification = "Obese class 1";
      bmiColor = const Color(0xffFF3B30); // Deep Red
    }

    // 2. BMR (Mifflin-St Jeor matching Manager spreadsheet calculation: 10W + 6.25H - 5A)
    bmr = 10 * widget.weight + 6.25 * widget.height - 5 * widget.age;

    if (bmr.isNaN || bmr.isInfinite || bmr <= 0) {
      bmr = 1500.0;
    }

    // 3. IBW (Strict Excel Sheet Formula: Height - 100 for Male, Height - 105 for Female)
    if (widget.gender.toLowerCase() == "male") {
      ibw = widget.height - 100.0;
    } else {
      ibw = widget.height - 105.0;
    }

    if (ibw.isNaN || ibw.isInfinite || ibw <= 0) {
      ibw = 60.0;
    }

    // 4. %IBW
    if (ibw > 0) {
      pctIbw = (widget.weight / ibw) * 100.0;
    } else {
      pctIbw = 100.0;
    }

    if (pctIbw.isNaN || pctIbw.isInfinite) {
      pctIbw = 100.0;
    }

    // 5. TDEE & Activity Multipliers from Exchange-List.xlsx PAL table (Gender-dependent)
    double activityMultiplier;
    bool isMale = widget.gender.toLowerCase() == "male";
    switch (widget.activityLevelId) {
      case 1:
        activityMultiplier = 1.3;
        break;
      case 2:
        activityMultiplier = isMale ? 1.6 : 1.5;
        break;
      case 3:
        activityMultiplier = isMale ? 1.7 : 1.6;
        break;
      case 4:
        activityMultiplier = isMale ? 2.1 : 1.9;
        break;
      case 5:
        activityMultiplier = isMale ? 2.4 : 2.2;
        break;
      default:
        activityMultiplier = 1.3;
    }
    tdee = bmr * activityMultiplier;
    if (tdee.isNaN || tdee.isInfinite || tdee <= 0) {
      tdee = bmr * 1.3;
    }

    // 6. Dynamic Macronutrient & Calorie Target calculations
    String goal = widget.goalTitle.toLowerCase();
    double calTarget = tdee;
    if (goal.contains('fat loss') ||
        goal.contains('lose') ||
        goal.contains('weight loss') ||
        goal.contains('burn')) {
      calTarget = tdee - 500;
      if (calTarget < 1200) calTarget = 1200;
    } else if (goal.contains('weight gain')) {
      calTarget = tdee + 400;
    } else if (goal.contains('muscle') || goal.contains('gain')) {
      calTarget = tdee + 300;
    } else if (goal.contains('plateau')) {
      calTarget = tdee - 250;
      if (calTarget < 1200) calTarget = 1200;
    }
    targetCalories = calTarget.round();
    proteinTargetG = (ibw * 1.2).round();
    carbsTargetG = ((targetCalories * 0.45) / 4.0).round();
    fatTargetG = ((targetCalories * 0.25) / 9.0).round();
  }

  String getAISuggestionText() {
    String goal = widget.goalTitle.toLowerCase();
    String lifestyleNote = "";
    if (widget.smokingHabit == "Yes, regularly" ||
        widget.alcoholHabit == "Yes, regularly" ||
        widget.smokingHabit == "Occasionally / Socially" ||
        widget.alcoholHabit == "Occasionally / Socially") {
      lifestyleNote =
          " Additionally, your plan is calibrated with extra hydration and antioxidant-rich micronutrients to support cellular health and liver processing based on your lifestyle profile.";
    }

    if (goal.contains("loss") || goal.contains("burn")) {
      return "To achieve your goal of **${widget.goalTitle}**, your AI target daily intake is **$targetCalories kcal** (a healthy 500 kcal deficit). With your **${widget.activityLevelName}** lifestyle, we recommend incorporating 150 mins of moderate-intensity cardio weekly paired with highly-adaptive protein-rich meals to preserve lean muscle tissue while maximizing fat oxidation with at least **${proteinTargetG}g** of protein daily (IBW × 1.2).$lifestyleNote";
    } else if (goal.contains("weight gain")) {
      return "To achieve your goal of **${widget.goalTitle}**, your AI target daily intake is **$targetCalories kcal** (a healthy 400 kcal surplus). With your **${widget.activityLevelName}** lifestyle, we recommend nutrient-dense whole foods and balanced complex carbs (45% carbs, 25% fat) to support steady, sustainable weight gain with at least **${proteinTargetG}g** of protein daily (IBW × 1.2).$lifestyleNote";
    } else if (goal.contains("gain") || goal.contains("muscle")) {
      return "To achieve your goal of **${widget.goalTitle}**, your AI target daily intake is **$targetCalories kcal** (a clean 300 kcal surplus). With your **${widget.activityLevelName}** lifestyle, we recommend progressive resistance training 4-5 times a week, paired with an adaptive macro profile containing at least **${proteinTargetG}g** of high-quality protein daily (IBW × 1.2).$lifestyleNote";
    } else {
      return "To maintain peak fitness and daily energy, your AI target daily intake is **$targetCalories kcal**. Since your lifestyle is **${widget.activityLevelName}**, your adaptive plan will prioritize whole foods, healthy fats, and a balanced macronutrient ratio with at least **${proteinTargetG}g** of protein daily (IBW × 1.2) to optimize metabolic flexibility and strength.$lifestyleNote";
    }
  }

  void _submitOnboarding() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dob = _calculateDob(widget.age);

      final response = await _apiClient.post(
        ApiEndpoints.onboarding,
        data: {
          'gender': widget.gender.toUpperCase(),
          'dob': dob,
          'height_cm': widget.height.toDouble(),
          'weight_kg': widget.weight,
          'activity_level_id': widget.activityLevelId,
          'goal_id': widget.goalId,
          'taste_preference_ids': widget.tastePreferenceIds,
          'medical_condition_ids': widget.medicalConditionIds,
          'symptom_ids': widget.symptomIds,
          'food_exclusions': widget.foodExclusions,
          'custom_medical_conditions': widget.customConditions,
          'smoking_habit': widget.smokingHabit ?? 'No, never',
          'alcohol_habit': widget.alcoholHabit ?? 'No, never',
        },
      );

      final data = response.data;
      _authService.setOnboardingDone(true);
      OnboardingDraftService.clear();

      if (!mounted) return;

      setState(() {
        _memberCode = data['member_code'];
      });

      Get.off(
        () => CongratulationsScreen(memberCode: _memberCode ?? ''),
        transition: Transition.cupertino,
      );
    } on DioException catch (e) {
      debugPrint('===== ONBOARDING DIO ERROR =====');
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Data: ${e.response?.data}');
      debugPrint('Message: ${e.message}');
      debugPrint('=================================');
      setState(() {
        _error =
            e.response?.data?['message'] ??
            'Onboarding failed (${e.response?.statusCode ?? "timeout"}). Please try again.';
      });
    } catch (e, stack) {
      debugPrint('===== ONBOARDING GENERIC ERROR =====');
      debugPrint('$e');
      debugPrint('$stack');
      debugPrint('=====================================');
      setState(() {
        _error = 'Connection error. Please check your network.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _calculateDob(int age) {
    final now = DateTime.now();
    final year = now.year - age;
    return '${year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void showActivationDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "ActivationDialog",
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) {
        return AlertDialog(
          backgroundColor: const Color(0xff090918),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.white.withOpacity(0.08), width: 1.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Glowing Icon Stack
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff00E5FF).withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff00E5FF).withOpacity(0.20),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.offline_bolt_rounded,
                    color: Color(0xff00E5FF),
                    size: 38,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Plan Activated!",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Congratulations! Your personalized 30-day adaptive nutrition & fitness plan has been generated and is now active.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Member Code: ${_memberCode ?? ''}",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xffFF00E5).withOpacity(0.85),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [Color(0xffFF00E5), Color(0xff7B61FF)],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      Get.offAllNamed('/main-navigation');
                    },
                    child: Center(
                      child: Text(
                        "Let's Go to Dashboard",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeInOutBack,
        );
        return ScaleTransition(scale: curve, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          /// BACKGROUND GLOW (Top Right / Middle Left)
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              height: 280,
              width: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF00E5).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff7B61FF).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1. TOP PROGRESS BAR & BACK BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Arrow
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 0.8,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),

                      // Step Indicator
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "STEP 10 OF 10",
                              style: GoogleFonts.outfit(
                                color: const Color(0xffFF00E5).withOpacity(0.9),
                                fontSize: 11,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(10, (index) {
                                final active = index <= 9; // Steps 1-10 active
                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: index == 9 ? 0 : 4,
                                    ),
                                    height: 3.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      gradient: active
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xffFF00E5),
                                                Color(0xffFF7A00),
                                              ],
                                            )
                                          : null,
                                      color: active
                                          ? null
                                          : Colors.white.withOpacity(0.10),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 2. TITLE & TEXT
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Your Health\nAssessment ",
                                  style: GoogleFonts.outfit(
                                    height: 1.1,
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: "Report",
                                  style: GoogleFonts.outfit(
                                    height: 1.1,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    foreground: Paint()
                                      ..shader =
                                          const LinearGradient(
                                            colors: [
                                              Color(0xffFF00E5),
                                              Color(0xff00E5FF),
                                            ],
                                          ).createShader(
                                            const Rect.fromLTWH(
                                              0.0,
                                              0.0,
                                              200.0,
                                              50.0,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Our AI health engine has processed your parameters to establish your metabolic blueprint.",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.60),
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// 3. PREMIUM BMI ARC GAUGE
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Outer glow backdrop
                                    Container(
                                      height: 190,
                                      width: 190,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: bmiColor.withOpacity(0.18),
                                            blurRadius: 48,
                                            spreadRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Dark inner circle background
                                    Container(
                                      height: 170,
                                      width: 170,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xff0a0a1a),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.05),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    // Custom Arc Gauge
                                    SizedBox(
                                      height: 170,
                                      width: 170,
                                      child: CustomPaint(
                                        painter: _BmiArcPainter(
                                          progress: (bmi / 40.0).clamp(
                                            0.0,
                                            1.0,
                                          ),
                                          color: bmiColor,
                                        ),
                                      ),
                                    ),
                                    // Center text content
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          bmi.toStringAsFixed(1),
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 38,
                                            fontWeight: FontWeight.w900,
                                            height: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "BMI",
                                          style: GoogleFonts.outfit(
                                            color: Colors.white.withOpacity(
                                              0.35,
                                            ),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Classification Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: bmiColor.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: bmiColor.withOpacity(0.45),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Text(
                                            bmiClassification,
                                            style: GoogleFonts.outfit(
                                              color: bmiColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                // Min / Max scale labels
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "0",
                                        style: GoogleFonts.outfit(
                                          color: Colors.white.withOpacity(0.25),
                                          fontSize: 9,
                                        ),
                                      ),
                                      Text(
                                        "40+",
                                        style: GoogleFonts.outfit(
                                          color: Colors.white.withOpacity(0.25),
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// 4. DETAILED REPORT CARDS GRID
                          Row(
                            children: [
                              Expanded(
                                child: buildMetricReportCard(
                                  title: "BMR",
                                  value: "${bmr.toInt()}",
                                  unit: "kcal",
                                  desc: "Basal Metabolic Rate",
                                  icon: Icons.local_fire_department_rounded,
                                  color: const Color(0xffFF5F6D),
                                  bgImage: "assets/new_images1/bmr.png",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildMetricReportCard(
                                  imageLeft: 25, // Anchored left
                                  imageTop: -35, // Scaled slightly larger
                                  imageBottom: -35,
                                  title: "IDEAL WEIGHT",
                                  value: ibw.toStringAsFixed(1),
                                  unit: "kg",
                                  desc: "Devine Formula (IBW)",
                                  icon: Icons.monitor_weight_outlined,
                                  color: const Color(0xff7B61FF),
                                  bgImage:
                                      "assets/new_images1/ideal_weight.png",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: buildMetricReportCard(
                                  imageRight:
                                      -20, // Shifted slightly left from default
                                  imageTop: -30, // Scaled slightly larger
                                  imageBottom: -30,
                                  title: "DAILY TDEE",
                                  value: "${tdee.toInt()}",
                                  unit: "kcal",
                                  desc: "Total Daily Energy\nExpenditure",
                                  icon: Icons.bolt_rounded,
                                  color: const Color(0xff00E5FF),
                                  bgImage: "assets/new_images1/daily_tdeee.png",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildMetricReportCard(
                                  imageRight: -5, // Shifted slightly left only
                                  title: "WEIGHT RATIO",
                                  value: "${pctIbw.toInt()}",
                                  unit: "%",
                                  desc: "Current / Ideal Weight",
                                  icon: Icons.show_chart_rounded,
                                  color: const Color(0xffFF7A00),
                                  bgImage:
                                      "assets/new_images1/weight ratio.png",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          /// 4.5. DYNAMIC MACROS CALCULATION SECTION (As per Excel: Carb 45%, Protein IBW*1.2, Fat 25%)
                          Text(
                            "RECOMMENDED DAILY MACROS ($targetCalories KCAL)",
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.90),
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: buildMacroCard(
                                  title: "CARBS",
                                  grams: "${carbsTargetG}g",
                                  color: const Color(0xff00E5FF),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: buildMacroCard(
                                  title: "PROTEIN",
                                  grams: "${proteinTargetG}g",
                                  color: const Color(0xffFF00E5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: buildMacroCard(
                                  title: "FATS",
                                  grams: "${fatTargetG}g",
                                  color: const Color(0xffFF7A00),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// 5. AI PERSONALIZED SUGGESTIONS BOX
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.03),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.12),
                                    width: 0.8,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xffFF00E5),
                                                Color(0xff7B61FF),
                                              ],
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.auto_awesome_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "AI RECOMMENDATION",
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    buildRichMarkdownText(
                                      getAISuggestionText(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffFF3B30).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _error!,
                        style: GoogleFonts.inter(
                          color: const Color(0xffFF3B30),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  /// 6. START PLAN / CTA BUTTON
                  Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffB100FF),
                          Color(0xffFF5F6D),
                          Color(0xffFF7A00),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffB100FF).withOpacity(0.30),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _isLoading ? null : _submitOnboarding,
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Continue",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProgress(bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      height: 3,
      width: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5),
        gradient: active
            ? const LinearGradient(
                colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
              )
            : null,
        color: active ? null : Colors.white.withOpacity(0.12),
      ),
    );
  }

  Widget buildMetricReportCard({
    required String title,
    required String value,
    required String unit,
    required String desc,
    required IconData icon,
    required Color color,
    required String bgImage,
    double? imageTop,
    double? imageBottom,
    double? imageRight,
    double? imageLeft,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xff151520),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.0),
        ),
        child: Stack(
          children: [
            // Background Image shifted
            Positioned(
              top: imageTop ?? -10,
              bottom: imageBottom ?? -10,
              right: imageLeft != null ? null : (imageRight ?? -30),
              left: imageLeft,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  const Color(0xff151520).withOpacity(0.3),
                  BlendMode.darken,
                ),
                child: Image.asset(bgImage, fit: BoxFit.fitHeight),
              ),
            ),
            // Gradient Overlay and Content
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xff151520).withOpacity(0.8),
                      const Color(0xff151520).withOpacity(0.2),
                      const Color(0xff151520).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        /* Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        const SizedBox(width: 12), */
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              value,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              unit,
                              style: GoogleFonts.outfit(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(height: 2, width: 24, color: color),
                        const SizedBox(height: 12),
                        Text(
                          desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMacroCard({
    required String title,
    required String grams,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                grams,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A tiny custom markdown highlights parser (handles simple **bold** tags)
  Widget buildRichMarkdownText(String text) {
    List<TextSpan> spans = [];
    RegExp regExp = RegExp(r"\*\*(.*?)\*\*");
    int lastMatchEnd = 0;

    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    for (var match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.65),
              fontSize: 11.5,
              height: 1.45,
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            height: 1.45,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.65),
            fontSize: 11.5,
            height: 1.45,
          ),
        ),
      );
    }

    return Text.rich(TextSpan(children: spans));
  }
}

class _BmiArcPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;

  _BmiArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    const startAngle = 2.35; // ~135 degrees (bottom-left)
    const sweepFull = 4.71; // 270 degrees full sweep

    // 1. Background track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepFull,
      false,
      trackPaint,
    );

    // 2. Tick marks at 18, 25, 30 thresholds
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final threshold in [18.0 / 40.0, 25.0 / 40.0, 30.0 / 40.0]) {
      final angle = startAngle + sweepFull * threshold;
      final outerPt = Offset(
        center.dx + (radius + 8) * cos(angle),
        center.dy + (radius + 8) * sin(angle),
      );
      final innerPt = Offset(
        center.dx + (radius - 8) * cos(angle),
        center.dy + (radius - 8) * sin(angle),
      );
      canvas.drawLine(innerPt, outerPt, tickPaint);
    }

    if (progress <= 0) return;

    // 3. Glow shadow arc (wider, blurred)
    final glowPaint = Paint()
      ..color = color.withOpacity(0.25)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepFull * progress,
      false,
      glowPaint,
    );

    // 4. Main filled arc with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradientPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepFull * progress,
        colors: [color.withOpacity(0.7), color],
      ).createShader(rect)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      sweepFull * progress,
      false,
      gradientPaint,
    );

    // 5. Bright tip dot
    final tipAngle = startAngle + sweepFull * progress;
    final tipX = center.dx + radius * cos(tipAngle);
    final tipY = center.dy + radius * sin(tipAngle);

    final tipGlowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(tipX, tipY), 9, tipGlowPaint);

    final tipDotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(tipX, tipY), 5, tipDotPaint);

    final tipColorPaint = Paint()..color = color;
    canvas.drawCircle(Offset(tipX, tipY), 3.5, tipColorPaint);
  }

  double cos(double angle) => dart_math.cos(angle);
  double sin(double angle) => dart_math.sin(angle);

  @override
  bool shouldRepaint(_BmiArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
