import 'dart:ui';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
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
                  colors: [
                    const Color(0xffFF00E5).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -120,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff7B61FF).withOpacity(0.15),
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
                            "STEP 3 OF 7",
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
                              final active = index <= 2; // Steps 1, 2, 3 active
                              return Container(
                                margin: const EdgeInsets.only(right: 6),
                                height: 3.5,
                                width: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: active
                                      ? const LinearGradient(
                                          colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                                        )
                                      : null,
                                  color: active ? null : Colors.white.withOpacity(0.10),
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
                          text: "Age?",
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xffFF00E5), Color(0xff7B61FF)],
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

                  const Spacer(flex: 2),

                  // Glowing circular dial / scroll wheel area
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow backdrop behind wheel
                        Container(
                          height: 220,
                          width: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff7B61FF).withOpacity(0.08),
                                blurRadius: 40,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        // Outer thin glowing circle line
                        Container(
                          height: 220,
                          width: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xff7B61FF).withOpacity(0.20),
                              width: 1.0,
                            ),
                          ),
                        ),
                        // Inner ring line
                        Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xffFF00E5).withOpacity(0.10),
                              width: 1.0,
                            ),
                          ),
                        ),
                        // Horizontal divider bounds indicating selected area
                        Positioned(
                          child: Container(
                            height: 48,
                            width: 160,
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                  color: Colors.white.withOpacity(0.12),
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Age ListWheelScrollView
                        SizedBox(
                          height: 200,
                          width: 180,
                          child: ListWheelScrollView.useDelegate(
                            controller: _scrollController,
                            itemExtent: 48,
                            perspective: 0.003,
                            diameterRatio: 1.4,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedAge = index + 10;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                final ageNum = index + 10;
                                final isSelected = selectedAge == ageNum;
                                return Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        ageNum.toString(),
                                        style: GoogleFonts.outfit(
                                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.25),
                                          fontSize: isSelected ? 32 : 22,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 8),
                                        Text(
                                          "Years",
                                          style: GoogleFonts.outfit(
                                            color: Colors.white.withOpacity(0.50),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                              childCount: 91, // 10 to 100
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 3),

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
