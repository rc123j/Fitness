import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'physical_metrics_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> goals = [
    {
      "title": "Weight Loss",
      "subtitle": "Burn fat and lose weight\nin a healthy way.",
      "icon": Icons.local_fire_department_rounded,
      "color": const Color(0xffFF5F6D),
    },
    {
      "title": "Muscle Gain",
      "subtitle": "Build lean muscle and\nincrease strength.",
      "icon": Icons.fitness_center_rounded,
      "color": const Color(0xffFF7A00),
    },
    {
      "title": "Fitness",
      "subtitle": "Improve overall fitness\nand daily energy.",
      "icon": Icons.directions_run_rounded,
      "color": const Color(0xffC026D3),
    },
    {
      "title": "Athletic Performance",
      "subtitle": "Enhance endurance, speed\nand performance.",
      "icon": Icons.bolt_rounded,
      "color": const Color(0xffFF7A00),
    },
    {
      "title": "Nutrition Focus",
      "subtitle": "Build better eating habits and improve overall health.",
      "icon": Icons.restaurant_menu_rounded,
      "color": const Color(0xffFF5F6D),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          /// BACKGROUND GLOW (Top Right)
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
                    const Color(0xffFF00E5).withOpacity(0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 100,
            right: -60,
            child: Container(
              height: 240,
              width: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF7A00).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    /// 1. TOP PROGRESS BAR & SKIP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "STEP 1 OF 4",
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
                                buildProgress(false),
                                buildProgress(false),
                                buildProgress(false),
                              ],
                            ),
                          ],
                        ),

                        // Skip Button
                        GestureDetector(
                          onTap: () {
                            Get.offAllNamed('/home');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              "Skip",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// 2. TITLE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "What is\nYour ",
                                style: GoogleFonts.outfit(
                                  height: 1.1,
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              TextSpan(
                                text: "Goal?",
                                style: GoogleFonts.outfit(
                                  height: 1.1,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  foreground: Paint()
                                    ..shader =
                                        const LinearGradient(
                                          colors: [
                                            Color(0xffFF00E5),
                                            Color(0xffFF7A00),
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
                          const SizedBox(height: 6),
                          Text(
                            "Choose your primary fitness goal and let our AI build your plan accordingly.",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.60),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 10),

                    /// 3. SECTION HEADER
                    Text(
                      "SELECT YOUR GOAL",
                      style: GoogleFonts.outfit(
                        color: const Color(0xffFF00E5).withOpacity(0.85),
                        fontSize: 11,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// 4. GOAL CARDS GRID LAYOUT
                    Row(
                      children: [
                        Expanded(child: buildGoalCard(0)),
                        const SizedBox(width: 12),
                        Expanded(child: buildGoalCard(1)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: buildGoalCard(2)),
                        const SizedBox(width: 12),
                        Expanded(child: buildGoalCard(3)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    buildHorizontalGoalCard(4),

                    const SizedBox(height: 10),

                    /// 5. AI PERSONALIZATION INFO CARD
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: const Color(0xff090918),
                                  border: Border.all(
                                    color: const Color(0xff7B61FF).withOpacity(0.35),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff7B61FF).withOpacity(0.25),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Opacity(
                                      opacity: 0.4,
                                      child: const Icon(
                                        Icons.memory_rounded,
                                        color: Color(0xffFF00E5),
                                        size: 32,
                                      ),
                                    ),
                                    Text(
                                      "AI",
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "Our AI will personalize your diet, workouts and recommendations based on your goal.",
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.75),
                                    fontSize: 12,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// 6. CONTINUE BUTTON
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
                            final selectedGoal = goals[selectedIndex];
                            Get.to(() => PhysicalMetricsScreen(
                              goalTitle: selectedGoal["title"] as String,
                            ));
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

  Widget buildGoalCard(int index) {
    final goal = goals[index];
    final isSelected = selectedIndex == index;
    final themeColor = goal["color"] as Color;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 0.8,
          ),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xffFF00E5).withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Container(
          margin: const EdgeInsets.all(1.5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.5),
            color: const Color(0xff090918),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon Backdrop Glow
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          themeColor.withOpacity(0.18),
                          themeColor.withOpacity(0.03),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withOpacity(0.10),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      goal["icon"] as IconData,
                      color: themeColor,
                      size: 24,
                    ),
                  ),

                  // Checkmark Badge
                  if (isSelected)
                    Container(
                      height: 18,
                      width: 18,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.black,
                        size: 13,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                goal["title"] as String,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                goal["subtitle"] as String,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.60),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHorizontalGoalCard(int index) {
    final goal = goals[index];
    final isSelected = selectedIndex == index;
    final themeColor = goal["color"] as Color;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 0.8,
          ),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xffFF00E5).withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Container(
          margin: const EdgeInsets.all(1.5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.5),
            color: const Color(0xff090918),
          ),
          child: Row(
            children: [
              // Icon Backdrop Glow
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      themeColor.withOpacity(0.18),
                      themeColor.withOpacity(0.03),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withOpacity(0.10),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  goal["icon"] as IconData,
                  color: themeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal["title"] as String,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal["subtitle"] as String,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.60),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              // Checkmark Badge
              if (isSelected)
                Container(
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.black,
                    size: 13,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
