import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/onboarding_draft_service.dart';
import 'height_screen.dart';

class AgeScreen extends StatefulWidget {
  final String goalTitle;
  final int goalId;
  final String gender;

  const AgeScreen({
    super.key,
    required this.goalTitle,
    required this.goalId,
    required this.gender,
  });

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _ThemeColors {
  static const purple = Color(0xff7B61FF);
  static const pink = Color(0xffFF00E5);
  static const darkBg = Color(0xff050510);
}

class _AgeScreenState extends State<AgeScreen> {
  int selectedAge = 24;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Load from draft if exists
    final draft = OnboardingDraftService.getDraft();
    if (draft['age'] != null) {
      selectedAge = draft['age'] as int;
    }
    _scrollController = FixedExtentScrollController(initialItem: selectedAge - 10);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getAgeImage() {
    final isMale = widget.gender == "Male";
    if (selectedAge <= 18) {
      return isMale ? "assets/new_images/boy_age.png" : "assets/new_images/girl_age.png";
    } else if (selectedAge <= 45) {
      return isMale ? "assets/new_images/boy_young_age.png" : "assets/new_images/girl_young_age.png";
    } else {
      return isMale ? "assets/new_images/boy_old_age.png" : "assets/new_images/girl_old_age.png";
    }
  }

  void _proceed() {
    OnboardingDraftService.saveStep3(age: selectedAge);
    Get.to(
      () => HeightScreen(
        goalTitle: widget.goalTitle,
        goalId: widget.goalId,
        gender: widget.gender,
        age: selectedAge,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.gender == "Male"
        ? _ThemeColors.purple
        : _ThemeColors.pink;

    // Premium dynamic gender gradients
    final buttonGradient = widget.gender == "Male"
        ? const LinearGradient(colors: [_ThemeColors.purple, Color(0xff00F0FF)])
        : const LinearGradient(colors: [_ThemeColors.pink, Color(0xffFF7A00)]);

    return Scaffold(
      backgroundColor: _ThemeColors.darkBg,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -120,
            right: -120,
            child: Container(
              height: 360,
              width: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [themeColor.withOpacity(0.22), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              height: 340,
              width: 340,
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

          // Absolute Positioned Avatar on the right side (fills height beautifully)
          Positioned(
            right: -25, // shifted slightly left
            bottom: 80, // slightly above the next button
            child: IgnorePointer(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 550,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Avatar background glow
                    Container(
                      height: 450,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            themeColor.withOpacity(0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.5,
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        _getAgeImage(),
                        height: 480,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            widget.gender == "Male"
                                ? Icons.accessibility_new_rounded
                                : Icons.woman_rounded,
                            size: 260,
                            color: themeColor.withOpacity(0.50),
                          );
                        },
                      ),
                    ),
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
                  // Back Button & Progress steps
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
                              "STEP 3 OF 10",
                              style: GoogleFonts.outfit(
                                color: themeColor.withOpacity(0.9),
                                fontSize: 11,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(10, (index) {
                                final active = index <= 2; // Steps 1, 2, 3 active
                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: index == 9 ? 0 : 4),
                                    height: 3.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      gradient: active ? buttonGradient : null,
                                      color: active ? null : Colors.white.withOpacity(0.10),
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
                          text: "Age?",
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  Color(0xffFF00E5),
                                  Color(0xffFF7A00),
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
                    "Age helps us estimate your metabolism and calorie needs.",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 13,
                    ),
                  ),

                  const Spacer(),

                  // Row with scroll wheel on the left
                  Row(
                    children: [
                      SizedBox(
                        width: 180,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            // Neon horizontal dividers
                            Positioned(
                              top: (280 / 2) - 35,
                              left: 0,
                              right: 30,
                              child: Container(
                                height: 1.5,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xffFF00E5),
                                      Color(0xffFF7A00),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: (280 / 2) + 35,
                              left: 0,
                              right: 30,
                              child: Container(
                                height: 1.5,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xffFF00E5),
                                      Color(0xffFF7A00),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // The wheel scroll view
                            ListWheelScrollView.useDelegate(
                              controller: _scrollController,
                              itemExtent: 70,
                              perspective: 0.0015,
                              diameterRatio: 1.8,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedAge = index + 10;
                                });
                                HapticFeedback.selectionClick();
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  final ageNum = index + 10;
                                  final isSelected = selectedAge == ageNum;
                                  final difference = (selectedAge - ageNum).abs();
                                  final opacity = (1.0 - (difference * 0.35)).clamp(0.12, 1.0);

                                  if (isSelected) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text(
                                              ageNum.toString(),
                                              style: GoogleFonts.outfit(
                                                color: Colors.white,
                                                fontSize: 54,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Years",
                                              style: GoogleFonts.outfit(
                                                color: Colors.white.withOpacity(0.9),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Opacity(
                                          opacity: opacity,
                                          child: Text(
                                            ageNum.toString(),
                                            style: GoogleFonts.outfit(
                                              color: Colors.white.withOpacity(0.4),
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                childCount: 91,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),

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
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
