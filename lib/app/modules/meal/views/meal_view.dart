import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/meal_controller.dart';

class MealView extends GetView<MealController> {
  const MealView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
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
            bottom: 150,
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

          /// MAIN VIEW CONTENT
          SafeArea(
            child: Column(
              children: [
                /// 1. APP BAR / HEADER
                buildHeader(context),

                /// 2. SCROLLABLE BODY
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        /// TODAY'S NUTRITION JOURNEY CARD
                        buildNutritionJourneyCard(),
                        const SizedBox(height: 16),

                        /// DAILY TARGET CARD
                        buildDailyTargetCard(),
                        const SizedBox(height: 16),

                        /// TIMELINE OF MEALS
                        buildMealsTimeline(),
                        const SizedBox(height: 16),

                        buildBottomRow(),
                        const SizedBox(height: 20),
                      ],
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

  /// ----------------------------------------------------
  /// 1. HEADER WIDGET
  /// ----------------------------------------------------
  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Title & Subtitle Dropdown
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Meal Plan",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Obx(() => GestureDetector(
                    onTap: () {
                      // Mock changing date
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.selectedDate.value,
                          style: GoogleFonts.inter(
                            color: const Color(0xffFF00E5).withOpacity(0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: const Color(0xffFF00E5).withOpacity(0.85),
                          size: 14,
                        ),
                      ],
                    ),
                  )),
            ],
          ),

          /// Calendar & Options button
          Row(
            children: [
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
                child: const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
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
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 2. NUTRITION JOURNEY CARD
  /// ----------------------------------------------------
  Widget buildNutritionJourneyCard() {
    double progressPercent = 0.72; // matching the 72% text

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: const Color(0xffFF00E5).withOpacity(0.20),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Stack(
            children: [
              /// A. Background Health/Nutrition Image (Option B)
              Positioned.fill(
                child: Image.asset(
                  'assets/images/health_screen.png',
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.8, 0.0),
                ),
              ),

              /// B. Black Gradient Overlay to fade out the left side for text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xff0B0817),
                        const Color(0xff0B0817).withOpacity(0.85),
                        const Color(0xff0B0817).withOpacity(0.35),
                        const Color(0xff0B0817).withOpacity(0.15),
                      ],
                      stops: const [0.0, 0.45, 0.8, 1.0],
                    ),
                  ),
                ),
              ),

              /// C. Radial Ambient Neon Glow on the right edge
              Positioned(
                right: -40,
                top: -40,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xffFF00E5).withOpacity(0.30),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              /// Card Content Row
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    /// Left Info & Progress
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                color: Color(0xffFF00E5),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Today's Nutrition Journey",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xffFF00E5),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Obx(() => RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${controller.currentCalories.value} ",
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "/ ${controller.targetCalories.value} kcal",
                                      style: GoogleFonts.inter(
                                        color: Colors.white.withOpacity(0.40),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 12),

                          /// Gradient Progress Bar
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 8,
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
                                        widthFactor: progressPercent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xffB100FF),
                                                Color(0xffFF00E5),
                                                Color(0xffFF7A00),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "${(progressPercent * 100).toInt()}%",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xffFF7A00),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 18),

                    /// Right glowing circular icon
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        /// Glowing backdrop circle
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xffFF00E5).withOpacity(0.35),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: const Color(0xffFF7A00).withOpacity(0.20),
                                blurRadius: 22,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),

                        /// Outer double gradient circle ring
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xffFF00E5).withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xffFF7A00).withOpacity(0.3),
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),

                        /// Inside Fork/Knife icon
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff090414),
                          ),
                          child: const Icon(
                            Icons.restaurant_rounded,
                            color: Color(0xffFF00E5),
                            size: 20,
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
  /// 3. DAILY TARGET CARD (WITH CUSTOM PAINT DONUT)
  /// ----------------------------------------------------
  Widget buildDailyTargetCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          /// Target Header
          Row(
            children: [
              const Icon(
                Icons.track_changes_rounded,
                color: Color(0xffFF00E5),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "Daily Target",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Macros row + Donut circle
          Row(
            children: [
              /// Left 4 macro metrics in a 2x2 grid (represented as 2 columns of 2 items)
              Expanded(
                child: Row(
                  children: [
                    /// Column 1: Calories & Carbs
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildMacroItem(
                            icon: Icons.local_fire_department_rounded,
                            iconColor: const Color(0xffFF7A00),
                            value: "2,300",
                            unit: "kcal",
                          ),
                          const SizedBox(height: 16),
                          buildMacroItem(
                            icon: Icons.grass_rounded,
                            iconColor: const Color(0xffB100FF),
                            value: "210g",
                            unit: "Carbs",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    /// Column 2: Protein & Fat
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildMacroItem(
                            icon: Icons.fitness_center_rounded,
                            iconColor: const Color(0xff00FF87),
                            value: "145g",
                            unit: "Protein",
                          ),
                          const SizedBox(height: 16),
                          buildMacroItem(
                            icon: Icons.water_drop_rounded,
                            iconColor: const Color(0xff00A3FF),
                            value: "65g",
                            unit: "Fat",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              /// Right: Donut Progress Ring
              CustomPaint(
                size: const Size(86, 86),
                painter: DonutProgressPainter(
                  progress: 0.72,
                  gradientColors: [
                    const Color(0xffB100FF),
                    const Color(0xffFF00E5),
                    const Color(0xffFF7A00),
                    const Color(0xff00A3FF),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMacroItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            Text(
              unit,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.40),
                fontSize: 10,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// 4. MEALS TIMELINE SECTION
  /// ----------------------------------------------------
  Widget buildMealsTimeline() {
    return Column(
      children: [
        /// 1. Breakfast (Completed State)
        buildTimelineRow(
          dotColor: const Color(0xff00FF87),
          state: TimelineState.completed,
          isFirst: true,
          isLast: false,
          child: buildMealCard(
            title: "Breakfast",
            desc: "Oats with Fruits & Nuts",
            details: "450 kcal  •  22P  •  60C  •  12F",
            icon: Icons.emoji_food_beverage_rounded,
            iconColor: const Color(0xff00FF87),
            badgeText: "Completed",
            badgeColor: const Color(0xff00FF87),
            onTap: () => Get.toNamed('/meal-detail'),
          ),
        ),

        /// 2. Lunch (Active State)
        buildTimelineRow(
          dotColor: const Color(0xffFF7A00),
          state: TimelineState.active,
          isFirst: false,
          isLast: false,
          child: buildMealCard(
            title: "Lunch",
            desc: "Grilled Chicken Bowl",
            details: "550 kcal  •  40P  •  60C  •  15F",
            icon: Icons.lunch_dining_rounded,
            iconColor: const Color(0xffFF7A00),
            timeText: "12:30 PM",
            timeColor: const Color(0xffFF7A00),
            hasActions: true,
            onTap: () => Get.toNamed('/meal-detail'),
          ),
        ),

        /// 3. AI Suggestion (Nested inside timeline)
        buildTimelineRow(
          dotColor: const Color(0xffB100FF),
          state: TimelineState.suggestion,
          isFirst: false,
          isLast: false,
          child: buildAISuggestionCard(),
        ),

        /// 4. Snacks (Upcoming State)
        buildTimelineRow(
          dotColor: const Color(0xffB100FF),
          state: TimelineState.upcoming,
          isFirst: false,
          isLast: false,
          child: buildMealCard(
            title: "Snacks",
            desc: "Greek Yogurt with Berries",
            details: "200 kcal  •  15P  •  20C  •  5F",
            icon: Icons.local_drink_rounded,
            iconColor: const Color(0xffB100FF),
            timeText: "4:00 PM",
            timeColor: const Color(0xffB100FF),
            onTap: () => Get.toNamed('/meal-detail'),
          ),
        ),

        /// 5. Dinner (Upcoming State)
        buildTimelineRow(
          dotColor: Colors.white.withOpacity(0.15),
          state: TimelineState.upcomingGrey,
          isFirst: false,
          isLast: true,
          child: buildMealCard(
            title: "Dinner",
            desc: "Paneer Curry, Roti, Veggies",
            details: "450 kcal  •  25P  •  50C  •  12F",
            icon: Icons.soup_kitchen_rounded,
            iconColor: const Color(0xffFF7A00),
            timeText: "8:00 PM",
            timeColor: const Color(0xffFF7A00),
            onTap: () => Get.toNamed('/meal-detail'),
          ),
        ),
      ],
    );
  }

  /// Timeline custom connector layout
  Widget buildTimelineRow({
    required Color dotColor,
    required TimelineState state,
    required bool isFirst,
    required bool isLast,
    required Widget child,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Timeline indicator line & dot
          SizedBox(
            width: 32,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                /// Vertical Line
                Positioned(
                  top: isFirst ? 20 : 0,
                  bottom: isLast ? 20 : 0,
                  child: Container(
                    width: 1.5,
                    color: state == TimelineState.upcomingGrey
                        ? Colors.white.withOpacity(0.10)
                        : const Color(0xffB100FF).withOpacity(0.35),
                  ),
                ),

                /// Timeline Circle Dot
                Positioned(
                  top: 22,
                  child: state == TimelineState.completed
                      ? Container(
                          height: 18,
                          width: 18,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff00FF87),
                          ),
                          child: const Icon(Icons.check, size: 12, color: Colors.black),
                        )
                      : Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xff06010F),
                            border: Border.all(
                              color: dotColor,
                              width: 2.2,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),

          /// Card content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  /// General Meal Card UI
  Widget buildMealCard({
    required String title,
    required String desc,
    required String details,
    required IconData icon,
    required Color iconColor,
    String? badgeText,
    Color? badgeColor,
    String? timeText,
    Color? timeColor,
    bool hasActions = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              children: [
                /// Glowing Icon Container
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff090414),
                    border: Border.all(
                      color: iconColor.withOpacity(0.25),
                      width: 1.0,
                    ),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 12),

                /// Title & Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        desc,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.70),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Status badges / Time
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: badgeColor!.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          badgeText,
                          style: GoogleFonts.inter(
                            color: badgeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.check_circle_outline_rounded, color: badgeColor, size: 10),
                      ],
                    ),
                  ),
                if (timeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          timeText,
                          style: GoogleFonts.inter(
                            color: timeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.access_time_rounded, color: timeColor, size: 10),
                      ],
                    ),
                  ),

                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.20),
                  size: 13,
                ),
              ],
            ),

            /// Sub metrics footer
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  details,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.40),
                    fontSize: 10,
                  ),
                ),

                /// Buttons for Active card
                if (hasActions)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xffB100FF).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xffB100FF).withOpacity(0.20),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          "View Meal",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xffFF7A00).withOpacity(0.35),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          "Replace",
                          style: GoogleFonts.outfit(
                            color: const Color(0xffFF7A00),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  /// AI Suggestion timeline card
  Widget buildAISuggestionCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.45),
        border: Border.all(
          color: const Color(0xffB100FF).withOpacity(0.25),
          width: 1.0,
        ),
        gradient: LinearGradient(
          colors: [
            const Color(0xffB100FF).withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Brain Icon
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xff090414),
              border: Border.all(
                color: const Color(0xffB100FF).withOpacity(0.20),
                width: 1.0,
              ),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Color(0xffFF00E5),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          /// Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI Suggestion",
                  style: GoogleFonts.outfit(
                    color: const Color(0xffFF00E5),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Your protein intake is slightly behind target.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.70),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Consider adding:",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.40),
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    buildPill("+ Greek Yogurt"),
                    const SizedBox(width: 8),
                    buildPill("+ Whey Protein"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xffB100FF).withOpacity(0.30),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: const Color(0xffB100FF),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// 5. BOTTOM METRICS ROW (WATER BOTTLE & CALORIES ARC)
  /// ----------------------------------------------------
  Widget buildBottomRow() {
    return Row(
      children: [
        /// Left Column: Water Progress
        Expanded(
          child: Container(
            height: 172,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xff0B0817).withOpacity(0.55),
              border: Border.all(
                color: Colors.white.withOpacity(0.04),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                /// Text & drops on left
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.water_drop_rounded,
                            color: Color(0xff00A3FF),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Water Progress",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Obx(() => RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${controller.currentWater.value.toStringAsFixed(1)} ",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "/ ${controller.targetWater.value.toInt()} L",
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.40),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 10),

                      /// Droplets layout
                      Obx(() {
                        double current = controller.currentWater.value;
                        double target = controller.targetWater.value;
                        int filled = ((current / target) * 5).round().clamp(0, 5);

                        return Row(
                          children: List.generate(5, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Icon(
                                Icons.water_drop_rounded,
                                color: index < filled
                                    ? const Color(0xff00A3FF)
                                    : Colors.white.withOpacity(0.12),
                                size: 12,
                              ),
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                ),

                /// Drawing of Bottle on right
                Obx(() {
                  double ratio = controller.currentWater.value / controller.targetWater.value;
                  return CustomPaint(
                    size: const Size(60, 140),
                    painter: WaterBottlePainter(fillPercentage: ratio),
                  );
                }),
              ],
            ),
          ),
        ),

        const SizedBox(width: 14),

        /// Right Column: Calories Summary
        Expanded(
          child: Container(
            height: 172,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xff0B0817).withOpacity(0.55),
              border: Border.all(
                color: Colors.white.withOpacity(0.04),
                width: 1.0,
              ),
            ),
            child: Stack(
              children: [
                /// Main Stats
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.bar_chart_rounded,
                          color: Color(0xffB100FF),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Calories Summary",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Consumed",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.40),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "1,200",
                              style: GoogleFonts.outfit(
                                color: const Color(0xffB100FF),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "kcal",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.40),
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Remaining",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.40),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "1,100",
                              style: GoogleFonts.outfit(
                                color: const Color(0xffFF7A00),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "kcal",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.40),
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

                /// Custom Painter glowing arc at the bottom
                Positioned(
                  bottom: -15,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: const Size(120, 50),
                    painter: CaloriesArcPainter(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum TimelineState { completed, active, suggestion, upcoming, upcomingGrey }

/// ----------------------------------------------------
/// CUSTOM PAINTERS FOR GRAPHICS
/// ----------------------------------------------------

/// 1. Donut Progress Painter (Daily Target)
class DonutProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;

  DonutProgressPainter({required this.progress, required this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 8.0;
    double radius = (size.width - strokeWidth) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    /// Draw background ring
    Paint bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    /// Draw progress arc
    Rect rect = Rect.fromCircle(center: center, radius: radius);
    Paint progressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: gradientColors,
        startAngle: 0.0,
        endAngle: 2 * pi,
        transform: const GradientRotation(-pi / 2),
      ).createShader(rect);

    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, progressPaint);

    /// Draw Center Text
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${(progress * 100).toInt()}%\n",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          TextSpan(
            text: "of target",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.40),
              fontSize: 8,
              height: 1.1,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(
        center.dx - (textPainter.width / 2),
        center.dy - (textPainter.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 2. Neon Water Bottle Painter
class WaterBottlePainter extends CustomPainter {
  final double fillPercentage;

  WaterBottlePainter({required this.fillPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    Paint bottlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = const Color(0xff00A3FF).withOpacity(0.7);

    /// Define Path for Bottle
    Path bottlePath = Path();

    // Start at neck top left
    bottlePath.moveTo(w * 0.35, h * 0.12);
    // top edge of cap
    bottlePath.lineTo(w * 0.35, h * 0.06);
    bottlePath.lineTo(w * 0.65, h * 0.06);
    bottlePath.lineTo(w * 0.65, h * 0.12);
    // neck down
    bottlePath.lineTo(w * 0.32, h * 0.12);
    bottlePath.lineTo(w * 0.32, h * 0.17);
    // shoulder out left
    bottlePath.quadraticBezierTo(w * 0.32, h * 0.22, w * 0.15, h * 0.26);
    // left body side
    bottlePath.lineTo(w * 0.15, h * 0.88);
    // bottom left corner
    bottlePath.quadraticBezierTo(w * 0.15, h * 0.94, w * 0.30, h * 0.94);
    // bottom edge
    bottlePath.lineTo(w * 0.70, h * 0.94);
    // bottom right corner
    bottlePath.quadraticBezierTo(w * 0.85, h * 0.94, w * 0.85, h * 0.88);
    // right body side
    bottlePath.lineTo(w * 0.85, h * 0.26);
    // shoulder out right
    bottlePath.quadraticBezierTo(w * 0.68, h * 0.22, w * 0.68, h * 0.17);
    bottlePath.lineTo(w * 0.68, h * 0.12);
    bottlePath.close();

    /// Draw Water Fill
    canvas.save();
    canvas.clipPath(bottlePath);

    double fillHeight = h * 0.94 - (h * 0.68 * fillPercentage);

    Rect waterRect = Rect.fromLTRB(w * 0.05, fillHeight, w * 0.95, h * 0.95);
    Paint waterPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xff00A3FF).withOpacity(0.60),
          const Color(0xff0051FF).withOpacity(0.25),
        ],
      ).createShader(waterRect);

    canvas.drawRect(waterRect, waterPaint);

    /// Draw inside ticks
    Paint tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1.0;

    double startTickY = h * 0.32;
    double endTickY = h * 0.84;
    double step = (endTickY - startTickY) / 4;

    for (int i = 0; i < 5; i++) {
      double y = startTickY + (step * i);
      canvas.drawLine(Offset(w * 0.30, y), Offset(w * 0.42, y), tickPaint);
    }
    canvas.restore();

    /// Draw Bottle boundary
    canvas.drawPath(bottlePath, bottlePaint);

    /// Draw Neon outer glow border reflection - concentric lines (safe)
    for (double i = 1; i <= 3; i++) {
      canvas.drawPath(
        bottlePath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5 + (i * 0.8)
          ..color = const Color(0xff00A3FF).withOpacity(0.10 / i),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 3. Calories Summary Arc Painter
class CaloriesArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    Rect rect = Rect.fromLTWH(-w * 0.1, 0, w * 1.2, h * 2.0);

    /// Draw main neon arc
    Paint arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [
          Color(0xffB100FF),
          Color(0xffFF00E5),
          Color(0xffFF7A00),
        ],
      ).createShader(rect);

    canvas.drawArc(rect, pi, pi, false, arcPaint);

    /// Draw neon glow shadow - concentric arcs (safe)
    for (double i = 1; i <= 3; i++) {
      canvas.drawArc(
        rect,
        pi,
        pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0 + (i * 1.5)
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xffFF00E5).withOpacity(0.12 / i),
      );
    }

    /// Paint small floating glowing particle points
    Paint dotPaint = Paint()..color = const Color(0xffFF00E5);
    canvas.drawCircle(Offset(w * 0.22, h * 0.32), 2.0, dotPaint);

    Paint dotPaintOrange = Paint()..color = const Color(0xffFF7A00);
    canvas.drawCircle(Offset(w * 0.78, h * 0.32), 1.5, dotPaintOrange);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
