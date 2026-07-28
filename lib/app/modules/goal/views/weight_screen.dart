import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/onboarding_draft_service.dart';
import 'activity_level_screen.dart';

class WeightScreen extends StatefulWidget {
  final String goalTitle;
  final int goalId;
  final String gender;
  final int age;
  final int height;

  const WeightScreen({
    super.key,
    required this.goalTitle,
    required this.goalId,
    required this.gender,
    required this.age,
    required this.height,
  });

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _ThemeColors {
  static const purple = Color(0xff7B61FF);
  static const pink = Color(0xffFF00E5);
}

class _WeightScreenState extends State<WeightScreen> {
  double selectedWeight = 70.0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Load from draft if exists
    final draft = OnboardingDraftService.getDraft();
    if (draft['weight'] != null) {
      selectedWeight = (draft['weight'] as num).toDouble();
    }
    // We represent weight from 30kg to 180kg as integer pages
    _pageController = PageController(
      initialPage: (selectedWeight - 30).round(),
      viewportFraction: 0.16,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _proceed() {
    OnboardingDraftService.saveStep5(weight: selectedWeight);
    Get.to(
      () => ActivityLevelScreen(
        goalTitle: widget.goalTitle,
        goalId: widget.goalId,
        gender: widget.gender,
        age: widget.age,
        height: widget.height,
        weight: selectedWeight,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.gender == "Male"
        ? _ThemeColors.purple
        : _ThemeColors.pink;

    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [themeColor.withOpacity(0.18), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF7A00).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button & Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "STEP 5 OF 7",
                            style: GoogleFonts.outfit(
                              color: const Color(0xffFF00E5).withOpacity(0.9),
                              fontSize: 11,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: List.generate(7, (index) {
                              final active =
                                  index <= 4; // Steps 1, 2, 3, 4, 5 active
                              return Container(
                                margin: const EdgeInsets.only(right: 6),
                                height: 3.5,
                                width: 32,
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
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Title
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "What's your\n",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                        TextSpan(
                          text: "Weight?",
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                            foreground: Paint()
                              ..shader =
                                  const LinearGradient(
                                    colors: [
                                      Color(0xffFF00E5),
                                      Color(0xff7B61FF),
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
                    "Enter your current weight.",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 13,
                    ),
                  ),

                  const Spacer(),

                  // Weight visual layout
                  Row(
                    children: [
                      // 1. Large Weight Display Text
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${selectedWeight.toInt()}\n",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 64,
                                    fontWeight: FontWeight.w900,
                                    height: 1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: "kg",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white.withOpacity(0.40),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 2. Avatar standing on a scale platform
                      Expanded(
                        flex: 6,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Glowing Scale Platform
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                height: 90,
                                width: 180,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.elliptical(90, 45),
                                  ),
                                  gradient: RadialGradient(
                                    colors: [
                                      themeColor.withOpacity(0.40),
                                      themeColor.withOpacity(0.0),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: themeColor.withOpacity(
                                      0.95,
                                    ), // Vibrant solid neon border
                                    width: 2.0, // thicker border
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeColor.withOpacity(
                                        0.45,
                                      ), // strong back glow
                                      blurRadius: 25,
                                      spreadRadius: 3,
                                    ),
                                    BoxShadow(
                                      color: themeColor.withOpacity(
                                        0.25,
                                      ), // wider ambient glow
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              // Character model standing on the scale
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Image.asset(
                                  widget.gender == "Male"
                                      ? "assets/new_images/man_weight.png"
                                      : "assets/new_images/female_weight.png",
                                  height: 280,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      widget.gender == "Male"
                                          ? Icons.accessibility_new_rounded
                                          : Icons.woman_rounded,
                                      size: 200,
                                      color: themeColor.withOpacity(0.60),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),

                  // 3. Horizontal scrolling wheel measuring scale
                  SizedBox(
                    height: 90,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        // Center Indicator Tick Line
                        Container(
                          height: 38,
                          width: 3.5,
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: themeColor.withOpacity(0.50),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        // PageView scale ticks
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: 151, // 30 kg to 180 kg
                            onPageChanged: (page) {
                              setState(() {
                                selectedWeight = (page + 30).toDouble();
                              });
                            },
                            itemBuilder: (context, index) {
                              final currentWeightVal = index + 30;
                              final isMultipleOf5 = currentWeightVal % 5 == 0;
                              final isSelected =
                                  selectedWeight.toInt() == currentWeightVal;

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Tick Line
                                  Container(
                                    height: isMultipleOf5 ? 24 : 14,
                                    width: isSelected ? 2.5 : 1.5,
                                    color: isSelected
                                        ? themeColor
                                        : Colors.white.withOpacity(
                                            isMultipleOf5 ? 0.35 : 0.12,
                                          ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Weight Number for multiples of 5
                                  if (isMultipleOf5)
                                    Text(
                                      currentWeightVal.toString(),
                                      style: GoogleFonts.outfit(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.25),
                                        fontSize: isSelected ? 13 : 11,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Next Button
                  Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0xffB100FF), Color(0xffFF7A00)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffB100FF).withOpacity(0.30),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _proceed,
                        child: Center(
                          child: Text(
                            "Next",
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
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
