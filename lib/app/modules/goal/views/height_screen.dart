import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/onboarding_draft_service.dart';
import 'weight_screen.dart';

class HeightScreen extends StatefulWidget {
  final String goalTitle;
  final int goalId;
  final String gender;
  final int age;

  const HeightScreen({
    super.key,
    required this.goalTitle,
    required this.goalId,
    required this.gender,
    required this.age,
  });

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  int selectedHeight = 180;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Load from draft if exists
    final draft = OnboardingDraftService.getDraft();
    if (draft['height'] != null) {
      selectedHeight = draft['height'] as int;
    }
    _scrollController = FixedExtentScrollController(
      initialItem: selectedHeight - 100,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _proceed() {
    OnboardingDraftService.saveStep4(height: selectedHeight);
    Get.to(
      () => WeightScreen(
        goalTitle: widget.goalTitle,
        goalId: widget.goalId,
        gender: widget.gender,
        age: widget.age,
        height: selectedHeight,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.gender == "Male"
        ? const Color(0xff7B61FF)
        : const Color(0xffFF00E5);

    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -100,
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
            right: -100,
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

          // Absolute Positioned Avatar on the left side (fills height beautifully)
          Positioned(
            left: -85, // shifted to the left
            bottom: 15, // lower positioning (moved down)
            child: IgnorePointer(
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width *
                    0.75, // even wider container
                height: 650, // even taller container
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Avatar background glow
                    Container(
                      height: 550,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            themeColor.withOpacity(0.06),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Standing character shape (scales dynamically based on height)
                    Transform.scale(
                      scale: 1.4 + ((selectedHeight - 100) / 120.0) * 0.5, // scales from 1.4 (at 100cm) to 1.9 (at 220cm)
                      alignment:
                          Alignment.bottomCenter, // anchor scaling to bottom
                      child: Image.asset(
                        widget.gender == "Male"
                            ? "assets/new_images/man_height.png"
                            : "assets/new_images/female_height.png",
                        height: 540, // taller image
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            widget.gender == "Male"
                                ? Icons.accessibility_new_rounded
                                : Icons.woman_rounded,
                            size: 280,
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
                              "STEP 4 OF 10",
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
                                final active = index <= 3; // Steps 1-4 active
                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: index == 9 ? 0 : 4),
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
                          text: "Height?",
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
                    "Enter your height for accurate calculations.",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 13,
                    ),
                  ),

                  const Spacer(),

                  // Height visual contents: Standing Avatar, Ruler Tape, Value display
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 3, child: const SizedBox()),
                      const SizedBox(
                        width: 25,
                      ), // shifts ruler scale slightly to the right
                      // 2. Vertical Scrollable Measuring Ruler Tape
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 450,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              // ── GLOWING NEON BAR (thin line, massive glow spread) ──
                              Positioned(
                                left: 3,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 6,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        themeColor.withOpacity(0.0),
                                        themeColor,
                                        themeColor,
                                        themeColor.withOpacity(0.0),
                                      ],
                                      stops: const [0.0, 0.15, 0.85, 1.0],
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),

                              // Arrow indicator pointing from bar rightward
                              Positioned(
                                left: 8,
                                child: Icon(
                                  Icons.arrow_right_rounded,
                                  color: themeColor,
                                  size: 26,
                                ),
                              ),

                              // Ruler tick marks — start after the bar, extend right
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ListWheelScrollView.useDelegate(
                                  controller: _scrollController,
                                  itemExtent: 14,
                                  perspective: 0.002,
                                  diameterRatio: 2.2,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (index) {
                                    setState(() {
                                      selectedHeight = index + 100;
                                    });
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    builder: (context, index) {
                                      final currentCm = index + 100;
                                      final isMultipleOf10 =
                                          currentCm % 10 == 0;
                                      final isMultipleOf5 = currentCm % 5 == 0;
                                      final isSelected =
                                          selectedHeight == currentCm;

                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: isMultipleOf10 ? 2.5 : 1.2,
                                            width: isMultipleOf10
                                                ? 36
                                                : (isMultipleOf5 ? 24 : 14),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.white.withOpacity(
                                                      isMultipleOf10
                                                          ? 0.70
                                                          : 0.30,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          if (isMultipleOf10)
                                            Text(
                                              currentCm.toString(),
                                              style: GoogleFonts.outfit(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.white.withOpacity(
                                                        0.45,
                                                      ),
                                                fontSize: isSelected ? 13 : 11,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                    childCount: 121, // 100 to 220 cm
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 3. Large height display in cm
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "$selectedHeight\n",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      height: 1.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "cm",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white.withOpacity(0.40),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
