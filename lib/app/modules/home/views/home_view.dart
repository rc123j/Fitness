import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import 'swiggy_tabs.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            /// 1. TOP HEADER SECTION (Location/Profile)
            Padding(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                top: 10,
                bottom: 8,
              ),
              child: buildTopHeader(),
            ),

            /// THE SWIGGY STYLE TOP TABS
            const SwiggyTabsHeader(),

            /// THE DYNAMIC CONTENT AREA
            Expanded(
              child: Obx(() {
                final isMeal = controller.activeTab.value == 0;
                final bgColor = isMeal
                    ? const Color(0xffFD6702)
                    : const Color(0xff3F72AF);

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Colored Section (Bleeds from tabs)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: 18,
                          right: 18,
                          top: 16,
                          bottom: 18,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/home/home1.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Dark Section (Rest of the content)
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xff06010F),
                        ),
                        padding: const EdgeInsets.only(
                          left: 18,
                          right: 18,
                          top: 24,
                          bottom: 100,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),

                            /// 2. ACTIVE PLAN CARD (Glassmorphic)
                            buildActivePlanCard(),

                            const SizedBox(height: 16),

                            /// HONEST RESULTS PROMISE CARD
                            buildHonestResultsCard(),

                            const SizedBox(height: 16),

                            /// TODAY'S MEAL PROGRESS CARD
                            buildMealProgressCard(),

                            const SizedBox(height: 24),

                            /// 3. STATS GRID ROW 1 & 2 (Reactive)
                            Obx(() {
                              final double calProgress =
                                  controller.targetCalories.value > 0
                                  ? (controller.currentCalories.value /
                                            controller.targetCalories.value)
                                        .clamp(0.0, 1.0)
                                  : 0.0;
                              final double stepProgress =
                                  controller.targetSteps.value > 0
                                  ? (controller.currentSteps.value /
                                            controller.targetSteps.value)
                                        .clamp(0.0, 1.0)
                                  : 0.0;

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              Get.toNamed('/calorie-history'),
                                          child: buildStatCard(
                                            title: "Calories",
                                            value: controller
                                                .currentCalories
                                                .value
                                                .toString(),
                                            sub:
                                                "/ ${controller.targetCalories.value} kcal",
                                            icon: Icons
                                                .local_fire_department_rounded,
                                            color: const Color(0xffFF7A00),
                                            progress: calProgress,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.addWater(0.25);
                                            Get.snackbar(
                                              "Water Logged 💧",
                                              "Successfully added +250ml to your daily intake.",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: const Color(
                                                0xff0B0817,
                                              ).withOpacity(0.9),
                                              colorText: Colors.white,
                                              borderColor: const Color(
                                                0xff00A3FF,
                                              ).withOpacity(0.3),
                                              borderWidth: 1,
                                              margin: const EdgeInsets.all(16),
                                            );
                                          },
                                          child: buildWaterCard(
                                            current:
                                                controller.currentWater.value,
                                            target:
                                                controller.targetWater.value,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.addSteps(1000);
                                            Get.snackbar(
                                              "Steps Tracked 👟",
                                              "Successfully logged +1000 steps walked.",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: const Color(
                                                0xff0B0817,
                                              ).withOpacity(0.9),
                                              colorText: Colors.white,
                                              borderColor: const Color(
                                                0xff00FF87,
                                              ).withOpacity(0.3),
                                              borderWidth: 1,
                                              margin: const EdgeInsets.all(16),
                                            );
                                          },
                                          child: buildStatCard(
                                            title: "Steps",
                                            value: controller.currentSteps.value
                                                .toString(),
                                            sub:
                                                "/ ${controller.targetSteps.value}",
                                            icon: Icons.directions_walk_rounded,
                                            color: const Color(0xff00FF87),
                                            progress: stepProgress,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: buildStatCard(
                                          title: "Weight",
                                          value:
                                              "${controller.currentWeight.value.toStringAsFixed(1)} kg",
                                          sub:
                                              controller
                                                      .weightDifference
                                                      .value >=
                                                  0
                                              ? "+${controller.weightDifference.value.toStringAsFixed(1)} kg"
                                              : "${controller.weightDifference.value.toStringAsFixed(1)} kg",
                                          icon: Icons.monitor_weight_rounded,
                                          color: const Color(0xffB100FF),
                                          progress:
                                              0.8, // decorative progress bar
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),

                            const SizedBox(height: 28),

                            /// 4. TODAY'S MEAL PLAN
                            GestureDetector(
                              onTap: () => Get.toNamed('/meal-plan'),
                              child: sectionTitle(
                                "TODAY'S MEAL PLAN",
                                "View Full Plan",
                              ),
                            ),

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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.toNamed('/progress'),
                                  child: sectionTitle(
                                    "YOUR PROGRESS",
                                    "View All",
                                  ),
                                ),
                                const SizedBox(height: 14),
                                GestureDetector(
                                  onTap: () => Get.toNamed('/progress'),
                                  child: buildWeightProgressCard(),
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sectionTitle("STREAK", "View All"),
                                const SizedBox(height: 14),
                                buildStreakAndRewardsCard(),
                                const SizedBox(height: 12),
                                buildBadgesCard(),
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
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// TOP HEADER WIDGET
  /// ----------------------------------------------------
  Widget buildTopHeader() {
    return Row(
      children: [
        /// USER INFO TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final String fullName = controller.userName.value;
                final String firstName = fullName.isNotEmpty
                    ? fullName.split(' ')[0]
                    : 'Member';
                return Text(
                  "Hey, $firstName!",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
            ],
          ),
        ),

        /// HEADER TOP RIGHT ACTIONS
        GestureDetector(
          onTap: () => Get.toNamed('/notifications'),
          child: buildTopActionButton(
            icon: Icons.notifications_none_rounded,
            showDot: true,
          ),
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
    return Obx(() {
      final double progress = (controller.planDayNumber.value / 30.0).clamp(
        0.0,
        1.0,
      );

      return Container(
        height: 154,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xff0B0817).withOpacity(0.55),
          border: Border.all(color: Colors.white.withOpacity(0.04), width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Stack(
              children: [
                /// Premium Custom Painted Vector BG (Option A)
                Positioned.fill(
                  child: CustomPaint(painter: ActivePlanBgPainter()),
                ),

                /// Text Details & Progress
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ACTIVE PLAN",
                        style: GoogleFonts.outfit(
                          color: const Color(0xffFF00E5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.planName.value.isNotEmpty
                                ? controller.planName.value
                                : "Fat Loss Plan",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Keep up the great pace! ⚡",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      /// Linear Progress Bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress,
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffB100FF),
                                        Color(0xffFF00E5),
                                        Color(0xffFF7A00),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Plan Progress: Day ${controller.planDayNumber.value} of 30",
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.45),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${controller.planDaysRemaining.value} days remaining",
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.45),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// ----------------------------------------------------
  /// HONEST RESULTS PROMISE CARD
  /// ----------------------------------------------------
  Widget buildHonestResultsCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(
          0xff051911,
        ).withOpacity(0.40), // Subtle emerald health tint
        border: Border.all(
          color: const Color(0xff00FF87).withOpacity(0.18),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff00FF87).withOpacity(0.02),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xff00FF87).withOpacity(0.12),
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xff00FF87),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Our Science-Backed Promise",
                      style: GoogleFonts.outfit(
                        color: const Color(0xff00FF87),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Real results take time & consistency.",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.70),
                      fontSize: 12,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            "Follow this customized meal plan consistently for 30 days and we assure you a safe, healthy weight change of ",
                      ),
                      TextSpan(
                        text: "5 to 7 kg",
                        style: GoogleFonts.outfit(
                          color: const Color(0xff00FF87),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ". No crash dieting, just home-cooked Indian meals matching your body profile.",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTrustBadge("Science-Based", Icons.science_rounded),
                    buildTrustBadge("Indian-Friendly", Icons.home_rounded),
                    buildTrustBadge(
                      "No False Claims",
                      Icons.fact_check_rounded,
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

  Widget buildTrustBadge(String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.40), size: 12),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.50),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// MEAL PROGRESS BAR CARD
  /// ----------------------------------------------------
  Widget buildMealProgressCard() {
    return Obx(() {
      final double progress = controller.totalMealsToday.value > 0
          ? (controller.mealsCompletedToday.value /
                    controller.totalMealsToday.value)
                .clamp(0.0, 1.0)
          : 0.0;

      return GestureDetector(
        onTap: () => Get.toNamed('/meal-plan'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff0B0817).withOpacity(0.55),
            border: Border.all(
              color: const Color(0xffB100FF).withOpacity(0.15),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.restaurant_menu_rounded,
                        color: Color(0xffB100FF),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Today's Meals",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${controller.mealsCompletedToday.value} / ${controller.totalMealsToday.value} Completed",
                    style: GoogleFonts.inter(
                      color: const Color(0xffB100FF),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 6,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xffB100FF), Color(0xffFF00E5)],
                          ),
                          borderRadius: BorderRadius.circular(3),
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
    });
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
    return Obx(() {
      if (controller.homeMeals.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff0B0817).withOpacity(0.55),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Center(
            child: Text(
              "No active meal plans found.",
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
              ),
            ),
          ),
        );
      }

      return Column(
        children: List.generate(controller.homeMeals.length, (index) {
          final meal = controller.homeMeals[index];
          final bool isFirst = index == 0;
          final bool isLast = index == controller.homeMeals.length - 1;
          final color = meal["color"] as Color;
          final icon = meal["icon"] as IconData;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Vertical timeline custom drawn
              SizedBox(
                width: 24,
                height: 106,
                child: CustomPaint(
                  painter: TimelineNodePainter(
                    isFirst: isFirst,
                    isLast: isLast,
                    color: color,
                    isActive: meal["tag"] == "Completed",
                  ),
                ),
              ),
              const SizedBox(width: 8),

              /// Meal card itself
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed('/meal-plan'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: const Color(0xff0B0817).withOpacity(0.50),
                      border: Border.all(
                        color: color.withOpacity(0.22),
                        width: 1.0,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.06),
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
                                color.withOpacity(0.25),
                                color.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: color.withOpacity(0.35),
                              width: 0.8,
                            ),
                          ),
                          child: Icon(icon, color: color, size: 24),
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                                color: color.withOpacity(0.12),
                                border: Border.all(
                                  color: color.withOpacity(0.20),
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
                                    color: color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    meal["tag"] as String,
                                    style: GoogleFonts.outfit(
                                      color: color,
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
              ),
            ],
          );
        }),
      );
    });
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
    return Obx(() {
      final double currentW = controller.currentWeight.value;
      final double diffW = controller.weightDifference.value;
      final String diffText = diffW >= 0
          ? "↑ ${diffW.toStringAsFixed(1)} kg"
          : "↓ ${diffW.abs().toStringAsFixed(1)} kg";
      final Color diffColor = diffW <= 0
          ? const Color(0xff00FF87)
          : const Color(0xffFF3B30);

      final List<double> weights = controller.weightHistoryLogs
          .map((log) => (log['weight'] as num).toDouble())
          .toList();
      final List<String> labels = controller.weightHistoryLogs
          .map((log) => log['date'] as String)
          .toList();

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
                      "Weight Progress",
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
                          "${currentW.toStringAsFixed(1)} kg",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          diffText,
                          style: GoogleFonts.inter(
                            color: diffColor,
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
                painter: ProgressLineChartPainter(weights: weights),
              ),
            ),
            const SizedBox(height: 6),

            /// X-Axis labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels.map((label) => xAxisLabel(label)).toList(),
            ),
          ],
        ),
      );
    });
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
    return GestureDetector(
      onTap: () => Get.toNamed('/progress-photos'),
      child: Container(
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

        return GestureDetector(
          onTap: () {
            final title = action["title"] as String;
            if (title.contains("Progress")) {
              Get.toNamed('/progress');
            } else if (title.contains("Expert")) {
              Get.toNamed('/booking');
            } else if (title.contains("Supplements")) {
              Get.toNamed('/supplements');
            } else if (title.contains("Social")) {
              Get.toNamed('/social-feed');
            } else if (title.contains("Family")) {
              Get.toNamed('/family');
            } else if (title.contains("More")) {
              showMoreActionsSheet(context);
            }
          },
          child: Column(
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
          ),
        );
      },
    );
  }

  void showMoreActionsSheet(BuildContext context) {
    final extraActions = [
      {
        "title": "Health Insights",
        "subtitle": "Science-backed health tips",
        "icon": Icons.lightbulb_rounded,
        "color": const Color(0xff00E5FF),
        "route": '/health-tips',
      },
      {
        "title": "Video Consultation",
        "subtitle": "Live expert consultation",
        "icon": Icons.video_call_rounded,
        "color": const Color(0xffFF00E5),
        "route": '/video-call',
      },
      {
        "title": "Smart Reminders",
        "subtitle": "Workout, meal & water alarms",
        "icon": Icons.alarm_rounded,
        "color": const Color(0xffFF7A00),
        "route": '/reminders',
      },
    ];

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xff090414),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "More Quick Actions",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Explore other features and utilities",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: extraActions.length,
                    itemBuilder: (context, idx) {
                      final act = extraActions[idx];
                      final icon = act["icon"] as IconData;
                      final color = act["color"] as Color;
                      final route = act["route"] as String;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Get.back();
                              Get.toNamed(route);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color.withOpacity(0.08),
                                      border: Border.all(
                                        color: color.withOpacity(0.20),
                                      ),
                                    ),
                                    child: Icon(icon, color: color, size: 18),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          act["title"] as String,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          act["subtitle"] as String,
                                          style: GoogleFonts.inter(
                                            color: Colors.white.withOpacity(
                                              0.40,
                                            ),
                                            fontSize: 9.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white.withOpacity(0.20),
                                    size: 11,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
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
          navItem(Icons.home_filled, "Dashboard", true, onTap: () {}),
          navItem(
            Icons.restaurant_rounded,
            "Meals",
            false,
            onTap: () => Get.toNamed('/meal-plan'),
          ),
          const SizedBox(width: 40), // Spacer for FAB
          navItem(
            Icons.groups_rounded,
            "Experts",
            false,
            onTap: () => Get.toNamed('/booking'),
          ),
          navItem(
            Icons.card_giftcard_rounded,
            "Rewards",
            false,
            onTap: () => Get.toNamed('/rewards-hub'),
          ),
        ],
      ),
    );
  }

  Widget navItem(
    IconData icon,
    String label,
    bool active, {
    VoidCallback? onTap,
  }) {
    Color activeColor = const Color(0xffFF00E5);
    Color inactiveColor = Colors.white.withOpacity(0.40);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
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
      ),
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
  final List<double> weights;

  ProgressLineChartPainter({required this.weights});

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

    if (weights.isEmpty) return;

    double minVal = weights.reduce(min);
    double maxVal = weights.reduce(max);
    double valRange = maxVal - minVal;
    if (valRange == 0) valRange = 1.0;

    double stepX =
        size.width / (weights.length - 1 == 0 ? 1 : weights.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < weights.length; i++) {
      double x = i * stepX;
      double normalized = (weights[i] - minVal) / valRange;
      double y = size.height * 0.80 - (normalized * size.height * 0.65);
      points.add(Offset(x, y));
    }

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ActivePlanBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    /// A. Draw Purple/Pink Nebula Radial Gradients
    Paint nebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xffFF00E5).withOpacity(0.18),
          const Color(0xffB100FF).withOpacity(0.04),
          Colors.transparent,
        ],
        center: Alignment.centerRight,
      ).createShader(Rect.fromLTRB(w * 0.4, -h * 0.2, w * 1.2, h * 1.2));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), nebulaPaint);

    /// B. Draw Stars/Dots
    Paint starPaint = Paint()..color = Colors.white.withOpacity(0.15);
    canvas.drawCircle(Offset(w * 0.15, h * 0.22), 1.0, starPaint);
    canvas.drawCircle(Offset(w * 0.32, h * 0.18), 1.2, starPaint);
    canvas.drawCircle(Offset(w * 0.45, h * 0.35), 0.8, starPaint);
    canvas.drawCircle(
      Offset(w * 0.72, h * 0.12),
      1.5,
      starPaint..color = Colors.white.withOpacity(0.25),
    );
    canvas.drawCircle(Offset(w * 0.88, h * 0.28), 1.0, starPaint);
    canvas.drawCircle(Offset(w * 0.62, h * 0.45), 0.7, starPaint);

    /// C. Draw Mountain Silhouette (right aligned bottom)
    Path mountain = Path();
    mountain.moveTo(w * 0.42, h);
    mountain.lineTo(w * 0.64, h * 0.52); // Peak
    mountain.lineTo(w * 0.86, h);
    mountain.close();

    Paint mountainPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xff120826), Color(0xff06010F)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(w * 0.4, h * 0.5, w * 0.9, h));

    canvas.drawPath(mountain, mountainPaint);

    /// Draw a tiny human silhouette on peak
    Paint humanPaint = Paint()..color = Colors.white.withOpacity(0.50);
    double px = w * 0.64;
    double py = h * 0.52;
    canvas.drawCircle(Offset(px, py - 4), 1.2, humanPaint); // Head
    canvas.drawLine(
      Offset(px, py - 3),
      Offset(px, py),
      Paint()
        ..color = Colors.white.withOpacity(0.50)
        ..strokeWidth = 1.0,
    ); // Body

    /// D. Draw Glowing Circular Target/Streak Ring (Far Right side)
    double cx = w * 0.82;
    double cy = h * 0.40;
    double r = 32.0;

    // Glowing border ring
    Paint ringPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xffB100FF),
          Color(0xffFF00E5),
          Color(0xffFF7A00),
          Color(0xffB100FF),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    // Outer glow - concentric circles (safe)
    for (double i = 1; i <= 3; i++) {
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5 + (i * 2.0)
          ..color = const Color(0xffB100FF).withOpacity(0.12 / i),
      );
    }
    canvas.drawCircle(Offset(cx, cy), r, ringPaint);

    // Inner background
    canvas.drawCircle(
      Offset(cx, cy),
      r - 1.5,
      Paint()..color = const Color(0xff090414).withOpacity(0.85),
    );

    // Target emoji drawn inside (🎯 represent Active Plan goal)
    TextPainter textPainter = TextPainter(
      text: const TextSpan(text: "🎯", style: TextStyle(fontSize: 16)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(cx - textPainter.width / 2, cy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
