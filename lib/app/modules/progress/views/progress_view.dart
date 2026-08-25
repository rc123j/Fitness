import 'dart:math';
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
                              _buildTodayReport(),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xff00FF87).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xff00FF87).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.history_rounded, color: Color(0xff00FF87), size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "History",
                        style: GoogleFonts.outfit(
                          color: const Color(0xff00FF87),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
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
                child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
              )
            ],
          )
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
                colors: [
                  const Color(0xff1C1533),
                  const Color(0xff0D0818),
                ],
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

  Widget _buildTodayReport() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xff1C1533),
            const Color(0xff0D0818),
          ],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Report",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xff00FF87).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xff00FF87).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff00FF87),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Live",
                      style: GoogleFonts.outfit(
                        color: const Color(0xff00FF87),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator(color: Color(0xffB100FF))),
              );
            }

            final consumed = controller.todayConsumedCalories.value;
            final target = controller.targetCalories.value;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCalorieRing(consumed, target),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildMacroBar(
                        "Protein",
                        controller.todayConsumedProtein.value,
                        controller.todayTargetProtein.value,
                        const Color(0xff00A2FF),
                      ),
                      const SizedBox(height: 14),
                      _buildMacroBar(
                        "Carbs",
                        controller.todayConsumedCarbs.value,
                        controller.todayTargetCarbs.value,
                        const Color(0xffFF7A00),
                      ),
                      const SizedBox(height: 14),
                      _buildMacroBar(
                        "Fat",
                        controller.todayConsumedFat.value,
                        controller.todayTargetFat.value,
                        const Color(0xffFF00E5),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCalorieRing(int consumed, int target) {
    final double ratio = target > 0 ? consumed / target : 0.0;

    Color ringColor = const Color(0xff00FF87);
    String statusLabel = "On Track";
    if (ratio < 0.5) {
      ringColor = const Color(0xffFF7A00);
      statusLabel = "Keep Going";
    } else if (ratio > 1.1) {
      ringColor = const Color(0xffFF3E3E);
      statusLabel = "Over Target";
    }

    return SizedBox(
      width: 148,
      height: 148,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(148, 148),
            painter: CalorieRingPainter(progress: ratio, color: ringColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$consumed",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              Text(
                "/ $target kcal",
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                statusLabel,
                style: GoogleFonts.outfit(
                  color: ringColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBar(String label, int consumed, int target, Color color) {
    final double ratio = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${consumed}g / ${target}g",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: ratio,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.6)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeightTracker() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xff1C1533),
            const Color(0xff0D0818),
          ],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weight Tracker",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => _showLogWeightSheet(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffB100FF), Color(0xffFF00E5)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "Log Weight",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
                        "Current Weight",
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: diffColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: diffColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          hasLost ? Icons.trending_down_rounded : Icons.trending_up_rounded,
                          color: diffColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${diff.abs().toStringAsFixed(1)} kg ${hasLost ? 'Lost' : 'Gained'}",
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
          const SizedBox(height: 20),
          SizedBox(
            height: 90,
            child: Obx(() {
              if (controller.weightHistory.length < 2) {
                return Center(
                  child: Text(
                    "Log at least two weigh-ins to see your trend.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
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

  void _showLogWeightSheet() {
    final textController = TextEditingController(
      text: controller.currentWeight.value > 0
          ? controller.currentWeight.value.toStringAsFixed(1)
          : '',
    );

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Color(0xff121220),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Log Today's Weight",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Keep this up to date to track your real progress.",
              style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.5), fontSize: 13),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: textController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                suffixText: "kg",
                suffixStyle: GoogleFonts.outfit(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoggingWeight.value
                      ? null
                      : () async {
                          final value = double.tryParse(textController.text.trim());
                          if (value == null || value <= 0) {
                            Get.snackbar(
                              "Invalid Weight",
                              "Please enter a valid weight in kg.",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          final success = await controller.logWeight(value);
                          if (success) Get.back();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffB100FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: controller.isLoggingWeight.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Save Weight",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
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

class CalorieRingPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0+ (can exceed 1 when over target)
  final Color color;

  CalorieRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    const strokeWidth = 12.0;

    // Background track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc (capped visually at 100%; ring glows past that via color change)
    final sweep = (progress.clamp(0.0, 1.0)) * 2 * pi;
    if (sweep > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final progressPaint = Paint()
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: sweep,
          colors: [color.withOpacity(0.4), color],
          transform: const GradientRotation(-pi / 2),
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -pi / 2, sweep, false, progressPaint);

      // Soft glow at the leading edge
      final glowPaint = Paint()
        ..color = color.withOpacity(0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, -pi / 2, sweep, false, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CalorieRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class WeightTrendPainter extends CustomPainter {
  final List<Map<String, dynamic>> history;

  WeightTrendPainter({required this.history});

  @override
  void paint(Canvas canvas, Size size) {
    if (history.length < 2) return;

    final weights = history.map((e) => (e['weight'] as num).toDouble()).toList();
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

class WeeklyAdherencePainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final int targetCalories;

  WeeklyAdherencePainter({required this.data, required this.targetCalories});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final int maxCal = data.map((e) => e['calories'] as int).reduce(max);
    final int maxValue = max(maxCal, targetCalories) + 200;

    final double barWidth = (size.width / data.length) * 0.4;
    final double spacing = size.width / data.length;

    // Target dotted line
    final double targetY =
        size.height - (targetCalories / maxValue) * size.height;
    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, targetY),
        Offset(startX + 5, targetY),
        dashPaint,
      );
      startX += 10;
    }

    for (int i = 0; i < data.length; i++) {
      final cal = data[i]['calories'] as int;
      final double barHeight = (cal / maxValue) * size.height;
      final double x = (i * spacing) + (spacing / 2) - (barWidth / 2);
      final double y = size.height - barHeight;

      Color barColor = const Color(0xff00FF87);
      if (cal > targetCalories + 100) {
        barColor = const Color(0xffFF3E3E);
      } else if (cal < targetCalories - 300) {
        barColor = const Color(0xffFF7A00);
      }

      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(6),
      );

      canvas.drawRRect(barRect, Paint()..color = barColor);

      final textSpan = TextSpan(
        text: data[i]['day'],
        style: GoogleFonts.outfit(
          color: Colors.white.withOpacity(0.6),
          fontSize: 10,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth / 2) - (textPainter.width / 2), size.height + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
