import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';
import '../../../services/auth_service.dart';
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
  String bmiClassification = "Normal Weight";
  Color bmiColor = const Color(0xff00E5FF);

  @override
  void initState() {
    super.initState();
    calculateMetrics();
  }

  void calculateMetrics() {
    // 1. BMI = Weight (kg) / Height^2 (m)
    double heightInMeters = widget.height / 100.0;
    if (heightInMeters > 0) {
      bmi = widget.weight / (heightInMeters * heightInMeters);
    } else {
      bmi = 22.0;
    }

    if (bmi.isNaN || bmi.isInfinite) {
      bmi = 22.0;
    }

    if (bmi < 18.5) {
      bmiClassification = "Underweight";
      bmiColor = const Color(0xffFFD200); // Amber Yellow
    } else if (bmi < 25.0) {
      bmiClassification = "Normal Weight";
      bmiColor = const Color(0xff00E5FF); // Vibrant Cyan
    } else if (bmi < 30.0) {
      bmiClassification = "Overweight";
      bmiColor = const Color(0xffFF7A00); // Vibrant Orange
    } else {
      bmiClassification = "Obese";
      bmiColor = const Color(0xffFF3B30); // Deep Red
    }

    // 2. BMR (Mifflin-St Jeor)
    if (widget.gender == "Male") {
      bmr = 10 * widget.weight + 6.25 * widget.height - 5 * widget.age + 5;
    } else {
      bmr = 10 * widget.weight + 6.25 * widget.height - 5 * widget.age - 161;
    }

    if (bmr.isNaN || bmr.isInfinite || bmr <= 0) {
      bmr = 1500.0;
    }

    // 3. IBW (Devine Formula 1974)
    double heightInInches = widget.height / 2.54;
    if (widget.gender == "Male") {
      ibw = 50.0 + 2.3 * (heightInInches - 60.0);
    } else {
      ibw = 45.5 + 2.3 * (heightInInches - 60.0);
    }
    // Fallback adjustment for shorter heights
    if (widget.height < 152) {
      ibw = 45.0 + 0.8 * (widget.height - 150.0);
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

    // 5. TDEE
    double activityMultiplier;
    switch (widget.activityLevelId) {
      case 1:
        activityMultiplier = 1.2;
        break;
      case 2:
        activityMultiplier = 1.375;
        break;
      case 3:
        activityMultiplier = 1.55;
        break;
      case 4:
        activityMultiplier = 1.725;
        break;
      case 5:
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.2;
    }
    tdee = bmr * activityMultiplier;
    if (tdee.isNaN || tdee.isInfinite || tdee <= 0) {
      tdee = bmr * 1.2;
    }
  }

  String getAISuggestionText() {
    String goal = widget.goalTitle.toLowerCase();
    int targetCalories;
    if (goal.contains("loss") || goal.contains("burn")) {
      targetCalories = (tdee - 500).toInt();
      return "To achieve your goal of **${widget.goalTitle}**, your AI target daily intake is **$targetCalories kcal** (a healthy 500 kcal deficit). With your **${widget.activityLevelName}** lifestyle, we recommend incorporating 150 mins of moderate-intensity cardio weekly paired with highly-adaptive protein-rich meals to preserve lean muscle tissue while maximizing fat oxidation.";
    } else if (goal.contains("gain") || goal.contains("muscle")) {
      targetCalories = (tdee + 300).toInt();
      int proteinTarget = (widget.weight * 2.0).toInt();
      return "To achieve your goal of **${widget.goalTitle}**, your AI target daily intake is **$targetCalories kcal** (a clean 300 kcal surplus). With your **${widget.activityLevelName}** lifestyle, we recommend progressive resistance training 4-5 times a week, paired with an adaptive macro profile containing at least **${proteinTarget}g** of high-quality protein daily.";
    } else {
      targetCalories = tdee.toInt();
      return "To maintain peak fitness and daily energy, your AI target daily intake is **$targetCalories kcal**. Since your lifestyle is **${widget.activityLevelName}**, your adaptive plan will prioritize whole foods, healthy fats, and a balanced macronutrient ratio to optimize metabolic flexibility, cardiovascular strength, and cognitive performance.";
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
        },
      );

      final data = response.data;
      _authService.setOnboardingDone(true);

      if (!mounted) return;

      setState(() {
        _memberCode = data['member_code'];
      });

      Get.off(
        () => CongratulationsScreen(memberCode: _memberCode ?? ''),
        transition: Transition.cupertino,
      );
    } on DioException catch (e) {
      setState(() {
        _error =
            e.response?.data?['message'] ??
            'Onboarding failed. Please try again.';
      });
    } catch (e) {
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "STEP 6 OF 6",
                            style: GoogleFonts.outfit(
                              color: const Color(0xffFF00E5).withOpacity(0.9),
                              fontSize: 11,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              buildProgress(true),
                              buildProgress(true),
                              buildProgress(true),
                              buildProgress(true),
                              buildProgress(true),
                              buildProgress(true),
                            ],
                          ),
                        ],
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
                                      ..shader = const LinearGradient(
                                        colors: [
                                          Color(0xffFF00E5),
                                          Color(0xff00E5FF),
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(0.0, 0.0, 200.0, 50.0),
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

                          /// 3. DYNAMIC METRIC GAUGE (Circular Visual)
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glow backdrop
                                Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: bmiColor.withOpacity(0.04),
                                    boxShadow: [
                                      BoxShadow(
                                        color: bmiColor.withOpacity(0.12),
                                        blurRadius: 30,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                // Outer Ring
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: CircularProgressIndicator(
                                    value: bmi / 40.0 > 1.0 ? 1.0 : bmi / 40.0,
                                    strokeWidth: 4.5,
                                    backgroundColor: Colors.white.withOpacity(0.04),
                                    valueColor: AlwaysStoppedAnimation<Color>(bmiColor),
                                  ),
                                ),
                                // Inner Ring
                                SizedBox(
                                  height: 104,
                                  width: 104,
                                  child: CircularProgressIndicator(
                                    value: pctIbw / 200.0 > 1.0 ? 1.0 : pctIbw / 200.0,
                                    strokeWidth: 1.5,
                                    backgroundColor: Colors.white.withOpacity(0.02),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      const Color(0xffFF7A00).withOpacity(0.35),
                                    ),
                                  ),
                                ),
                                // Value Text
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      bmi.toStringAsFixed(1),
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "BMI",
                                      style: GoogleFonts.outfit(
                                        color: Colors.white.withOpacity(0.40),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
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
                                  value: "${bmr.toInt()} kcal",
                                  desc: "Basal Metabolic Rate",
                                  icon: Icons.local_fire_department_rounded,
                                  color: const Color(0xffFF5F6D),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildMetricReportCard(
                                  title: "IDEAL WEIGHT",
                                  value: "${ibw.toStringAsFixed(1)} kg",
                                  desc: "Devine Formula IBW",
                                  icon: Icons.scale_rounded,
                                  color: const Color(0xff7B61FF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: buildMetricReportCard(
                                  title: "DAILY TDEE",
                                  value: "${tdee.toInt()} kcal",
                                  desc: "Active Energy Needs",
                                  icon: Icons.offline_bolt_rounded,
                                  color: const Color(0xff00E5FF),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildMetricReportCard(
                                  title: "WEIGHT RATIO",
                                  value: "${pctIbw.toInt()}%",
                                  desc: "Actual / Ideal Weight",
                                  icon: Icons.analytics_rounded,
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
                                            borderRadius: BorderRadius.circular(10),
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
                                    buildRichMarkdownText(getAISuggestionText()),
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
                    height: 46,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffB100FF),
                          Color(0xffFF5F6D),
                          Color(0xffFF7A00),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffB100FF).withOpacity(0.35),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(23),
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
                                  "Unlock & Start 30-Day Plan",
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
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.1),
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 9,
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
