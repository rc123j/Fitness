import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../services/onboarding_draft_service.dart';
import 'gender_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen>
    with SingleTickerProviderStateMixin {
  String selectedGoalTitle = "Weight Loss";

  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _shineAnimation = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );
    _shineController.repeat(
      reverse: false,
    ); // start AFTER _shineAnimation is ready
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> goals = [
    {
      "id": 1,
      "title": "Weight Loss",
      "subtitle": "Burn fat and lose weight in a healthy way.",
      "image": "assets/new_images/weight_loss.png",
      "color": const Color(0xffFF5F6D),
    },
    {
      "id": 5,
      "title": "Weight Gain",
      "subtitle": "Gain healthy mass and increase body weight.",
      "image": "assets/new_images/weight_gain.png",
      "color": const Color(0xff00E5FF),
    },
    {
      "id": 3,
      "title": "Fitness",
      "subtitle": "Improve overall fitness and daily energy.",
      "image": "assets/new_images/fitness.png",
      "color": const Color(0xffC026D3),
    },
    {
      "id": 4,
      "title": "Athletic Performance",
      "subtitle": "Enhance endurance, speed and performance.",
      "image": "assets/new_images/athelitcperformance.png",
      "color": const Color(0xffFF7A00),
    },
    {
      "id": 2,
      "title": "Muscle Gain",
      "subtitle": "Build lean muscle and increase strength.",
      "image": "assets/new_images/muscle_gain.png",
      "color": const Color(0xffFF7A00),
    },
  ];

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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "STEP 1 OF 10",
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
                                buildProgress(false),
                                buildProgress(false),
                                buildProgress(false),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
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

                const SizedBox(height: 16),

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
                        const SizedBox(height: 8),
                        Text(
                          "Choose your primary fitness goal and let AI build your perfect plan.",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.60),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// GOAL CARDS
                        ...goals.map((goal) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: buildHorizontalGoalCard(goal),
                          );
                        }).toList(),

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
                          OnboardingDraftService.saveStep1(
                            goalTitle: selectedGoal["title"] as String,
                            goalId: selectedGoal["id"] as int,
                          );
                          Get.to(
                            () => GenderScreen(
                              goalTitle: selectedGoal["title"] as String,
                              goalId: selectedGoal["id"] as int,
                            ),
                            transition: Transition.cupertino,
                          );
                        },
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProgress(bool active) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        height: 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.5),
          gradient: active
              ? const LinearGradient(
                  colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                )
              : null,
          color: active ? null : Colors.white.withOpacity(0.12),
        ),
      ),
    );
  }

  Widget buildHorizontalGoalCard(Map<String, dynamic> goal) {
    final isSelected = selectedGoalTitle == goal["title"];
    final themeColor = goal["color"] as Color;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoalTitle = goal["title"] as String;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withOpacity(0.06),
            width: 1,
          ),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                )
              : null,
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
          margin: const EdgeInsets.all(1.2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.5),
            color: const Color(0xff151520),
          ),
          child: Row(
            children: [
              // Icon with shine animation
              SizedBox(
                height: 72,
                width: 72,
                child: OverflowBox(
                  maxHeight: 130,
                  maxWidth: 130,
                  child: AnimatedBuilder(
                    animation: _shineAnimation,
                    builder: (context, child) {
                      return ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (rect) {
                          final x = _shineAnimation.value;
                          return LinearGradient(
                            begin: Alignment(x - 1.5, -1.0),
                            end: Alignment(x + 1.5, 1.0),
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.35),
                              const Color(0xffFFE8A0).withOpacity(0.65),
                              Colors.white.withOpacity(0.35),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
                          ).createShader(rect);
                        },
                        child: child,
                      );
                    },
                    child: Image.asset(
                      goal["image"] as String,
                      fit: BoxFit.contain,
                    ),
                  ),
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
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal["subtitle"] as String,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.50),
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
                  height: 22,
                  width: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Icon(Icons.check, color: Colors.black, size: 15),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
