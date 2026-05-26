import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      bottomNavigationBar: buildBottomNav(),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffFF00E5).withOpacity(0.45),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 38),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          /// BACKGROUND NEON GLOW BLOBS
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF00E5).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -150,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffB100FF).withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 400,
            right: -180,
            child: Container(
              height: 380,
              width: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF7A00).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// MAIN SCROLL BODY
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                top: 10,
                bottom: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1. TOP HEADER SECTION
                  buildTopHeader(),

                  const SizedBox(height: 24),

                  /// 2. ACTIVE PLAN CARD (Glassmorphic)
                  buildActivePlanCard(),

                  const SizedBox(height: 24),

                  /// 3. STATS GRID ROW 1
                  Row(
                    children: [
                      Expanded(
                        child: buildStatCard(
                          title: "Calories",
                          value: "1,240",
                          sub: "/ 2,000 kcal",
                          icon: Icons.local_fire_department_rounded,
                          color: const Color(0xffFF7A00),
                          progress: 1240 / 2000,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: buildWaterCard(current: 2.1, target: 3.0),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// STATS GRID ROW 2
                  Row(
                    children: [
                      Expanded(
                        child: buildStatCard(
                          title: "Steps",
                          value: "7,842",
                          sub: "/ 10,000",
                          icon: Icons.directions_walk_rounded,
                          color: const Color(0xff00FF87),
                          progress: 7842 / 10000,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: buildStatCard(
                          title: "Compliance",
                          value: "92%",
                          sub: "Today",
                          icon: Icons.track_changes_rounded,
                          color: const Color(0xffB100FF),
                          progress: 0.92,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// 4. TODAY'S MEAL PLAN
                  sectionTitle("TODAY'S MEAL PLAN", "View Full Plan"),

                  const SizedBox(height: 16),

                  buildMealPlanTimeline(),

                  const SizedBox(height: 28),

                  /// 5. AI COACH & HYDRATION GOAL (ROW)
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Expanded(flex: 11, child: buildAICoachCard()),
                  //     const SizedBox(width: 12),
                  //     Expanded(flex: 8, child: buildHydrationGoalCard()),
                  //   ],
                  // ),`
                  const SizedBox(height: 28),

                  /// 6. PROGRESS & STREAK SECTION
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// LEFT: YOUR PROGRESS (Flex 11)
                      Expanded(
                        flex: 11,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sectionTitle("YOUR PROGRESS", "View All"),
                            const SizedBox(height: 14),
                            buildWeightProgressCard(),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: buildInchesLostCard()),
                                const SizedBox(width: 12),
                                Expanded(child: buildConsistencyCard()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      /// RIGHT: STREAK & REWARDS (Flex 9)
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sectionTitle("STREAK", "View All"),
                            const SizedBox(height: 14),
                            buildStreakAndRewardsCard(),
                            const SizedBox(height: 12),
                            buildBadgesCard(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// 7. QUICK ACTIONS Grid
                  sectionTitle("QUICK ACTIONS", ""),

                  const SizedBox(height: 16),

                  buildQuickActionsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// TOP HEADER WIDGET
  /// ----------------------------------------------------
  Widget buildTopHeader() {
    return Row(
      children: [
        /// PROFILE IMAGE WITH NEON CIRCULAR RING
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xffFF00E5).withOpacity(0.75),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffFF00E5).withOpacity(0.20),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/athlete.png",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffB100FF), Color(0xffFF7A00)],
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        /// USER INFO TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hey, Arjun!",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Text(
              //   "You’re doing amazing today!\nKeep going, results are coming.",
              //   style: GoogleFonts.inter(
              //     color: Colors.white.withOpacity(0.65),
              //     fontSize: 12,
              //     height: 1.35,
              //   ),
              // ),
            ],
          ),
        ),

        /// HEADER TOP RIGHT ACTIONS
        Row(
          children: [
            /// STREAK BADGE CARD
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xffFF7A00).withOpacity(0.12),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xffFF7A00),
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "12",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        "Day Streak",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 9,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            /// NOTIFICATION ICON
            buildTopActionButton(
              icon: Icons.notifications_none_rounded,
              showDot: true,
            ),

            const SizedBox(width: 8),

            /// SCAN/SCANNER ICON
            buildTopActionButton(
              icon: Icons.qr_code_scanner_rounded,
              showDot: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTopActionButton({required IconData icon, required bool showDot}) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.85), size: 20),
          if (showDot)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                height: 7,
                width: 7,
                decoration: const BoxDecoration(
                  color: Color(0xffFF00E5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// ACTIVE PLAN CARD WIDGET
  /// ----------------------------------------------------
  Widget buildActivePlanCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.65),
        border: Border.all(
          color: const Color(0xffFF00E5).withOpacity(0.20),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffFF00E5).withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xffB100FF).withOpacity(0.10),
                  const Color(0xffFF7A00).withOpacity(0.04),
                  const Color(0xff0B0817).withOpacity(0.40),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Left portion: Fat Loss Plan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "ACTIVE PLAN",
                        style: GoogleFonts.outfit(
                          color: const Color(0xffB100FF).withOpacity(0.9),
                          fontSize: 11,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Fat Loss Plan",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                /// Right portion: Plan Progress
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Plan Progress",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.60),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "24%",
                      style: GoogleFonts.outfit(
                        color: const Color(0xffFF5F6D),
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Slim progress bar
                    SizedBox(
                      width: 100,
                      height: 6,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.24,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffFF7A00),
                                    Color(0xffFF5F6D),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// STATS CARD WIDGET
  /// ----------------------------------------------------
  Widget buildStatCard({
    required String title,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
    required double progress,
  }) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(color: color.withOpacity(0.22), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.06),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            /// Wave Graphic Background
            Positioned.fill(
              child: CustomPaint(painter: WavePainter(color: color)),
            ),

            /// Info Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.12),
                        ),
                        child: Icon(icon, color: color, size: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.80),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Progress Bar
                  Container(
                    height: 5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.08),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.3)],
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
      ),
    );
  }

  /// Specialized Water Card with glasses
  Widget buildWaterCard({required double current, required double target}) {
    Color color = const Color(0xff00A3FF);
    int totalCups = 5;
    int filledCups = ((current / target) * totalCups).round().clamp(
      0,
      totalCups,
    );

    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(color: color.withOpacity(0.22), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.06),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            /// Wave Graphic Background
            Positioned.fill(
              child: CustomPaint(painter: WavePainter(color: color)),
            ),

            /// Info Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.12),
                        ),
                        child: Icon(
                          Icons.water_drop_rounded,
                          color: color,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Water",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.80),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: current.toStringAsFixed(1),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " / ${target.round()} L",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Droplet indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(totalCups, (index) {
                      bool isFilled = index < filledCups;
                      return Icon(
                        Icons.water_drop_rounded,
                        color: isFilled
                            ? color
                            : Colors.white.withOpacity(0.12),
                        size: 15,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// MEAL PLAN TIMELINE WIDGETS
  /// ----------------------------------------------------
  Widget buildMealPlanTimeline() {
    final List<Map<String, dynamic>> meals = [
      {
        "title": "Breakfast",
        "desc": "Oats with Fruits & Nuts",
        "kcal": "450 kcal",
        "macros": "22P • 60C • 12F",
        "tag": "Completed",
        "color": const Color(0xff00FF87),
        "icon": Icons.breakfast_dining_rounded,
        "isFirst": true,
        "isLast": false,
      },
      {
        "title": "Lunch",
        "desc": "Grilled Chicken, Rice, Salad",
        "kcal": "550 kcal",
        "macros": "40P • 60C • 15F",
        "tag": "Upcoming",
        "color": const Color(0xffFF7A00),
        "icon": Icons.restaurant_rounded,
        "isFirst": false,
        "isLast": false,
      },
      {
        "title": "Snacks",
        "desc": "Greek Yogurt with Berries",
        "kcal": "200 kcal",
        "macros": "15P • 20C • 5F",
        "tag": "4:00 PM",
        "color": const Color(0xffB100FF),
        "icon": Icons.local_cafe_rounded,
        "isFirst": false,
        "isLast": false,
      },
      {
        "title": "Dinner",
        "desc": "Paneer Curry, Roti, Veggies",
        "kcal": "450 kcal",
        "macros": "25P • 50C • 12F",
        "tag": "8:00 PM",
        "color": const Color(0xffFF3B30),
        "icon": Icons.dining_rounded,
        "isFirst": false,
        "isLast": true,
      },
    ];

    return Column(
      children: List.generate(meals.length, (index) {
        final meal = meals[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Vertical timeline custom drawn
            SizedBox(
              width: 24,
              height: 106,
              child: CustomPaint(
                painter: TimelineNodePainter(
                  isFirst: meal["isFirst"] as bool,
                  isLast: meal["isLast"] as bool,
                  color: meal["color"] as Color,
                  isActive:
                      meal["tag"] == "Completed" || meal["tag"] == "Upcoming",
                ),
              ),
            ),
            const SizedBox(width: 8),

            /// Meal card itself
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: const Color(0xff0B0817).withOpacity(0.50),
                  border: Border.all(
                    color: (meal["color"] as Color).withOpacity(0.22),
                    width: 1.0,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (meal["color"] as Color).withOpacity(0.06),
                      const Color(0xff0B0817).withOpacity(0.40),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    /// Circle Gradient Icon Left
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            (meal["color"] as Color).withOpacity(0.25),
                            (meal["color"] as Color).withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: (meal["color"] as Color).withOpacity(0.35),
                          width: 0.8,
                        ),
                      ),
                      child: Icon(
                        meal["icon"] as IconData,
                        color: meal["color"] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),

                    /// Middle texts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal["title"] as String,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            meal["desc"] as String,
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.70),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            meal["macros"] as String,
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.35),
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Right side info and badge
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          meal["kcal"] as String,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// Status Capsule Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: (meal["color"] as Color).withOpacity(0.12),
                            border: Border.all(
                              color: (meal["color"] as Color).withOpacity(0.20),
                              width: 0.6,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                meal["tag"] == "Completed"
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.access_time_rounded,
                                size: 10,
                                color: meal["color"] as Color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                meal["tag"] as String,
                                style: GoogleFonts.outfit(
                                  color: meal["color"] as Color,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white.withOpacity(0.35),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// ----------------------------------------------------
  /// AI COACH CARD WIDGET
  /// ----------------------------------------------------
  Widget buildAICoachCard() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(
          color: const Color(0xffB100FF).withOpacity(0.25),
          width: 1.0,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xffB100FF).withOpacity(0.06),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffB100FF).withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          /// Glowing Brain Circle Icon
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xffB100FF).withOpacity(0.35),
                  const Color(0xffFF00E5).withOpacity(0.12),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffB100FF).withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: const Color(0xffB100FF).withOpacity(0.30),
                width: 0.8,
              ),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),

          /// Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "AI Coach Insight",
                  style: GoogleFonts.outfit(
                    color: const Color(0xffC947FF),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Your protein intake is 18% lower today. Add more protein in your next meal.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.70),
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.white.withOpacity(0.35),
            size: 18,
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// HYDRATION GOAL CARD (with glowing water bottle)
  /// ----------------------------------------------------
  Widget buildHydrationGoalCard() {
    Color themeColor = const Color(0xff00A3FF);

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(color: themeColor.withOpacity(0.25), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withOpacity(0.06),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          /// Left column: details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.water_drop_rounded, color: themeColor, size: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "Hydration Goal",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.70),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "2.1",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " / 3 L",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.40),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                /// Mini Glass Droplets
                Row(
                  children: List.generate(5, (index) {
                    bool filled = index < 3;
                    return Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: Icon(
                        Icons.water_drop_rounded,
                        color: filled
                            ? themeColor
                            : Colors.white.withOpacity(0.12),
                        size: 9,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          /// Right column: Neon Water Bottle Custom drawn
          SizedBox(
            width: 32,
            height: double.infinity,
            child: CustomPaint(
              painter: NeonBottlePainter(fillProgress: 2.1 / 3.0),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// YOUR PROGRESS: WEIGHT LINE CHART CARD
  /// ----------------------------------------------------
  Widget buildWeightProgressCard() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(
          color: const Color(0xffFF00E5).withOpacity(0.20),
          width: 1.0,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xffFF00E5).withOpacity(0.06),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffFF00E5).withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Weight",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "72.4 kg",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "↓ 1.2 kg",
                        style: GoogleFonts.inter(
                          color: const Color(0xff00FF87),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Real Line Chart Custom Painted
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: ProgressLineChartPainter(),
            ),
          ),

          const SizedBox(height: 6),

          /// X-Axis labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              xAxisLabel("14 Apr"),
              xAxisLabel("28 Apr"),
              xAxisLabel("12 May"),
              xAxisLabel("Today"),
            ],
          ),
        ],
      ),
    );
  }

  Widget xAxisLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: Colors.white.withOpacity(0.35),
        fontSize: 8.5,
      ),
    );
  }

  /// INCHES LOST SMALL CARD
  Widget buildInchesLostCard() {
    Color themeColor = const Color(0xff00FF87);
    return Container(
      height: 94,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(color: themeColor.withOpacity(0.20), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withOpacity(0.05),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Inches Lost",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.50),
              fontSize: 10,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "2.1 in",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColor.withOpacity(0.12),
                ),
                child: Icon(
                  Icons.straighten_rounded,
                  color: themeColor,
                  size: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// CONSISTENCY CIRCULAR PROGRESS SMALL CARD
  Widget buildConsistencyCard() {
    Color themeColor = const Color(0xff00FF87);
    return Container(
      height: 94,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(color: themeColor.withOpacity(0.20), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withOpacity(0.05),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "This Week\nConsistency",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 8.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "6/7 Days",
                  style: GoogleFonts.outfit(
                    color: themeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),

          /// Micro Circular indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 42,
                width: 42,
                child: CircularProgressIndicator(
                  value: 0.85,
                  strokeWidth: 4,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
              ),
              Text(
                "85%",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// STREAK & REWARDS WIDGETS
  /// ----------------------------------------------------
  Widget buildStreakAndRewardsCard() {
    Color themeColor = const Color(0xffFF7A00);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(color: themeColor.withOpacity(0.20), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withOpacity(0.05),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
      ),
      child: Row(
        children: [
          /// Streak
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.02),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xffFF7A00),
                    size: 24,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "12",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Day Streak",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 8.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          /// Reward Coins
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.02),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    color: Color(0xffFFD700),
                    size: 24,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "240",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Reward Coins",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 8.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BADGES ROW CARD
  Widget buildBadgesCard() {
    Color themeColor = const Color(0xffB100FF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(color: themeColor.withOpacity(0.20), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withOpacity(0.05),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Badges",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.50),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              buildBadgeIcon(
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xffB100FF),
              ),
              const SizedBox(width: 10),
              buildBadgeIcon(
                icon: Icons.stars_rounded,
                color: const Color(0xffFF7A00),
              ),
              const SizedBox(width: 10),
              buildBadgeIcon(
                icon: Icons.emoji_events_rounded,
                color: const Color(0xff00A3FF),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.35),
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBadgeIcon({required IconData icon, required Color color}) {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff090414),
        border: Border.all(color: color.withOpacity(0.35), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  /// ----------------------------------------------------
  /// QUICK ACTIONS GRID WIDGET
  /// ----------------------------------------------------
  Widget buildQuickActionsGrid() {
    final List<Map<String, dynamic>> actions = [
      {
        "title": "Update\nProgress",
        "icon": Icons.bar_chart_rounded,
        "color": const Color(0xff00FF87),
      },
      {
        "title": "Consult\nExpert",
        "icon": Icons.medical_services_rounded,
        "color": const Color(0xffB100FF),
      },
      {
        "title": "Supplements",
        "icon": Icons.offline_bolt_rounded,
        "color": const Color(0xffFF7A00),
      },
      {
        "title": "Social Room",
        "icon": Icons.groups_rounded,
        "color": const Color(0xffFF00E5),
      },
      {
        "title": "Family",
        "icon": Icons.people_outline_rounded,
        "color": const Color(0xff00A3FF),
      },
      {
        "title": "More",
        "icon": Icons.more_horiz_rounded,
        "color": Colors.white,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        Color color = action["color"] as Color;

        return Column(
          children: [
            /// Circular colorful glow container
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xff0B0817),
                border: Border.all(color: color.withOpacity(0.18), width: 1),
                gradient: RadialGradient(
                  colors: [color.withOpacity(0.08), Colors.transparent],
                ),
              ),
              child: Icon(action["icon"] as IconData, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              action["title"] as String,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.70),
                fontSize: 9,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        );
      },
    );
  }

  /// ----------------------------------------------------
  /// REUSABLE HEADERS/HELPERS
  /// ----------------------------------------------------
  Widget sectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        if (action.isNotEmpty)
          Row(
            children: [
              Text(
                action,
                style: GoogleFonts.outfit(
                  color: const Color(0xffB100FF),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xffB100FF),
                size: 11,
              ),
            ],
          ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// BOTTOM NAVIGATION BAR
  /// ----------------------------------------------------
  Widget buildBottomNav() {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: const Color(0xff090414),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(Icons.home_filled, "Dashboard", true),
          navItem(Icons.restaurant_rounded, "Meals", false),
          const SizedBox(width: 40), // Spacer for FAB
          navItem(Icons.groups_rounded, "Community", false),
          navItem(Icons.person_rounded, "Profile", false),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, String label, bool active) {
    Color activeColor = const Color(0xffFF00E5);
    Color inactiveColor = Colors.white.withOpacity(0.40);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? activeColor : inactiveColor, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: active ? activeColor : inactiveColor,
            fontSize: 10,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// ----------------------------------------------------
/// CUSTOM PAINTERS FOR PREMIUM UI
/// ----------------------------------------------------

/// 1. Custom painter for background waves inside Stats Cards
class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height * 0.7);

    // Draw wavy Bezier curve
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.45,
      size.width * 0.5,
      size.height * 0.65,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.85,
      size.width,
      size.height * 0.5,
    );

    // Draw stroke line
    canvas.drawPath(path, strokePaint);

    // Close path to bottom for fill
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 2. Custom painter for beautiful Timeline Nodes
class TimelineNodePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color color;
  final bool isActive;

  TimelineNodePainter({
    required this.isFirst,
    required this.isLast,
    required this.color,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = isActive
          ? color.withOpacity(0.25)
          : Colors.white.withOpacity(0.08)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // Draw vertical connection lines
    if (!isFirst) {
      canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX, centerY - 8),
        linePaint,
      );
    }
    if (!isLast) {
      canvas.drawLine(
        Offset(centerX, centerY + 8),
        Offset(centerX, size.height),
        linePaint,
      );
    }

    // Draw outer pulsing glowing circle
    final glowPaint = Paint()
      ..color = color.withOpacity(isActive ? 0.22 : 0.05)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 9, glowPaint);

    // Draw middle circle
    final borderPaint = Paint()
      ..color = isActive ? color : Colors.white.withOpacity(0.12)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(centerX, centerY), 6, borderPaint);

    // Draw inner solid dot
    final dotPaint = Paint()
      ..color = isActive ? color : Colors.white.withOpacity(0.20)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3. Custom painter for a beautiful glowing neon water bottle
class NeonBottlePainter extends CustomPainter {
  final double fillProgress;

  NeonBottlePainter({required this.fillProgress});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    // 1. Draw bottle outline
    final outlinePaint = Paint()
      ..color = const Color(0xff00A3FF).withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = const Color(0xff00A3FF).withOpacity(0.12)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final bottlePath = Path();

    // Cap/Neck
    bottlePath.moveTo(w * 0.35, h * 0.12);
    bottlePath.lineTo(w * 0.65, h * 0.12);
    bottlePath.lineTo(w * 0.65, h * 0.22);
    // Shoulder
    bottlePath.quadraticBezierTo(w * 0.65, h * 0.32, w * 0.85, h * 0.36);
    // Body
    bottlePath.lineTo(w * 0.85, h * 0.82);
    // Bottom
    bottlePath.quadraticBezierTo(w * 0.85, h * 0.90, w * 0.5, h * 0.90);
    bottlePath.quadraticBezierTo(w * 0.15, h * 0.90, w * 0.15, h * 0.82);
    // Body left
    bottlePath.lineTo(w * 0.15, h * 0.36);
    // Shoulder left
    bottlePath.quadraticBezierTo(w * 0.35, h * 0.32, w * 0.35, h * 0.22);
    bottlePath.close();

    canvas.drawPath(bottlePath, glowPaint);
    canvas.drawPath(bottlePath, outlinePaint);

    // 2. Draw water fill
    final waterPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xff00A3FF).withOpacity(0.7),
          const Color(0xff00E5FF).withOpacity(0.3),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    // Create a clipping path of the bottle interior
    canvas.save();
    canvas.clipPath(bottlePath);

    // Draw wavy top for water
    double waterHeight = h * 0.88 - (h * 0.52 * fillProgress);
    final wavePath = Path();
    wavePath.moveTo(0, waterHeight);
    wavePath.quadraticBezierTo(w * 0.25, waterHeight - 2, w * 0.5, waterHeight);
    wavePath.quadraticBezierTo(w * 0.75, waterHeight + 2, w, waterHeight);
    wavePath.lineTo(w, h * 0.88);
    wavePath.lineTo(0, h * 0.88);
    wavePath.close();

    canvas.drawPath(wavePath, waterPaint);
    canvas.restore();

    // Draw simple cap lines
    final capPaint = Paint()
      ..color = const Color(0xff00A3FF)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.38, h * 0.08, w * 0.24, h * 0.04),
        const Radius.circular(2),
      ),
      capPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 4. Custom painter for a glowing weight line chart
class ProgressLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 0.8;

    // Draw horizontal grid lines
    for (int i = 0; i < 4; i++) {
      double y = size.height * 0.15 + (size.height * 0.25 * i);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = [
      Offset(size.width * 0.05, size.height * 0.2),
      Offset(size.width * 0.36, size.height * 0.45),
      Offset(size.width * 0.68, size.height * 0.6),
      Offset(size.width * 0.95, size.height * 0.75),
    ];

    // Compute bezier curve path
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2.2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2.2, p2.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p2.dx,
        p2.dy,
      );
    }

    // Draw gradient fill under line
    final fillPath = Path.from(path);
    fillPath.lineTo(points.last.dx, size.height * 0.9);
    fillPath.lineTo(points.first.dx, size.height * 0.9);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xffFF00E5).withOpacity(0.12), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Draw main glowing chart line
    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Draw glowing final dot ("Today")
    final lastPoint = points.last;

    // Outer glow circle
    final glowPaint = Paint()
      ..color = const Color(0xffFF00E5).withOpacity(0.35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(lastPoint, 6, glowPaint);

    // Inner white dot
    final solidPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(lastPoint, 2.5, solidPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
