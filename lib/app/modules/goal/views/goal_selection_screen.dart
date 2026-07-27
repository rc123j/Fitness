import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import 'physical_metrics_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String selectedGoalTitle = "Weight Loss";
  bool isMuscleGainSelected = false;

  final List<Map<String, dynamic>> goals = [
    {
      "id": 1,
      "title": "Weight Loss",
      "subtitle": "Burn fat and lose weight\nin a healthy way.",
      "icon": Icons.local_fire_department_rounded,
      "color": const Color(0xffFF5F6D),
    },
    {
      "id": 5,
      "title": "Weight Gain",
      "subtitle": "Gain healthy mass and\nincrease body weight.",
      "icon": Icons.trending_up_rounded,
      "color": const Color(0xff00E5FF),
    },
    {
      "id": 2,
      "title": "Muscle Gain",
      "subtitle": "Build lean muscle and\nincrease strength.",
      "icon": Icons.fitness_center_rounded,
      "color": const Color(0xffFF7A00),
    },
    {
      "id": 3,
      "title": "Fitness",
      "subtitle": "Improve overall fitness\nand daily energy.",
      "icon": Icons.directions_run_rounded,
      "color": const Color(0xffC026D3),
    },
    {
      "id": 4,
      "title": "Athletic Performance",
      "subtitle": "Enhance endurance, speed\nand performance.",
      "icon": Icons.bolt_rounded,
      "color": const Color(0xffFF7A00),
    },
  ];

  List<Map<String, dynamic>> get categoryAGoals =>
      goals.where((g) => g["title"] != "Muscle Gain").toList();

  List<Map<String, dynamic>> get categoryBGoals =>
      goals.where((g) => g["title"] == "Muscle Gain").toList();

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                /// 1. TOP PROGRESS BAR & LOGOUT (Non-scrollable)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "STEP 1 OF 7",
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
                              buildProgress(false),
                              buildProgress(false),
                              buildProgress(false),
                            ],
                          ),
                        ],
                      ),

                      // Logout Button
                      GestureDetector(
                        onTap: () {
                          Get.find<AuthService>().logout();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 0.8,
                            ),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// 2. MIDDLE SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE & TEXT
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

                        const SizedBox(height: 16),

                        /// CATEGORY A HEADER
                        Text(
                          "CATEGORY A • GENERAL & WEIGHT GOALS",
                          style: GoogleFonts.outfit(
                            color: const Color(0xffFF00E5).withOpacity(0.85),
                            fontSize: 11,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// CATEGORY A DYNAMIC GOAL CARDS
                        ...categoryAGoals.map((goal) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildHorizontalGoalCard(goal, true),
                          );
                        }),

                        const SizedBox(height: 12),

                        /// CATEGORY B HEADER
                        Text(
                          "CATEGORY B • MUSCLE BUILDING (OPTIONAL ADD-ON)",
                          style: GoogleFonts.outfit(
                            color: const Color(0xffFF7A00).withOpacity(0.85),
                            fontSize: 11,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// CATEGORY B DYNAMIC GOAL CARDS
                        ...categoryBGoals.map((goal) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildHorizontalGoalCard(goal, false),
                          );
                        }),

                        const SizedBox(height: 8),

                        /// AI PERSONALIZATION INFO CARD
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
                                        color: const Color(
                                          0xff7B61FF,
                                        ).withOpacity(0.35),
                                        width: 1.2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xff7B61FF,
                                          ).withOpacity(0.25),
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
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                /// 3. CONTINUE BUTTON (Non-scrollable, floating at bottom)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Container(
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
                          final selectedGoal = goals.firstWhere(
                            (g) => g["title"] == selectedGoalTitle,
                            orElse: () => goals.first,
                          );
                          final String finalTitle = isMuscleGainSelected && selectedGoal["title"] != "Muscle Gain"
                              ? "${selectedGoal["title"]} + Muscle Gain"
                              : selectedGoal["title"] as String;
                          Get.to(
                            () => PhysicalMetricsScreen(
                              goalTitle: finalTitle,
                              goalId: selectedGoal["id"] as int,
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
                ),
              ],
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

  Widget buildGoalCard(Map<String, dynamic> goal) {
    final isSelected = selectedGoalTitle == goal["title"];
    final themeColor = goal["color"] as Color;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoalTitle = goal["title"] as String;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.8),
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

  Widget buildHorizontalGoalCard(Map<String, dynamic> goal, bool isCategoryA) {
    final isSelected = isCategoryA
        ? selectedGoalTitle == goal["title"]
        : isMuscleGainSelected;
    final themeColor = goal["color"] as Color;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isCategoryA) {
            selectedGoalTitle = goal["title"] as String;
          } else {
            isMuscleGainSelected = !isMuscleGainSelected;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.8),
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
