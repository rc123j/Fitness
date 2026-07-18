import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/meal_controller.dart';
import '../../../widgets/rocket_launch_overlay.dart';

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
                        buildMealsTimeline(context),
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
                      if (controller.selectedQueryDate.value.isNotEmpty) {
                        controller.selectedQueryDate.value = "";
                        controller.fetchMealData();
                      }
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
                          controller.selectedQueryDate.value.isNotEmpty
                              ? Icons.close_rounded
                              : Icons.keyboard_arrow_down_rounded,
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
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedQueryDate.value.isNotEmpty
                        ? DateTime.parse(controller.selectedQueryDate.value)
                        : DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Color(0xffFF00E5),
                            onPrimary: Colors.black,
                            surface: Color(0xff0B0817),
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: const Color(0xff06010F),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    final monthStr = picked.month.toString().padLeft(2, '0');
                    final dayStr = picked.day.toString().padLeft(2, '0');
                    controller.selectedQueryDate.value = "${picked.year}-$monthStr-$dayStr";
                    controller.fetchMealData();
                  }
                },
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
                  child: const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 18),
                ),
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
    return Obx(() {
      double progressPercent = controller.targetCalories.value > 0
          ? (controller.currentCalories.value / controller.targetCalories.value).clamp(0.0, 1.0)
          : 0.0;

    return GestureDetector(
      onTap: () => Get.toNamed('/calorie-history'),
      child: Container(
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
    ),
    );
    });
  }

  /// ----------------------------------------------------
  /// 3. DAILY TARGET CARD (WITH CUSTOM PAINT DONUT)
  /// ----------------------------------------------------
  Widget buildDailyTargetCard() {
    return Obx(() {
      final double progress = controller.targetCalories.value > 0
          ? (controller.currentCalories.value / controller.targetCalories.value).clamp(0.0, 1.0)
          : 0.0;

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
                              value: controller.targetCalories.value.toString(),
                              unit: "kcal",
                            ),
                            const SizedBox(height: 16),
                            buildMacroItem(
                              icon: Icons.grass_rounded,
                              iconColor: const Color(0xffB100FF),
                              value: "${controller.targetCarbs.value}g",
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
                              value: "${controller.targetProtein.value}g",
                              unit: "Protein",
                            ),
                            const SizedBox(height: 16),
                            buildMacroItem(
                              icon: Icons.water_drop_rounded,
                              iconColor: const Color(0xff00A3FF),
                              value: "${controller.targetFat.value}g",
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
                    progress: progress,
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
    });
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
  Widget buildMealsTimeline(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFF00E5)),
            ),
          ),
        );
      }

      if (controller.mealTimeline.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff0B0817).withOpacity(0.55),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Center(
            child: Text(
              "No active meal plans found.\nPlease complete Onboarding first.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white.withOpacity(0.6), fontSize: 13),
            ),
          ),
        );
      }

      final bool isPast = controller.selectedQueryDate.value.isNotEmpty
          ? DateTime.parse(controller.selectedQueryDate.value).isBefore(
              DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
            )
          : false;
      final bool isFuture = controller.selectedQueryDate.value.isNotEmpty
          ? DateTime.parse(controller.selectedQueryDate.value).isAfter(
              DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
            )
          : false;

      return Column(
        children: List.generate(controller.mealTimeline.length, (index) {
          final meal = controller.mealTimeline[index];
          final isFirst = index == 0;
          final isLast = index == controller.mealTimeline.length - 1;

          IconData icon = Icons.restaurant_rounded;
          Color iconColor = const Color(0xffFF7A00);
          
          if (meal['title'] == 'Breakfast') {
            icon = Icons.emoji_food_beverage_rounded;
            iconColor = const Color(0xff00FF87);
          } else if (meal['title'] == 'Lunch') {
            icon = Icons.lunch_dining_rounded;
            iconColor = const Color(0xffFF7A00);
          } else if (meal['title'] == 'Dinner') {
            icon = Icons.soup_kitchen_rounded;
            iconColor = const Color(0xffFF3E3E);
          } else if (meal['title'] == 'Evening Snack' || meal['title'] == 'Snacks' || meal['title'] == 'Mid Meal') {
            icon = Icons.local_drink_rounded;
            iconColor = const Color(0xffB100FF);
          }

          final int mealTypeId = meal['meal_id'] ?? 0;
          final bool isCompleted = controller.completedMealIds.contains(mealTypeId);

          var timelineState = TimelineState.active;
          if (isCompleted) {
            timelineState = TimelineState.completed;
          } else if (isPast || isFuture) {
            timelineState = TimelineState.upcomingGrey;
          }

          return buildTimelineRow(
            dotColor: iconColor,
            state: timelineState,
            isFirst: isFirst,
            isLast: isLast,
            child: buildMealCard(
              context: context,
              title: meal['title'],
              desc: meal['desc'],
              details: meal['details'],
              icon: icon,
              iconColor: iconColor,
              timeText: isCompleted ? "Done" : (isPast ? "Missed" : "Daily target"),
              timeColor: isCompleted ? const Color(0xff00FF87) : (isPast ? const Color(0xffFF3E3E) : iconColor.withOpacity(0.7)),
              hasActions: true,
              mealId: meal['id'],
              mealTypeId: mealTypeId,
              isCompleted: isCompleted,
              isPast: isPast,
              isFuture: isFuture,
              foods: meal['foods'],
              onTap: () {
                // Click opens detail
              },
            ),
          );
        }),
      );
    });
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
    required BuildContext context,
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
    int? mealId,
    int? mealTypeId,
    bool isCompleted = false,
    bool isPast = false,
    bool isFuture = false,
    List? foods,
    VoidCallback? onTap,
  }) {
    // 1. Dynamically compute total macros for premium detailed visualization
    double totalCalories = 0.0;
    double totalProtein = 0.0;
    double totalCarbs = 0.0;
    double totalFat = 0.0;
    double totalFiber = 0.0;

    if (foods != null) {
      for (var f in foods) {
        if (f == null) continue;
        totalCalories += double.tryParse(f['calories']?.toString() ?? '0') ?? 0;
        totalProtein += double.tryParse(f['protein']?.toString() ?? '0') ?? 0;
        totalCarbs += double.tryParse(f['carbs']?.toString() ?? '0') ?? 0;
        totalFat += double.tryParse(f['fat']?.toString() ?? '0') ?? 0;
        totalFiber += double.tryParse(f['fiber']?.toString() ?? '0') ?? 0;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xff120D2C).withOpacity(0.85),
              const Color(0xff090416).withOpacity(0.95),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.03),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ROW (Rounded Icon, Title, Status badge)
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xff090414),
                      border: Border.all(
                        color: iconColor.withOpacity(0.20),
                        width: 1.2,
                      ),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          desc,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.60),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badges
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xff00FF87).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Completed",
                            style: GoogleFonts.inter(
                              color: const Color(0xff00FF87),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.check_circle_outline_rounded, color: Color(0xff00FF87), size: 10),
                        ],
                      ),
                    )
                  else if (isPast)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xffFF3B30).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Absent",
                            style: GoogleFonts.inter(
                              color: const Color(0xffFF3B30),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.cancel_outlined, color: Color(0xffFF3B30), size: 10),
                        ],
                      ),
                    )
                  else if (isFuture)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Upcoming",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.40),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.lock_clock_outlined, color: Colors.white.withOpacity(0.40), size: 10),
                        ],
                      ),
                    )
                  else if (timeText != null)
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
                ],
              ),

              // INDIVIDUAL FOOD ITEMS (Clean, non-repetitive layout)
              if (foods != null && foods.isNotEmpty) ...[
                const SizedBox(height: 14),
                Divider(color: Colors.white.withOpacity(0.06), height: 1),
                const SizedBox(height: 10),
                Column(
                  children: foods.map((f) {
                    final foodDetails = f['food_details'] ?? {};
                    final String foodName = foodDetails['food_name'] ?? 'Food Item';
                    final double cal = double.tryParse(f['calories']?.toString() ?? '0.0') ?? 0.0;
                    final qty = f['quantity'] ?? '1 serving';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  foodName,
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.90),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Qty: $qty",
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.40),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "${cal.toInt()} kcal",
                              style: GoogleFonts.inter(
                                color: const Color(0xffFF7A00).withOpacity(0.9),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              // MACROS TARGET SUMMARY GRID
              const SizedBox(height: 14),
              Divider(color: Colors.white.withOpacity(0.06), height: 1),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildCardMacroChip("Calories", "${totalCalories.toInt()} kcal", const Color(0xffFF7A00)),
                    const SizedBox(width: 8),
                    _buildCardMacroChip("Protein", "${totalProtein.toInt()}g", const Color(0xff00FF87)),
                    const SizedBox(width: 8),
                    _buildCardMacroChip("Carbs", "${totalCarbs.toInt()}g", const Color(0xff00E5FF)),
                    const SizedBox(width: 8),
                    _buildCardMacroChip("Fat", "${totalFat.toInt()}g", const Color(0xffFF00D4)),
                  ],
                ),
              ),

              // ACTIONS FOOTER (Full width premium layout)
              if (hasActions) ...[
                const SizedBox(height: 14),
                Divider(color: Colors.white.withOpacity(0.06), height: 1),
                const SizedBox(height: 12),
                isCompleted
                    ? Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xff00FF87).withOpacity(0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xff00FF87).withOpacity(0.15),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Completed Successfully",
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xff00FF87),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.check_circle_rounded, color: Color(0xff00FF87), size: 14),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () async {
                                if (mealId != null && mealTypeId != null) {
                                  final success = await controller.unmarkMealAsCompleted(mealId, mealTypeId);
                                  if (success) {
                                    Get.snackbar(
                                      "Meal Unmarked ↩️",
                                      "Removed $title from today's summary.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: const Color(0xff0B0817).withOpacity(0.9),
                                      colorText: Colors.white,
                                      borderColor: const Color(0xffFF3B30).withOpacity(0.3),
                                      borderWidth: 1,
                                      margin: const EdgeInsets.all(16),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFF3B30).withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xffFF3B30).withOpacity(0.18),
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Undo Log",
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xffFF3B30),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.undo_rounded, color: Color(0xffFF3B30), size: 13),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : (isPast || isFuture)
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: () async {
                              if (mealId != null && mealTypeId != null) {
                                final success = await controller.markMealAsCompleted(mealId, mealTypeId);
                                if (success) {
                                  RocketLaunchOverlay.show(context, mealTitle: title);
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xffFF00D4), Color(0xffB100FF)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xffFF00D4).withOpacity(0.20),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Mark Meal as Completed",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 14),
                                ],
                              ),
                            ),
                          ),
              ],
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

  Widget _buildCardMacroChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.12), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 7.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: GoogleFonts.outfit(
                  color: color,
                  fontSize: 11.5,
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
