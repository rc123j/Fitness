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
    _pageController = PageController(
      initialPage: (selectedWeight - 30).round(),
      viewportFraction: 0.13, // ~7-8 items visible at once
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "STEP 5 OF 10",
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
                                final active = index <= 4; // Steps 1-5 active
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

                  // Weight visual layout
                  Expanded(
                    flex: 9,
                    child: Row(
                      children: [
                        // 1. Large Weight Display Text
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      "${selectedWeight.toInt()}",
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 68,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "kg",
                                      style: GoogleFonts.outfit(
                                        color: themeColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 3,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    borderRadius: BorderRadius.circular(1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeColor.withOpacity(0.50),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 2. Avatar standing on a scale platform
                        Expanded(
                          flex: 7,
                          child: SizedBox.expand(
                            child: Image.asset(
                              widget.gender == "Male"
                                  ? "assets/new_images/man_weight.png"
                                  : "assets/new_images/female_weight.png",
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
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 3. Horizontal scrolling weight scale — stable PageView
                  SizedBox(
                    height: 110,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // The scrollable numbers + ticks
                        PageView.builder(
                          controller: _pageController,
                          itemCount: 151, // 30 kg → 180 kg
                          onPageChanged: (page) {
                            setState(() {
                              selectedWeight = (page + 30).toDouble();
                            });
                          },
                          itemBuilder: (context, index) {
                            final currentVal = index + 30;
                            final isSelected =
                                selectedWeight.toInt() == currentVal;
                            final distanceFromSelected =
                                (selectedWeight - currentVal).abs();
                            final isNear = distanceFromSelected < 2.5;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Number label
                                Text(
                                  currentVal.toString(),
                                  style: GoogleFonts.outfit(
                                    color: isSelected
                                        ? Colors.white
                                        : isNear
                                        ? Colors.white.withOpacity(0.45)
                                        : Colors.white.withOpacity(0.18),
                                    fontSize: isSelected ? 20 : 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w900
                                        : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Tick mark
                                Container(
                                  height: isSelected ? 30 : (isNear ? 18 : 12),
                                  width: isSelected ? 2.5 : 1.5,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? themeColor
                                        : Colors.white.withOpacity(
                                            isNear ? 0.35 : 0.12,
                                          ),
                                    borderRadius: BorderRadius.circular(1),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: themeColor.withOpacity(
                                                0.70,
                                              ),
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            );
                          },
                        ),
                        // Static center indicator needle overlay
                        IgnorePointer(
                          child: Positioned(
                            bottom: 8,
                            child: Container(
                              height: 2,
                              width: 36,
                              decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius: BorderRadius.circular(1),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withOpacity(0.70),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
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
                        onTap: _proceed,
                        child: Center(
                          child: Text(
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
