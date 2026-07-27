import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'activity_level_screen.dart';

class PhysicalMetricsScreen extends StatefulWidget {
  final String goalTitle;
  final int goalId;

  const PhysicalMetricsScreen({
    super.key,
    required this.goalTitle,
    required this.goalId,
  });

  @override
  State<PhysicalMetricsScreen> createState() => _PhysicalMetricsScreenState();
}

class _PhysicalMetricsScreenState extends State<PhysicalMetricsScreen> {
  String selectedGender = "Male"; // "Male" or "Female"
  double age = 24.0;
  double height = 172.0; // in cm
  double weight = 70.0; // in kg

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          /// BACKGROUND GLOW (Top Left / Right)
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              height: 280,
              width: 280,
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
            top: 150,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
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
                               "STEP 2 OF 7",
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
                                 buildProgress(false),
                                 buildProgress(false),
                                 buildProgress(false),
                                 buildProgress(false),
                                 buildProgress(false),
                               ],
                             ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// 2. TITLE & TEXT
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Tell us about\nYour ",
                            style: GoogleFonts.outfit(
                              height: 1.1,
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(
                            text: "Body",
                            style: GoogleFonts.outfit(
                              height: 1.1,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..shader = const LinearGradient(
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
                    const SizedBox(height: 14),
                    Text(
                      "We use these parameters to compute your BMI, BMR, ideal weight, and personalized metabolic insights.",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.60),
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// 3. GENDER SELECTION
                    Text(
                      "GENDER",
                      style: GoogleFonts.outfit(
                        color: const Color(0xffFF00E5).withOpacity(0.85),
                        fontSize: 11,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: buildGenderCard(
                            gender: "Male",
                            icon: Icons.male_rounded,
                            activeColor: const Color(0xff7B61FF),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: buildGenderCard(
                            gender: "Female",
                            icon: Icons.female_rounded,
                            activeColor: const Color(0xffFF00E5),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    /// 4. SLIDERS: AGE, HEIGHT, WEIGHT
                    buildMetricSlider(
                      title: "AGE",
                      value: age,
                      min: 10,
                      max: 100,
                      unit: "yrs",
                      activeGradientColors: [const Color(0xff7B61FF), const Color(0xffFF00E5)],
                      onChanged: (val) {
                        setState(() {
                          age = val;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    buildMetricSlider(
                      title: "HEIGHT",
                      value: height,
                      min: 100,
                      max: 220,
                      unit: "cm",
                      activeGradientColors: [const Color(0xffFF00E5), const Color(0xffFF7A00)],
                      onChanged: (val) {
                        setState(() {
                          height = val;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    buildMetricSlider(
                      title: "WEIGHT",
                      value: weight,
                      min: 30,
                      max: 180,
                      unit: "kg",
                      activeGradientColors: [const Color(0xffFF7A00), const Color(0xff7B61FF)],
                      onChanged: (val) {
                        setState(() {
                          weight = val;
                        });
                      },
                    ),

                    const Spacer(),

                    /// 5. CONTINUE BUTTON
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
                          onTap: () {
                            Get.to(
                              () => ActivityLevelScreen(
                                goalTitle: widget.goalTitle,
                                goalId: widget.goalId,
                                gender: selectedGender,
                                age: age.toInt(),
                                height: height.toInt(),
                                weight: weight,
                              ),
                              transition: Transition.cupertino,
                            );
                          },
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

  Widget buildGenderCard({
    required String gender,
    required IconData icon,
    required Color activeColor,
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
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [activeColor, activeColor.withOpacity(0.5)],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.03),
          border: Border.all(
            color: isSelected ? activeColor.withOpacity(0.8) : Colors.white.withOpacity(0.12),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.25),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Subtle internal glow/shade
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        radius: 1.2,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.40),
                      size: 32,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      gender,
                      style: GoogleFonts.outfit(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.60),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMetricSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required List<Color> activeGradientColors,
    required ValueChanged<double> onChanged,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: value.toInt().toString(),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: " "),
                        TextSpan(
                          text: unit,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  activeTrackColor: activeGradientColors.first,
                  inactiveTrackColor: Colors.white.withOpacity(0.08),
                  thumbColor: Colors.white,
                  overlayColor: activeGradientColors.first.withOpacity(0.12),
                  valueIndicatorColor: activeGradientColors.first,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                    elevation: 4,
                  ),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
