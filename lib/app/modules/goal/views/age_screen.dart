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

  Widget _buildAgeDisplayHeader(Color themeColor) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "$selectedAge",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "years old",
                style: GoogleFonts.outfit(
                  color: themeColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Container(
            height: 3,
            width: 90,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(1.5),
              boxShadow: [
                BoxShadow(
                  color: themeColor.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCylinderDial(Color themeColor) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 240,
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Highlight Selected Area Background Overlay
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 52,
                      width: 260,
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: themeColor.withOpacity(0.18),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: themeColor.withOpacity(0.06),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Neon lines indicators
                Positioned(
                  top: 94,
                  child: Container(
                    height: 1,
                    width: 240,
                    color: themeColor.withOpacity(0.20),
                  ),
                ),
                Positioned(
                  bottom: 94,
                  child: Container(
                    height: 1,
                    width: 240,
                    color: themeColor.withOpacity(0.20),
                  ),
                ),

                // Age Scroll ListWheel
                SizedBox(
                  height: 220,
                  child: ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 52,
                    perspective: 0.0035,
                    diameterRatio: 1.35,
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
                        final opacity = (1.0 - (difference * 0.28)).clamp(0.10, 1.0);
                        final scale = (1.0 - (difference * 0.12)).clamp(0.70, 1.0);

                        return Center(
                          child: Transform.scale(
                            scale: scale,
                            child: Opacity(
                              opacity: opacity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Left Cylinder Tick Line
                                  Container(
                                    width: isSelected ? 24 : 12,
                                    height: isSelected ? 2.5 : 1.0,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isSelected
                                            ? [themeColor.withOpacity(0.0), themeColor]
                                            : [Colors.white.withOpacity(0.0), Colors.white.withOpacity(0.25)],
                                      ),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Age Number Display
                                  SizedBox(
                                    width: 76,
                                    child: Center(
                                      child: Text(
                                        ageNum.toString(),
                                        style: GoogleFonts.outfit(
                                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                                          fontSize: isSelected ? 38 : 22,
                                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Right Cylinder Tick Line
                                  Container(
                                    width: isSelected ? 24 : 12,
                                    height: isSelected ? 2.5 : 1.0,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isSelected
                                            ? [themeColor, themeColor.withOpacity(0.0)]
                                            : [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.0)],
                                      ),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: 91, // Range 10 to 100
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
                              ..shader = LinearGradient(
                                colors: [themeColor, themeColor.withOpacity(0.6)],
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
                    "This helps us estimate your metabolism and basic metabolic rate.",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 13,
                    ),
                  ),

                  const Spacer(),

                  // Selected Age Text View
                  _buildAgeDisplayHeader(themeColor),

                  const Spacer(),

                  // Semicircular tactile Cylinder scroll dial
                  _buildCylinderDial(themeColor),

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
