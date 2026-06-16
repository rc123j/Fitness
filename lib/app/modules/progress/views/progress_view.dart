import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/progress_controller.dart';

class ProgressView extends GetView<ProgressController> {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND NEON BLUR BLOBS
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
                    const Color(0xffB100FF).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF00E5).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// MAIN SCREEN CONTENT
          SafeArea(
            child: Column(
              children: [
                /// HEADER
                buildHeader(),

                /// BODY CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        /// 1. OVERALL PROGRESS CARD
                        buildOverallProgressCard(),
                        const SizedBox(height: 20),

                        /// 2. TIMEFRAME SELECTOR ROW
                        buildTimeframeSelector(),
                        const SizedBox(height: 20),

                        /// 3. METRICS GRID ROW (WEIGHT, BODY FAT, MUSCLE, BMI)
                        buildMetricsGrid(),
                        const SizedBox(height: 20),

                        /// 4. WEIGHT TREND CHART CARD
                        buildWeightTrendCard(),
                        const SizedBox(height: 20),

                        /// 5. BODY COMPOSITION CARD
                        buildBodyCompositionCard(),
                        const SizedBox(height: 20),

                        /// 6. BOTTOM CARDS (ACHIEVEMENTS & GOAL PROGRESS)
                        buildAchievementsAndGoalRow(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                /// BOTTOM NAVIGATION BAR
                buildBottomNav(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// HEADER WIDGET
  /// ----------------------------------------------------
  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          /// Back Button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 0.8,
                ),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 14),

          /// Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Progress Tracking",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Track your journey, transform your life.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          /// Actions (Calendar & More)
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 0.8,
              ),
            ),
            child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 0.8,
              ),
            ),
            child: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. OVERALL PROGRESS CARD
  /// ----------------------------------------------------
  Widget buildOverallProgressCard() {
    return GestureDetector(
      onTap: () => Get.toNamed('/progress-photos'),
      child: Container(
        height: 154,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xff0B0817).withOpacity(0.55),
          border: Border.all(
            color: Colors.white.withOpacity(0.04),
            width: 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            /// Beautiful Mountain Nebula Backdrop Painting
            Positioned.fill(
              child: CustomPaint(
                painter: MountainNebulaPainter(),
              ),
            ),

            /// Text Details & Progress
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Overall Progress",
                    style: GoogleFonts.outfit(
                      color: const Color(0xffFF00E5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "72",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                height: 0.9,
                              ),
                            ),
                            TextSpan(
                              text: "%",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "You're doing great! 🎉",
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
                            widthFactor: 0.72,
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
                      Text(
                        "Keep going! 28% left to your goal.",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 9,
                        ),
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
}

  /// ----------------------------------------------------
  /// 2. TIMEFRAME SELECTOR ROW
  /// ----------------------------------------------------
  Widget buildTimeframeSelector() {
    final list = ["7 Days", "30 Days", "3 Months", "1 Year", "All Time"];
    return Obx(() {
      final selected = controller.selectedTimeframe.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list.map((time) {
          final isActive = time == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.changeTimeframe(time),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xffB100FF)
                        : Colors.white.withOpacity(0.04),
                    width: 1.0,
                  ),
                  color: isActive
                      ? const Color(0xffB100FF).withOpacity(0.08)
                      : Colors.white.withOpacity(0.02),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xffB100FF).withOpacity(0.12),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    time,
                    style: GoogleFonts.outfit(
                      color: isActive ? Colors.white : Colors.white.withOpacity(0.40),
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  /// ----------------------------------------------------
  /// 3. METRICS GRID ROW (WEIGHT, BODY FAT, MUSCLE, BMI)
  /// ----------------------------------------------------
  Widget buildMetricsGrid() {
    return Obx(() {
      return Row(
        children: [
          /// Card 1: Weight
          Expanded(
            child: buildMetricMiniCard(
              title: "Weight",
              value: "${controller.weight.value.toStringAsFixed(1)}",
              unit: "kg",
              change: controller.weightChange.value,
              icon: Icons.scale_rounded,
              accentColor: const Color(0xffB100FF),
              points: [71.0, 70.1, 69.3, 69.0, 68.6, 68.4, 68.4],
            ),
          ),
          const SizedBox(width: 8),

          /// Card 2: Body Fat
          Expanded(
            child: buildMetricMiniCard(
              title: "Body Fat",
              value: "${controller.bodyFat.value.toStringAsFixed(1)}",
              unit: "%",
              change: controller.bodyFatChange.value,
              icon: Icons.accessibility_new_rounded,
              accentColor: const Color(0xffFF7A00),
              points: [21.8, 21.0, 20.4, 19.8, 19.2, 18.7, 18.7],
            ),
          ),
          const SizedBox(width: 8),

          /// Card 3: Muscle Mass
          Expanded(
            child: buildMetricMiniCard(
              title: "Muscle Mass",
              value: "${controller.muscleMass.value.toStringAsFixed(1)}",
              unit: "kg",
              change: controller.muscleMassChange.value,
              icon: Icons.fitness_center_rounded,
              accentColor: const Color(0xffFF00E5),
              points: [30.2, 30.5, 31.0, 31.5, 32.0, 32.6, 32.6],
            ),
          ),
          const SizedBox(width: 8),

          /// Card 4: BMI
          Expanded(
            child: buildMetricMiniCard(
              title: "BMI",
              value: "${controller.bmi.value.toStringAsFixed(1)}",
              unit: "",
              change: controller.bmiChange.value,
              icon: Icons.person_outline_rounded,
              accentColor: const Color(0xffB100FF),
              points: [23.9, 23.6, 23.4, 23.3, 23.2, 23.1, 23.1],
            ),
          ),
        ],
      );
    });
  }

  Widget buildMetricMiniCard({
    required String title,
    required String value,
    required String unit,
    required double change,
    required IconData icon,
    required Color accentColor,
    required List<double> points,
  }) {
    bool isDown = change < 0;
    String sign = isDown ? "↓" : "↑";
    String changeText = "$sign ${change.abs().toStringAsFixed(1)} ${unit == '%' ? '%' : unit.isEmpty ? '' : 'kg'}";

    return Container(
      height: 122,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.03),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row (Icon + Title)
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Row(
              children: [
                Icon(icon, color: accentColor, size: 14),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// Value
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (unit.isNotEmpty)
                    TextSpan(
                      text: " $unit",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.40),
                        fontSize: 8,
                      ),
                    ),
                ],
              ),
            ),
          ),

          /// Change Trend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            child: Text(
              changeText,
              style: GoogleFonts.inter(
                color: const Color(0xff00FF87),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "vs last 30 days",
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.30),
                fontSize: 7,
              ),
            ),
          ),

          const Spacer(),

          /// Custom Painted Sparkline at the bottom
          SizedBox(
            height: 24,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: CustomPaint(
                painter: SparklinePainter(
                  points: points,
                  color: accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 4. WEIGHT TREND CHART CARD
  /// ----------------------------------------------------
  Widget buildWeightTrendCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          /// Chart Header (Title & Selection Dropdown)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weight Trend",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// Dropdown Select
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 0.8,
                  ),
                  color: Colors.white.withOpacity(0.01),
                ),
                child: Row(
                  children: [
                    Text(
                      "Weight (kg)",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.60),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white.withOpacity(0.60),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          /// Chart Graphic
          Obx(() {
            final data = controller.weightTrendData;
            return SizedBox(
              height: 180,
              width: double.infinity,
              child: CustomPaint(
                painter: WeightTrendPainter(data: data),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 5. BODY COMPOSITION CARD
  /// ----------------------------------------------------
  Widget buildBodyCompositionCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Body Composition",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),

          Row(
            children: [
              /// Left: Custom Segmented Donut Chart
              CustomPaint(
                size: const Size(120, 120),
                painter: BodyCompositionDonutPainter(
                  musclePercent: 0.487,
                  fatPercent: 0.187,
                  otherPercent: 0.326,
                ),
              ),
              const SizedBox(width: 20),

              /// Right: Legend Table
              Expanded(
                child: Column(
                  children: [
                    buildCompositionLegendRow(
                      color: const Color(0xffB100FF),
                      label: "Muscle Mass",
                      weight: "32.6 kg",
                      percentage: "48.7%",
                      percentColor: const Color(0xffB100FF),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: Colors.white.withOpacity(0.04), height: 0.8),
                    ),
                    buildCompositionLegendRow(
                      color: const Color(0xffFF7A00),
                      label: "Body Fat",
                      weight: "18.7 kg",
                      percentage: "18.7%",
                      percentColor: const Color(0xffFF7A00),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: Colors.white.withOpacity(0.04), height: 0.8),
                    ),
                    buildCompositionLegendRow(
                      color: const Color(0xffFF00E5),
                      label: "Other (Bone, Water, etc.)",
                      weight: "16.1 kg",
                      percentage: "32.6%",
                      percentColor: const Color(0xffFF00E5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCompositionLegendRow({
    required Color color,
    required String label,
    required String weight,
    required String percentage,
    required Color percentColor,
  }) {
    return Row(
      children: [
        Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.50),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          weight,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          percentage,
          style: GoogleFonts.inter(
            color: percentColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// 6. BOTTOM ROW CARDS (ACHIEVEMENTS & GOAL PROGRESS)
  /// ----------------------------------------------------
  Widget buildAchievementsAndGoalRow() {
    return Row(
      children: [
        /// Card 1: Achievements
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff0B0817).withOpacity(0.55),
              border: Border.all(
                color: Colors.white.withOpacity(0.03),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                /// Trophy Icon Container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xffB100FF).withOpacity(0.12),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xffB100FF),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),

                /// Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Achievements",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.40),
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(() => Text(
                            "${controller.achievementsCount.value}",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      Text(
                        "Badges Earned",
                        style: GoogleFonts.inter(
                          color: const Color(0xffB100FF),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.20),
                  size: 12,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),

        /// Card 2: Goal Progress
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff0B0817).withOpacity(0.55),
              border: Border.all(
                color: Colors.white.withOpacity(0.03),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                /// Target Icon Container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xffFF7A00).withOpacity(0.12),
                  ),
                  child: const Icon(
                    Icons.track_changes_rounded,
                    color: Color(0xffFF7A00),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),

                /// Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Goal Progress",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.40),
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(() => Text(
                            "${controller.overallProgress.value}%",
                            style: GoogleFonts.outfit(
                              color: const Color(0xffFF7A00),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      Obx(() => Text(
                            "Goal: ${controller.goalWeight.value.toInt()} kg",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.40),
                              fontSize: 8,
                            ),
                          )),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.20),
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// BOTTOM NAVIGATION BAR
  /// ----------------------------------------------------
  Widget buildBottomNav() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xff090414),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(Icons.home_outlined, "Home", false, onTap: () => Get.offNamed('/home')),
          navItem(Icons.restaurant_rounded, "Meal Plan", false, onTap: () => Get.offNamed('/meal-plan')),
          navItem(Icons.bar_chart_rounded, "Progress", true, onTap: () {}),
          navItem(Icons.groups_rounded, "Experts", false, onTap: () => Get.offNamed('/booking')),
          navItem(Icons.person_rounded, "Profile", false, onTap: () => Get.offNamed('/profile')),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, String label, bool active, {VoidCallback? onTap}) {
    Color activeColor = const Color(0xffB100FF);
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
/// CUSTOM PAINTERS FOR PREMIUM GRAPHICS
/// ----------------------------------------------------

/// 1. Overall Progress Backdrop (Mountain Peak & Starry Sky Nebula)
class MountainNebulaPainter extends CustomPainter {
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
    canvas.drawCircle(Offset(w * 0.72, h * 0.12), 1.5, starPaint..color = Colors.white.withOpacity(0.25));
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
        colors: [
          Color(0xff120826),
          Color(0xff06010F),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(w * 0.4, h * 0.5, w * 0.9, h));

    canvas.drawPath(mountain, mountainPaint);

    /// Draw a tiny human silhouette on peak
    Paint humanPaint = Paint()..color = Colors.white.withOpacity(0.50);
    double px = w * 0.64;
    double py = h * 0.52;
    canvas.drawCircle(Offset(px, py - 4), 1.2, humanPaint); // Head
    canvas.drawLine(Offset(px, py - 3), Offset(px, py), Paint()..color = Colors.white.withOpacity(0.50)..strokeWidth = 1.0); // Body

    /// D. Draw Glowing Circular Arrow Ring (Far Right side)
    double cx = w * 0.82;
    double cy = h * 0.50;
    double r = 38.0;

    // Glowing border ring - LinearGradient (safe)
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
    canvas.drawCircle(Offset(cx, cy), r - 1.5, Paint()..color = const Color(0xff090414).withOpacity(0.85));

    // Trending up icon drawn inside
    TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: "📈",
        style: TextStyle(fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(cx - textPainter.width / 2, cy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 2. Sparkline Painter for Metric Mini Cards
class SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    double w = size.width;
    double h = size.height;

    double minVal = points.reduce(min);
    double maxVal = points.reduce(max);
    double valRange = maxVal - minVal;
    if (valRange == 0) valRange = 1.0;

    double stepX = w / (points.length - 1);

    Path linePath = Path();
    Path fillPath = Path();

    for (int i = 0; i < points.length; i++) {
      double x = i * stepX;
      // Map value to Y coordinate (invert since 0 is top)
      double normalized = (points[i] - minVal) / valRange;
      double y = h - (normalized * (h - 8)) - 4; // leave 4px padding top/bottom

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, h);
        fillPath.lineTo(x, y);
      } else {
        // Draw smooth cubic curve
        double prevX = (i - 1) * stepX;
        double prevNormalized = (points[i - 1] - minVal) / valRange;
        double prevY = h - (prevNormalized * (h - 8)) - 4;
        
        double controlX1 = prevX + (stepX / 2);
        double controlY1 = prevY;
        double controlX2 = prevX + (stepX / 2);
        double controlY2 = y;
        
        linePath.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
        fillPath.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
      }

      if (i == points.length - 1) {
        fillPath.lineTo(x, h);
        fillPath.close();
      }
    }

    /// Paint Line
    Paint linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    /// Glow shadow - concentric lines (safe)
    for (double i = 1; i <= 3; i++) {
      canvas.drawPath(
        linePath,
        Paint()
          ..color = color.withOpacity(0.15 / i)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 + (i * 1.5)
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.drawPath(linePath, linePaint);

    /// Paint Fill
    Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(0.12),
          color.withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 3. Weight Trend Main Chart Painter
class WeightTrendPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  WeightTrendPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    double w = size.width;
    double h = size.height;

    // Margins for axes
    double labelHeight = 20.0;
    double labelWidth = 32.0;

    double chartWidth = w - labelWidth;
    double chartHeight = h - labelHeight;

    List<double> weights = data.map((e) => (e["weight"] as num).toDouble()).toList();
    double minWeight = 63.0; // Y axis bottom range
    double maxWeight = 75.0; // Y axis top range
    double weightRange = maxWeight - minWeight;

    /// Draw Horizontal Grid Lines & Y Labels
    Paint gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 0.8;

    double yStepsCount = 4; // 63, 66, 69, 72, 75
    for (int i = 0; i <= yStepsCount; i++) {
      double value = minWeight + (weightRange * (i / yStepsCount));
      double y = chartHeight - (chartHeight * (i / yStepsCount));

      // Draw grid line
      canvas.drawLine(Offset(labelWidth, y), Offset(w, y), gridPaint);

      // Draw Y axis Label
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: "${value.toInt()}",
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.40),
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(0, y - (textPainter.height / 2)));
    }

    /// Calculate coordinate points
    double stepX = chartWidth / (data.length - 1);
    List<Offset> points = [];

    for (int i = 0; i < data.length; i++) {
      double x = labelWidth + (i * stepX);
      double normalizedY = (weights[i] - minWeight) / weightRange;
      double y = chartHeight - (normalizedY * chartHeight);
      points.add(Offset(x, y));
    }

    /// Build Paths
    Path linePath = Path();
    Path fillPath = Path();

    linePath.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, chartHeight);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      // Smooth cubic curve interpolation
      double prevX = points[i - 1].dx;
      double prevY = points[i - 1].dy;
      double currX = points[i].dx;
      double currY = points[i].dy;

      double cp1x = prevX + (stepX * 0.4);
      double cp1y = prevY;
      double cp2x = prevX + (stepX * 0.6);
      double cp2y = currY;

      linePath.cubicTo(cp1x, cp1y, cp2x, cp2y, currX, currY);
      fillPath.cubicTo(cp1x, cp1y, cp2x, cp2y, currX, currY);
    }
    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.close();

    /// Draw Gradient Fill Under the Line
    Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xffB100FF).withOpacity(0.18),
          const Color(0xffB100FF).withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(labelWidth, 0, chartWidth, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    /// Draw Glowing Outline Line
    Paint linePaint = Paint()
      ..color = const Color(0xffFF00E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    /// Glow shadow - concentric lines (safe)
    for (double i = 1; i <= 3; i++) {
      canvas.drawPath(
        linePath,
        Paint()
          ..color = const Color(0xffFF00E5).withOpacity(0.15 / i)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 + (i * 2.0)
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.drawPath(linePath, linePaint);

    /// Draw Circles & Values on Data Points
    Paint pointBgPaint = Paint()..color = const Color(0xff06010F);
    Paint pointStrokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < points.length; i++) {
      Offset p = points[i];
      // Draw point circle
      canvas.drawCircle(p, 4.0, pointBgPaint);
      canvas.drawCircle(p, 4.0, pointStrokePaint);

      // Draw value text label on top of each node except the active last tooltip point
      if (i < points.length - 1) {
        TextPainter valPainter = TextPainter(
          text: TextSpan(
            text: weights[i].toStringAsFixed(1),
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        valPainter.paint(canvas, Offset(p.dx - (valPainter.width / 2), p.dy - 16));
      }

      // Draw X axis Label (Date)
      TextPainter datePainter = TextPainter(
        text: TextSpan(
          text: data[i]["date"],
          style: GoogleFonts.inter(
            color: i == points.length - 1
                ? const Color(0xffFF00E5)
                : Colors.white.withOpacity(0.40),
            fontSize: 8,
            fontWeight: i == points.length - 1 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      datePainter.paint(
        canvas,
        Offset(p.dx - (datePainter.width / 2), chartHeight + 6),
      );
    }

    /// Draw Hover Tooltip Box on the Last Point
    Offset lastPt = points.last;
    double tooltipW = 58.0;
    double tooltipH = 32.0;
    Rect tooltipRect = Rect.fromLTWH(
      lastPt.dx - (tooltipW / 2) - 4,
      lastPt.dy - tooltipH - 14,
      tooltipW,
      tooltipH,
    );

    RRect tooltipRRect = RRect.fromRectAndRadius(tooltipRect, const Radius.circular(8));
    
    // Draw Box Shadow Glow - concentric rounded rects (safe)
    for (double i = 1; i <= 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          tooltipRect.inflate(i * 1.5),
          Radius.circular(8 + i),
        ),
        Paint()
          ..color = const Color(0xffB100FF).withOpacity(0.10 / i)
          ..style = PaintingStyle.fill,
      );
    }
    // Draw Box Fill
    canvas.drawRRect(tooltipRRect, Paint()..color = const Color(0xff1A0A3A));
    // Draw Border
    canvas.drawRRect(
      tooltipRRect,
      Paint()
        ..color = const Color(0xffB100FF).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // Draw Tooltip Text (68.4 kg, 15 May)
    TextPainter tooltipPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${weights.last.toStringAsFixed(1)} kg\n",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          TextSpan(
            text: "${data.last["date"]}",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.50),
              fontSize: 7,
              height: 1.1,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: tooltipW);
    
    tooltipPainter.paint(
      canvas,
      Offset(
        tooltipRect.left + (tooltipW - tooltipPainter.width) / 2,
        tooltipRect.top + (tooltipH - tooltipPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 5. Body Composition Donut Chart Painter
class BodyCompositionDonutPainter extends CustomPainter {
  final double musclePercent;
  final double fatPercent;
  final double otherPercent;

  BodyCompositionDonutPainter({
    required this.musclePercent,
    required this.fatPercent,
    required this.otherPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 12.0;
    double radius = (size.width - strokeWidth) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -pi / 2;

    /// 1. Muscle Mass Segment (Purple)
    if (musclePercent > 0) {
      double sweep = 2 * pi * musclePercent;
      Paint mPaint = Paint()
        ..color = const Color(0xffB100FF)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawArc(rect, startAngle, sweep, false, mPaint);
      startAngle += sweep;
    }

    /// 2. Body Fat Segment (Orange)
    if (fatPercent > 0) {
      double sweep = 2 * pi * fatPercent;
      Paint fPaint = Paint()
        ..color = const Color(0xffFF7A00)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawArc(rect, startAngle, sweep, false, fPaint);
      startAngle += sweep;
    }

    /// 3. Other Segment (Pink)
    if (otherPercent > 0) {
      double sweep = 2 * pi * otherPercent;
      Paint oPaint = Paint()
        ..color = const Color(0xffFF00E5)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawArc(rect, startAngle, sweep, false, oPaint);
    }

    /// Center Text (Total 100%)
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Total\n",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.50),
              fontSize: 10,
              height: 1.1,
            ),
          ),
          TextSpan(
            text: "100%",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - (textPainter.width / 2),
        center.dy - (textPainter.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
