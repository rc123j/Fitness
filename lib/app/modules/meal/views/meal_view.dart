import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/meal_controller.dart';
import '../../../widgets/app_shimmer.dart';

class MealView extends GetView<MealController> {
  const MealView({super.key});

  // Hero image based on user's progress or generic healthy lifestyle theme
  String _getHeroImageUrl() {
    return 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1200&q=80';
  }

  String _getMealImageUrl(String title) {
    final t = title.toLowerCase();
    if (t.contains('breakfast')) {
      return 'https://images.unsplash.com/photo-1493770348161-369560ae357d?auto=format&fit=crop&w=600&q=80';
    } else if (t.contains('lunch')) {
      return 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80';
    } else if (t.contains('dinner')) {
      return 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80';
    } else {
      return 'https://images.unsplash.com/photo-1490885578174-acda8905c2c6?auto=format&fit=crop&w=600&q=80';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          // Background Glow Blobs
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

          // Main scrollable content
          Positioned.fill(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. COLLAPSIBLE APP BAR
                _buildSliverAppBar(),

                // 2. MAIN SCROLLABLE BODY
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
                  sliver: SliverToBoxAdapter(
                    child: Obx(() => AppShimmer(
                      enabled: controller.isLoading.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Weekly Calendar Timeline
                          _buildWeeklyCalendar(),
                          const SizedBox(height: 28),

                          // Today's Nutrition Section
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
                                "Daily Meals",
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
                          const SizedBox(height: 20),

                          // Consolidated Meal Timeline List
                          _buildMealsTimeline(context),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1. SLIVER APP BAR
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: const Color(0xff06010F),
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 0.8,
            ),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 14),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          width: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 0.8,
            ),
          ),
          child: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _getHeroImageUrl(),
              fit: BoxFit.cover,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    const Color(0xff06010F).withOpacity(0.6),
                    const Color(0xff06010F),
                  ],
                  stops: const [0.4, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          "Nutrition Plan",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 18, bottom: 16),
      ),
    );
  }

  // 2. WEEKLY CALENDAR
  Widget _buildWeeklyCalendar() {
    final now = DateTime.now();
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

  // 3. TODAY'S NUTRITION CARD
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

            // 3 Horizontal Macro Cards
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

  // 5. PROMO CARD
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
                  "Customize Grocery List &\nexplore clinical recipes ➔",
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

  // 6. CONSOLIDATED MEAL TIMELINE
  Widget _buildMealsTimeline(BuildContext context) {
    return Obx(() {
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
          final int dietPlanMealId = meal['id'] ?? 0;
          final Map<int, List<dynamic>> optionFoods = Map<int, List<dynamic>>.from(meal['optionFoods'] ?? {});
          final String mealTitle = meal['title'] ?? 'Meal Slot';

          return Obx(() {
            final int selectedOpt = controller.selectedOptions[dietPlanMealId] ?? 1;
            final bool isCompleted = controller.completedMealIds.contains(mealTypeId);
            final bool isExpanded = controller.expandedMealIds.contains(dietPlanMealId);
            final List foodsOfSelectedOption = optionFoods[selectedOpt] ?? [];

            // Calculate option macros
            double totalProtein = 0.0;
            double totalCarbs = 0.0;
            double totalFat = 0.0;
            double activeKcal = 0.0;

            for (var f in foodsOfSelectedOption) {
              if (f == null) continue;
              totalProtein += double.tryParse(f['protein']?.toString() ?? '0') ?? 0;
              totalCarbs += double.tryParse(f['carbs']?.toString() ?? '0') ?? 0;
              totalFat += double.tryParse(f['fat']?.toString() ?? '0') ?? 0;
              activeKcal += double.tryParse(f['calories']?.toString() ?? '0') ?? 0;
            }

            final double targetKcal = activeKcal > 0 ? activeKcal : (double.tryParse(meal['target_calories']?.toString() ?? '') ?? 300.0);

            // Get option name from first food Notes metadata
            String optionName = "Option $selectedOpt";
            if (foodsOfSelectedOption.isNotEmpty) {
              final firstFood = foodsOfSelectedOption.first;
              final String? notes = firstFood['notes']?.toString();
              if (notes != null && notes.isNotEmpty) {
                try {
                  final Map<String, dynamic> meta = jsonDecode(notes);
                  if (meta['option_name'] != null && meta['option_name'].toString().isNotEmpty) {
                    optionName = meta['option_name'];
                  }
                } catch (_) {}
              }
            }

            final String foodDesc = foodsOfSelectedOption.isNotEmpty
                ? foodsOfSelectedOption.map((f) => f['food_details']?['food_name'] ?? '').join(', ')
                : 'Tap to configure foods';

            String emoji = "🥗";
            final titleString = mealTitle.toLowerCase();
            if (titleString.contains('breakfast')) {
              emoji = "🥣";
            } else if (titleString.contains('lunch')) {
              emoji = "🍱";
            } else if (titleString.contains('dinner')) {
              emoji = "🍲";
            } else if (titleString.contains('snack') || titleString.contains('mid meal')) {
              emoji = "🍇";
            } else if (titleString.contains('workout')) {
              emoji = "🥤";
            }

            final String mealImageUrl = _getMealImageUrl(mealTitle);

            return AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ROW (ALWAYS VISIBLE) ---
                    GestureDetector(
                      onTap: () {
                        if (isExpanded) {
                          controller.expandedMealIds.remove(dietPlanMealId);
                        } else {
                          controller.expandedMealIds.add(dietPlanMealId);
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            // Status checkmark indicator
                            GestureDetector(
                              onTap: () {
                                if (isCompleted) {
                                  controller.unmarkMealAsCompleted(dietPlanMealId, mealTypeId);
                                } else {
                                  controller.markMealAsCompleted(dietPlanMealId, mealTypeId, selectedOption: selectedOpt);
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

                            // Text Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    mealTitle,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isExpanded) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      "${targetKcal.toInt()} kcal • P ${totalProtein.toInt()}g C ${totalCarbs.toInt()}g F ${totalFat.toInt()}g",
                                      style: GoogleFonts.inter(
                                        color: const Color(0xff00FF87),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),

                            // Expand Icon Indicator
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              color: Colors.white.withOpacity(0.4),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- EXPANDED DETAILS BODY ---
                    if (isExpanded) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(color: Colors.white.withOpacity(0.08), height: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Image Header inside card
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 110,
                                    width: double.infinity,
                                    child: Image.network(
                                      mealImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: const Color(0xff120D23),
                                        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 14,
                                    bottom: 12,
                                    child: Row(
                                      children: [
                                        Text(emoji, style: const TextStyle(fontSize: 18)),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Exchange Options",
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
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
                            const SizedBox(height: 16),

                            // 2. Macronutrient distributes chips
                            _buildMacroSummaryChips(totalProtein, totalCarbs, totalFat),
                            const SizedBox(height: 18),

                            // 3. Detailed Included items and swaps
                            Text(
                              "Included Items & Swaps",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildFoodItemsSection(foodsOfSelectedOption, optionFoods),
                            const SizedBox(height: 20),

                            // 4. Action Log Button
                            _buildLogButton(dietPlanMealId, mealTypeId, isCompleted, selectedOpt),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          });
        },
      );
    });
  }



  // Macro Summary Chips Row
  Widget _buildMacroSummaryChips(double protein, double carbs, double fat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildMiniMacroChip("Protein", "${protein.toInt()}g", const Color(0xffFFD166))),
        const SizedBox(width: 6),
        Expanded(child: _buildMiniMacroChip("Carbs", "${carbs.toInt()}g", const Color(0xff00FF87))),
        const SizedBox(width: 6),
        Expanded(child: _buildMiniMacroChip("Fat", "${fat.toInt()}g", const Color(0xffFF00E5))),
      ],
    );
  }

  Widget _buildMiniMacroChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            "$label: $value",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.65),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Foods and Swaps List
  Widget _buildFoodItemsSection(List foods, Map<int, List<dynamic>> optionFoods) {
    if (foods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        child: Text(
          "No details available.",
          style: GoogleFonts.inter(color: Colors.white30, fontSize: 11),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foods.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Divider(color: Colors.white.withOpacity(0.06), height: 1.0),
      ),
      itemBuilder: (context, index) {
        final f = foods[index];
        final String foodName = f['food_details']?['food_name'] ?? 'Food Item';
        final double kcal = double.tryParse(f['calories']?.toString() ?? '0') ?? 0.0;
        final double protein = double.tryParse(f['protein']?.toString() ?? '0') ?? 0.0;
        final double carbs = double.tryParse(f['carbs']?.toString() ?? '0') ?? 0.0;
        final double fat = double.tryParse(f['fat']?.toString() ?? '0') ?? 0.0;
        final String portion = "${f['serving_size']} ${f['serving_unit'] ?? f['unit'] ?? ''}";

        // Construct swaps from Option 2 and Option 3 at the same index
        final List<String> swaps = [];
        final List option2Foods = optionFoods[2] ?? [];
        final List option3Foods = optionFoods[3] ?? [];

        if (index < option2Foods.length) {
          final f2 = option2Foods[index];
          final String name2 = f2['food_details']?['food_name'] ?? '';
          final String portion2 = "${f2['serving_size']} ${f2['serving_unit'] ?? f2['unit'] ?? ''}";
          if (name2.isNotEmpty) {
            swaps.add("$name2 ($portion2)");
          }
        }

        if (index < option3Foods.length) {
          final f3 = option3Foods[index];
          final String name3 = f3['food_details']?['food_name'] ?? '';
          final String portion3 = "${f3['serving_size']} ${f3['serving_unit'] ?? f3['unit'] ?? ''}";
          if (name3.isNotEmpty) {
            swaps.add("$name3 ($portion3)");
          }
        }

        String swapText = "";
        if (swaps.isNotEmpty) {
          swapText = "Swap: " + swaps.join(" OR ");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodName,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        portion,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${kcal.toInt()} kcal • P ${protein.toInt()}g C ${carbs.toInt()}g F ${fat.toInt()}g",
                  style: GoogleFonts.inter(
                    color: const Color(0xff00FF87),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (swapText.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                swapText,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // Inline action Log Button
  Widget _buildLogButton(int dietPlanMealId, int mealTypeId, bool isCompleted, int activeOpt) {
    return GestureDetector(
      onTap: () async {
        if (isCompleted) {
          await controller.unmarkMealAsCompleted(dietPlanMealId, mealTypeId);
        } else {
          final success = await controller.markMealAsCompleted(dietPlanMealId, mealTypeId, selectedOption: activeOpt);
          if (success) {
            Get.snackbar(
              "Meal Logged 🥗",
              "Awesome job! +10 FitCoins added to your wallet.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xff0B0817).withOpacity(0.9),
              colorText: Colors.white,
              borderColor: const Color(0xff00FF87).withOpacity(0.2),
              borderWidth: 1,
            );
          }
        }
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isCompleted
              ? null
              : const LinearGradient(
                  colors: [
                    Color(0xff00FF87),
                    Color(0xffFFD166),
                  ],
                ),
          color: isCompleted ? Colors.white.withOpacity(0.06) : null,
          border: isCompleted
              ? Border.all(color: Colors.white.withOpacity(0.12), width: 1.0)
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
              color: isCompleted ? const Color(0xff00FF87) : Colors.black,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isCompleted ? "Marked as Eaten" : "Log this Meal",
              style: GoogleFonts.outfit(
                color: isCompleted ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
