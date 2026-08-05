import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/onboarding_draft_service.dart';
import 'age_screen.dart';

class GenderScreen extends StatefulWidget {
  final String goalTitle;
  final int goalId;

  const GenderScreen({
    super.key,
    required this.goalTitle,
    required this.goalId,
  });

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String selectedGender = "Male";

  @override
  void initState() {
    super.initState();
    // Load from draft if exists
    final draft = OnboardingDraftService.getDraft();
    if (draft['gender'] != null && draft['gender'].toString().isNotEmpty) {
      selectedGender = draft['gender'];
    }
  }

  void _proceed() {
    OnboardingDraftService.saveStep2(gender: selectedGender);
    Get.to(
      () => AgeScreen(
        goalTitle: widget.goalTitle,
        goalId: widget.goalId,
        gender: selectedGender,
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
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff7B61FF).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 250,
            right: -120,
            child: Container(
              height: 350,
              width: 350,
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

          SafeArea(
            child: Stack(
              children: [
                // ── FULL-SCREEN CHARACTER IMAGE (behind UI) ──────────────────
                Positioned(
                  bottom: -10,
                  left: 0,
                  right: 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve:
                        Curves.easeOutBack, // Playful bounce at the end
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          final slideAnimation =
                              Tween<Offset>(
                                begin: const Offset(
                                  0.0,
                                  0.06,
                                ), // Slides up from bottom
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: const Interval(
                                    0.0,
                                    1.0,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              );

                          final scaleAnimation =
                              Tween<double>(
                                begin: 0.92, // Grows slightly
                                end: 1.0,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: const Interval(
                                    0.0,
                                    1.0,
                                    curve: Curves.easeOutBack,
                                  ),
                                ),
                              );

                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: slideAnimation,
                              child: ScaleTransition(
                                scale: scaleAnimation,
                                child: child,
                              ),
                            ),
                          );
                        },
                    child: Transform.scale(
                      scale: 1.22,
                      child: Image.asset(
                        selectedGender == "Male"
                            ? "assets/new_images/male_gender.png"
                            : "assets/new_images/female_gender.png",
                        key: ValueKey<String>(selectedGender),
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            selectedGender == "Male"
                                ? Icons.accessibility_new_rounded
                                : Icons.woman_rounded,
                            size: 300,
                            color:
                                (selectedGender == "Male"
                                        ? const Color(0xff7B61FF)
                                        : const Color(0xffFF00E5))
                                    .withOpacity(0.80),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // ── FOREGROUND UI ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
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
                                  "STEP 2 OF 10",
                                  style: GoogleFonts.outfit(
                                    color: const Color(
                                      0xffFF00E5,
                                    ).withOpacity(0.9),
                                    fontSize: 11,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: List.generate(10, (index) {
                                    final active = index <= 1;
                                    return Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          right: index == 9 ? 0 : 4,
                                        ),
                                        height: 3.5,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
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
                              text: "Gender?",
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
                        "This helps us create a plan personalized for you.",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.50),
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Gender Cards Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildGenderButton(
                              gender: "Male",
                              imagePath: "assets/new_images/male_icon.png",
                              color: const Color(0xff7B61FF),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGenderButton(
                              gender: "Female",
                              imagePath: "assets/new_images/female_icon.png",
                              color: const Color(0xffFF00E5),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton({
    required String gender,
    required String imagePath,
    required Color color,
  }) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? Colors.white.withOpacity(0.04)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.18),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(-4, 0),
              child: Opacity(
                opacity: isSelected ? 1.0 : 0.5,
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: OverflowBox(
                    maxWidth: 56,
                    maxHeight: 56,
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: GoogleFonts.outfit(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.50),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
