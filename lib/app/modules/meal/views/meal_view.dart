import 'dart:convert';
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
          // Background Glow Blobs (mocking the purple design shade on appbars side)
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffB100FF).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              height: 300,
              width: 300,
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
                    const Color(0xffB100FF).withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 1. App Bar
                _buildAppBar(),

                // 2. Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Weekly Calendar Timeline (mocking selected Capsule design)
                        _buildWeeklyCalendar(),
                        const SizedBox(height: 28),

                        // Today's Nutrition Section (mocking the mockups' Calories ring & Macro cards layout)
                        _buildTodayNutritionCard(),
                        const SizedBox(height: 24),

                        // Check Calories Search Bar
                        _buildSearchBox(),
                        const SizedBox(height: 28),

                        // Daily Meal Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Daily Meal",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed('/meal-plan'),
                              child: Row(
                                children: [
                                  Text(
                                    "Edit plan ",
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Icon(
                                    Icons.edit_calendar_rounded,
                                    size: 14,
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Promo customization Card
                        _buildPromoCard(),
                        const SizedBox(height: 16),

                        // Meal Timeline Cards List
                        _buildMealsTimeline(context),
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

  // 1. APP BAR
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          Text(
            "Nutrition",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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

  // 2. WEEKLY CALENDAR (mocking Capsule design from mockup)
  Widget _buildWeeklyCalendar() {
    final now = DateTime.now();
    // Generate dates for current week (Monday to Sunday)
    final int currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday
    final List<DateTime> weekDates = List.generate(7, (index) {
      return now.subtract(Duration(days: currentWeekday - 1 - index));
    });

    final List<String> weekdays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final DateTime date = weekDates[index];
        final String dayName = weekdays[index];
        final String dayNum = date.day.toString();
        final String dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

        return Obx(() {
          final isSelected = controller.selectedQueryDate.value == dateStr ||
              (controller.selectedQueryDate.value.isEmpty &&
                  date.day == now.day &&
                  date.month == now.month &&
                  date.year == now.year);

          if (isSelected) {
            // Selected Day: Dark capsule container card with subtle borders
            return Container(
              height: 72,
              width: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayNum,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Unselected Day: Plain text items
            return GestureDetector(
              onTap: () {
                controller.selectedQueryDate.value = dateStr;
                controller.fetchMealData();
              },
              child: Container(
                height: 72,
                width: 44,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dayNum,
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
      }),
    );
  }

  // 3. TODAY'S NUTRITION CARD (mocking left mockup screen)
  Widget _buildTodayNutritionCard() {
    return Obx(() {
      final double kcalProgress = controller.targetCalories.value > 0
          ? (controller.currentCalories.value / controller.targetCalories.value).clamp(0.0, 1.0)
          : 0.0;
      final double proteinProgress = controller.targetProtein.value > 0
          ? (controller.consumedProtein.value / controller.targetProtein.value).clamp(0.0, 1.0)
          : 0.0;
      final double carbsProgress = controller.targetCarbs.value > 0
          ? (controller.consumedCarbs.value / controller.targetCarbs.value).clamp(0.0, 1.0)
          : 0.0;
      final double fatProgress = controller.targetFat.value > 0
          ? (controller.consumedFat.value / controller.targetFat.value).clamp(0.0, 1.0)
          : 0.0;

      final int calPercentage = (kcalProgress * 100).toInt();

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xff0B0817).withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.04),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Calorie numeric info (left) vs flame percentage ring (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Nutrition",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _formatNumber(controller.currentCalories.value),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          " /${_formatNumber(controller.targetCalories.value)} kcal",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Ring with Fire Icon
                Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 52,
                        width: 52,
                        child: CircularProgressIndicator(
                          value: kcalProgress,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffFF00E5)),
                          strokeWidth: 4.5,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("🔥", style: TextStyle(fontSize: 11)),
                          const SizedBox(width: 1),
                          Text(
                            "$calPercentage%",
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
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Row 2: 3 Horizontal Macro Cards
            Row(
              children: [
                Expanded(
                  child: _buildMacroCard(
                    label: "Protein",
                    consumed: controller.consumedProtein.value,
                    target: controller.targetProtein.value,
                    progress: proteinProgress,
                    color: const Color(0xffFF00E5),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMacroCard(
                    label: "Carbs",
                    consumed: controller.consumedCarbs.value,
                    target: controller.targetCarbs.value,
                    progress: carbsProgress,
                    color: const Color(0xff00FF87),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMacroCard(
                    label: "Fats",
                    consumed: controller.consumedFat.value,
                    target: controller.targetFat.value,
                    progress: fatProgress,
                    color: const Color(0xffFFD166),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMacroCard({
    required String label,
    required int consumed,
    required int target,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.45),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "$consumed / ${target}g",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Small horizontal progress indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 3,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.05),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int val) {
    if (val >= 1000) {
      final double formatted = val / 1000.0;
      return formatted.toStringAsFixed(1).replaceAll('.0', '') + "k";
    }
    return val.toString();
  }

  // 4. CHECK CALORIES SEARCH BOX
  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.3), size: 20),
              const SizedBox(width: 12),
              Text(
                "Check calories",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Icon(Icons.qr_code_scanner_rounded, color: Colors.white.withOpacity(0.4), size: 20),
        ],
      ),
    );
  }

  // 5. PROMO CARD (Customize Grocery List)
  Widget _buildPromoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xff2A1649),
            const Color(0xff120D23).withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: const Color(0xffB100FF).withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "It's time to customize your\nGrocery list & Recipes ➔",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white.withOpacity(0.4),
                      size: 12,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Nov 26 - Nov 30",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Floating graphics (apples, broccolis) on the right
          Positioned(
            right: 12,
            bottom: 8,
            top: 8,
            child: Row(
              children: [
                const Text("🥦", style: TextStyle(fontSize: 34)),
                const SizedBox(width: 4),
                Transform.rotate(
                  angle: 0.2,
                  child: const Text("🍎", style: TextStyle(fontSize: 34)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 6. MEALS LIST TIMELINE
  Widget _buildMealsTimeline(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00FF87)),
            ),
          ),
        );
      }

      if (controller.mealTimeline.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff0B0817).withOpacity(0.55),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Center(
            child: Text(
              "No active meal plans found.",
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.mealTimeline.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final meal = controller.mealTimeline[index];
          final int mealTypeId = meal['meal_id'] ?? 0;
          final bool isCompleted = controller.completedMealIds.contains(mealTypeId);

          // Get total foods details and clean names
          final List foods = meal['foods'] ?? [];
          final String foodDesc = foods.isNotEmpty
              ? foods.map((f) => f['food_details']?['food_name'] ?? '').join(', ')
              : 'Tap to configure foods';

          final double targetKcal = double.tryParse(meal['target_calories']?.toString() ?? '') ?? 300.0;

          // Placeholder illustration based on meal slot
          String emoji = "🥗";
          if (meal['title'] == 'Breakfast') {
            emoji = "🥣";
          } else if (meal['title'] == 'Lunch') {
            emoji = "🍱";
          } else if (meal['title'] == 'Dinner') {
            emoji = "🍲";
          } else if (meal['title'] == 'Pre-Workout' || meal['title'] == 'Post-Workout') {
            emoji = "🍌";
          }

          return GestureDetector(
            onTap: () => Get.toNamed('/meal-detail', arguments: {
              "dietPlanMealId": meal['id'],
              "mealId": mealTypeId,
              "title": meal['title'],
              "foods": foods,
              "isCompleted": isCompleted,
              "targetKcal": targetKcal,
            }),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: const Color(0xff0B0817).withOpacity(0.55),
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xff00FF87).withOpacity(0.15)
                      : Colors.white.withOpacity(0.04),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Log status Checkbox
                  GestureDetector(
                    onTap: () {
                      if (isCompleted) {
                        controller.unmarkMealAsCompleted(meal['id'], mealTypeId);
                      } else {
                        controller.markMealAsCompleted(meal['id'], mealTypeId);
                      }
                    },
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? const Color(0xff00FF87) : Colors.transparent,
                        border: Border.all(
                          color: isCompleted
                              ? Colors.transparent
                              : Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.black, size: 14)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Meal details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "15 min • ${targetKcal.toInt()} kcal",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          meal['title'],
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          foodDesc,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Rounded image box on right
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.06),
                        width: 0.8,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
