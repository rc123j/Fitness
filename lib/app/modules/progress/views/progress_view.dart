import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/progress_controller.dart';
import '../../meal/views/nutrition_history_view.dart';
import '../../meal/bindings/meal_binding.dart';
import '../../../widgets/app_shimmer.dart';
import '../../../widgets/scroll_nav_bar_binder.dart';

class ProgressView extends GetView<ProgressController> {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          // Background Glow Blobs (Matching Meal Screen)
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
            top: 200,
            right: -100,
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
                    const Color(0xff00FF87).withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ScrollNavBarBinder(
                    builder: (context, scrollController) => Obx(() {
                      if (controller.isLoading.value) {
                        return _buildLoadingState();
                      }

                      return RefreshIndicator(
                        color: const Color(0xffB100FF),
                        backgroundColor: const Color(0xff121220),
                        onRefresh: controller.fetchProgressData,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 18,
                            bottom: 100,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              _buildJourneyHeaderCard(),
                              const SizedBox(height: 24),
                              _buildTransformationGallery(),
                              const SizedBox(height: 24),
                              _buildTodayNutritionCard(),
                              const SizedBox(height: 24),
                              _buildWeeklyCalorieChart(),
                              const SizedBox(height: 24),
                              _buildWeightTracker(),
                              const SizedBox(height: 24),
                              _buildStartingSnapshot(),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "30-Day Journey",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Trust the process. See the results.",
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.to(
                  () => const NutritionHistoryView(),
                  binding: MealBinding(),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff00FF87).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xff00FF87).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.history_rounded,
                        color: Color(0xff00FF87),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "History",
                        style: GoogleFonts.outfit(
                          color: const Color(0xff00FF87),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(
                  Icons.share_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const AppShimmer(
      enabled: true,
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          children: [
            SizedBox(height: 200, width: double.infinity, child: Card()),
            SizedBox(height: 20),
            SizedBox(height: 250, width: double.infinity, child: Card()),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xffB100FF),
              size: 64,
            ),
            const SizedBox(height: 24),
            Text(
              "Journey Locked",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Activate your personalized 30-day diet plan to unlock your transformation dashboard.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffB100FF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                // Navigate to home or plan purchase
                Get.offAllNamed('/home');
              },
              child: Text(
                "Activate Plan",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyHeaderCard() {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            height: 180,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xff1C1533), const Color(0xff0D0818)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffB100FF).withOpacity(0.16),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Days Left",
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "${controller.daysRemaining.value}",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      " / 30",
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: controller.currentDay.value / 30,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xffB100FF), Color(0xffFF00E5)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xffB100FF).withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Container(
                height: 82,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xffFF7A00).withOpacity(0.16),
                      const Color(0xffFF7A00).withOpacity(0.04),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xffFF7A00).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xffFF7A00).withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: Color(0xffFF7A00),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${controller.currentStreak.value}",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          "Streak",
                          style: GoogleFonts.outfit(
                            color: const Color(0xffFF7A00),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 82,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xff00FF87).withOpacity(0.16),
                      const Color(0xff00FF87).withOpacity(0.04),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xff00FF87).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xff00FF87).withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: Color(0xff00FF87),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${controller.dietCompliance.value}%",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          "Compliance",
                          style: GoogleFonts.outfit(
                            color: const Color(0xff00FF87),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
      ],
    );
  }

  Widget _buildTransformationGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Transformation Gallery",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed('/progress-photos'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffB100FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xffB100FF).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Manage",
                      style: GoogleFonts.outfit(
                        color: const Color(0xffB100FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xffB100FF),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.transformationPhotos.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final key = controller.transformationPhotos.keys.elementAt(index);
              final url = controller.transformationPhotos[key] ?? '';

              return GestureDetector(
                // Tapping a frame opens the dedicated Progress Photos screen
                // (where the actual upload/replace/remove actions live).
                onTap: () => Get.toNamed('/progress-photos'),
                child: Container(
                  width: 130,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xff1B1430),
                        const Color(0xff0D0818),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: url.isNotEmpty
                          ? const Color(0xffB100FF).withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (url.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                const Icon(Icons.error, color: Colors.red),
                          ),
                        )
                      else
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.white54,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Upload",
                              style: GoogleFonts.outfit(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                      // Label
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                            ),
                            color: Colors.black.withOpacity(0.7),
                          ),
                          child: Text(
                            key,
                            textAlign: TextAlign.center,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Today's Nutrition card — moved here from the Meal screen, which showed
  // the exact same "today vs target" data (both read the same
  // /logs/today endpoint) via a differently-styled card. One canonical
  // place for it now, on Progress.
  static const Color _proteinColor = Color(0xffFFD166);
  static const Color _carbsColor = Color(0xff00FF87);
  static const Color _fatColor = Color(0xffB100FF);

  Widget _buildTodayNutritionCard() {
    return Obx(() {
      final double proteinProgress = controller.todayTargetProtein.value > 0
          ? (controller.todayConsumedProtein.value /
                    controller.todayTargetProtein.value)
                .clamp(0.0, 1.0)
          : 0.0;
      final double carbsProgress = controller.todayTargetCarbs.value > 0
          ? (controller.todayConsumedCarbs.value /
                    controller.todayTargetCarbs.value)
                .clamp(0.0, 1.0)
          : 0.0;
      final double fatProgress = controller.todayTargetFat.value > 0
          ? (controller.todayConsumedFat.value /
                    controller.todayTargetFat.value)
                .clamp(0.0, 1.0)
          : 0.0;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xff120D23).withOpacity(0.8),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: TodayNutritionBgPainter()),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Nutrition",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          Text(
                            "${_formatNumber(controller.todayConsumedCalories.value)}/${_formatNumber(controller.targetCalories.value)} kcal",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // Segmented macro ring + legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: _buildMacroRing(
                              currentCalories:
                                  controller.todayConsumedCalories.value,
                              proteinProgress: proteinProgress,
                              carbsProgress: carbsProgress,
                              fatProgress: fatProgress,
                            ),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildLegendRow(
                                  "${controller.todayConsumedCarbs.value}g",
                                  "Carbs",
                                  _carbsColor,
                                ),
                                const SizedBox(height: 24),
                                _buildLegendRow(
                                  "${controller.todayConsumedProtein.value}g",
                                  "Protein",
                                  _proteinColor,
                                ),
                                const SizedBox(height: 24),
                                _buildLegendRow(
                                  "${controller.todayConsumedFat.value}g",
                                  "Fat",
                                  _fatColor,
                                ),
                              ],
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
    });
  }

  // Ring split into three 120°-ish arcs (Carbs, Protein, Fat), each filled
  // according to that macro's own progress toward its target.
  Widget _buildMacroRing({
    required int currentCalories,
    required double proteinProgress,
    required double carbsProgress,
    required double fatProgress,
  }) {
    return SizedBox(
      height: 188,
      width: 188,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(188, 188),
            painter: _MacroRingPainter(
              carbsProgress: carbsProgress,
              proteinProgress: proteinProgress,
              fatProgress: fatProgress,
              carbsColor: _carbsColor,
              proteinColor: _proteinColor,
              fatColor: _fatColor,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatNumber(currentCalories),
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "kcal",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(String value, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.45),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }

  String _formatNumber(int val) {
    return val.toString();
  }

  // Weekly calorie trend — moved here from the History screen, which now
  // shows only the Meal Attendance Log. Reuses weeklyAdherenceData (already
  // fetched for streak/compliance) rather than a separate network call.
  Widget _buildWeeklyCalorieChart() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Weekly Calorie Intake vs Target",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          Obx(() {
            final list = controller.weeklyAdherenceData.toList();
            if (list.isEmpty) {
              return const SizedBox(
                height: 160,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xff00FF87),
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: CalorieHistoryChartPainter(
                      history: list,
                      target: controller.targetCalories.value.toDouble(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: list.map((day) {
                    final label = day['day']?.toString() ?? 'Log';
                    return Text(
                      label,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 9,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeightTracker() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xff1C1533), const Color(0xff0D0818)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Weight Tracker",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xffFF7A00).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xffFF7A00).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  "Estimated",
                  style: GoogleFonts.outfit(
                    color: const Color(0xffFF7A00),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() {
            final current = controller.currentWeight.value;
            final diff = controller.weightDifferenceKg.value;
            final hasLost = diff >= 0;
            final diffColor = diff == 0
                ? Colors.white54
                : (hasLost ? const Color(0xff00FF87) : const Color(0xffFF7A00));

            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        current > 0 ? "${current.toStringAsFixed(1)} kg" : "--",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Estimated Weight",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (diff != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: diffColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: diffColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          hasLost
                              ? Icons.trending_down_rounded
                              : Icons.trending_up_rounded,
                          color: diffColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "~${diff.abs().toStringAsFixed(1)} kg ${hasLost ? 'Lost' : 'Gained'}",
                          style: GoogleFonts.outfit(
                            color: diffColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(height: 10),
          Text(
            "Estimated from your logged meals — not a substitute for weighing yourself.",
            style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: Obx(() {
              if (controller.weightHistory.length < 2) {
                return Center(
                  child: Text(
                    "Complete at least 2 days of meals to see your estimated trend.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                );
              }
              return CustomPaint(
                size: const Size(double.infinity, 90),
                painter: WeightTrendPainter(history: controller.weightHistory),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStartingSnapshot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Starting Health Snapshot",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricMiniCard(
                "Starting Weight",
                "${controller.startingWeight.value} kg",
                const Color(0xff00A2FF),
                Icons.monitor_weight_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricMiniCard(
                "Target BMI",
                "${controller.bmi.value}",
                const Color(0xffFF00E5),
                Icons.speed_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricMiniCard(
                "Ideal Weight",
                "${controller.ibw.value} kg",
                const Color(0xff00FF87),
                Icons.accessibility_new_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricMiniCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.14), color.withOpacity(0.03)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Paints a ring split into three rounded arcs (Carbs, Protein, Fat), each
// filled clockwise from the top according to that macro's own progress.
// Moved here from the Meal screen along with _buildTodayNutritionCard.
class _MacroRingPainter extends CustomPainter {
  final double carbsProgress;
  final double proteinProgress;
  final double fatProgress;
  final Color carbsColor;
  final Color proteinColor;
  final Color fatColor;

  static const double _strokeWidth = 14.0;
  static const double _gapDegrees = 10.0;
  static const double _segmentDegrees = 120.0 - _gapDegrees;

  _MacroRingPainter({
    required this.carbsProgress,
    required this.proteinProgress,
    required this.fatProgress,
    required this.carbsColor,
    required this.proteinColor,
    required this.fatColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - _strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final segments = [
      (progress: carbsProgress, color: carbsColor),
      (progress: proteinProgress, color: proteinColor),
      (progress: fatProgress, color: fatColor),
    ];

    for (int i = 0; i < segments.length; i++) {
      final startDeg = -90.0 + (i * 120.0) + (_gapDegrees / 2);
      final startRad = startDeg * pi / 180;
      final sweepRad = _segmentDegrees * pi / 180;
      final color = segments[i].color;
      final progress = segments[i].progress.clamp(0.0, 1.0);

      final bgPaint = Paint()
        ..color = color.withOpacity(0.14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startRad, sweepRad, false, bgPaint);

      if (progress > 0) {
        final fgPaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = _strokeWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(rect, startRad, sweepRad * progress, false, fgPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MacroRingPainter oldDelegate) {
    return oldDelegate.carbsProgress != carbsProgress ||
        oldDelegate.proteinProgress != proteinProgress ||
        oldDelegate.fatProgress != fatProgress;
  }
}

class TodayNutritionBgPainter extends CustomPainter {
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
        ..strokeWidth = 1.2,
    );
    canvas.drawLine(
      Offset(px, py),
      Offset(px - 2, py + 4),
      Paint()
        ..color = Colors.white.withOpacity(0.50)
        ..strokeWidth = 1.0,
    );
    canvas.drawLine(
      Offset(px, py),
      Offset(px + 2, py + 4),
      Paint()
        ..color = Colors.white.withOpacity(0.50)
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WeightTrendPainter extends CustomPainter {
  final List<Map<String, dynamic>> history;

  WeightTrendPainter({required this.history});

  @override
  void paint(Canvas canvas, Size size) {
    if (history.length < 2) return;

    final weights = history
        .map((e) => (e['weight'] as num).toDouble())
        .toList();
    final double minW = weights.reduce(min);
    final double maxW = weights.reduce(max);
    // Pad the range so a flat trend line doesn't hug the top/bottom edges.
    final double range = (maxW - minW).abs() < 0.5 ? 1.0 : (maxW - minW);
    final double paddedMin = minW - (range * 0.15);
    final double paddedRange = range * 1.3;

    final double stepX = size.width / (weights.length - 1);
    final points = <Offset>[];
    for (int i = 0; i < weights.length; i++) {
      final double x = i * stepX;
      final double normalized = (weights[i] - paddedMin) / paddedRange;
      final double y = size.height - (normalized * size.height);
      points.add(Offset(x, y));
    }

    // Filled area under the line for a softer, more polished look.
    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xffB100FF).withOpacity(0.25),
            const Color(0xffB100FF).withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // The trend line itself.
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xffB100FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Dots at each entry, with the latest one highlighted.
    for (int i = 0; i < points.length; i++) {
      final isLast = i == points.length - 1;
      canvas.drawCircle(
        points[i],
        isLast ? 5 : 3,
        Paint()..color = isLast ? const Color(0xffFF00E5) : Colors.white,
      );
      if (isLast) {
        canvas.drawCircle(
          points[i],
          8,
          Paint()
            ..color = const Color(0xffFF00E5).withOpacity(0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant WeightTrendPainter oldDelegate) =>
      oldDelegate.history != history;
}

// Moved here from the History screen along with _buildWeeklyCalorieChart.
class CalorieHistoryChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> history;
  final double target;

  CalorieHistoryChartPainter({required this.history, required this.target});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    // Draw horizontal grid line representing target threshold
    final targetPaint = Paint()
      ..color = const Color(0xffFF3B30).withOpacity(0.3)
      ..strokeWidth = 1.0;

    // Draw target baseline text
    final textPainter = TextPainter(
      text: TextSpan(
        text: "Target: ${target.toInt()} kcal",
        style: GoogleFonts.inter(
          color: const Color(0xffFF3B30).withOpacity(0.6),
          fontSize: 8,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double maxVal = max(
      target,
      history
          .map(
            (day) => double.tryParse(day['calories']?.toString() ?? '0') ?? 0.0,
          )
          .reduce(max),
    );
    if (maxVal == 0) maxVal = 2000.0;

    double targetY = h - ((target / maxVal) * (h - 20)) - 10;
    canvas.drawLine(Offset(0, targetY), Offset(w, targetY), targetPaint);
    textPainter.paint(canvas, Offset(4, targetY - 12));

    // Plot intake curve
    final List<double> calories = history
        .map(
          (day) => double.tryParse(day['calories']?.toString() ?? '0.0') ?? 0.0,
        )
        .toList();
    if (calories.isEmpty) return;

    double stepX = w / (calories.length - 1 == 0 ? 1 : calories.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < calories.length; i++) {
      double x = i * stepX;
      double y = h - ((calories[i] / maxVal) * (h - 20)) - 10;
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points[0].dx, points[0].dy);
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

    // Fill area under line
    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, h)
      ..lineTo(points.first.dx, h)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xff00FF87).withOpacity(0.08), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(fillPath, fillPaint);

    // Draw main glowing green chart line
    final linePaint = Paint()
      ..color = const Color(0xff00FF87)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Draw dots and calorie numbers
    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      final calVal = calories[i].toInt();

      // Outer glow circle
      canvas.drawCircle(
        pt,
        5,
        Paint()..color = const Color(0xff00FF87).withOpacity(0.25),
      );
      // Inner circle
      canvas.drawCircle(pt, 2, Paint()..color = Colors.white);

      if (calVal > 0) {
        final valPainter = TextPainter(
          text: TextSpan(
            text: "$calVal",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        valPainter.paint(
          canvas,
          Offset(pt.dx - valPainter.width / 2, pt.dy - 14),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
