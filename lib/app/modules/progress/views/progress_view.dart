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
import '../../../widgets/calorie_bar_chart.dart';

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
                Expanded(
                  child: ScrollNavBarBinder(
                    builder: (context, scrollController) => Obx(() {
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
                              AppShimmer(
                                enabled: controller.isLoading.value,
                                child: _buildGreeting(),
                              ),
                              const SizedBox(height: 24),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  AppShimmer(
                                    enabled: controller.isLoading.value,
                                    child: _buildJourneyProgressCard(),
                                  ),
                                  Positioned(
                                    top: -152,
                                    right: 8,
                                    child: Image.asset(
                                      'assets/progress/boyontop.png',
                                      height: 155,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/profile/avatar.png',
                                              height: 155,
                                              fit: BoxFit.contain,
                                              errorBuilder: (c, e, s) =>
                                                  const SizedBox.shrink(),
                                            );
                                          },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              AppShimmer(
                                enabled: controller.isLoading.value,
                                child: Column(
                                  children: [
                                    _buildDisciplineBanner(),
                                    const SizedBox(height: 24),
                                    _buildAnalyticsTabs(),
                                    const SizedBox(height: 24),
                                    _buildStartingSnapshot(),
                                  ],
                                ),
                              ),
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

  String _timeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning,";
    if (hour < 17) return "Good Afternoon,";
    if (hour < 21) return "Good Evening,";
    return "Good Night,";
  }

  Widget _buildGreeting() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: const Padding(
            padding: EdgeInsets.only(right: 16.0, top: 4.0),
            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _timeBasedGreeting(),
                style: GoogleFonts.outfit(
                  color: const Color(0xffB100FF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    "${controller.userName.value.isNotEmpty ? controller.userName.value.split(' ')[0] : 'Rahul'}!",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("👋", style: TextStyle(fontSize: 24)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Small steps today,\nstronger you tomorrow.",
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJourneyProgressCard() {
    return Container(
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xffFF00E5).withOpacity(0.25), // light gradient top
            Colors.transparent,
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: const Color(0xff151520),
          image: const DecorationImage(
            image: AssetImage('assets/progress/cardbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Journey Progress",
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "${controller.daysRemaining.value}",
                            style: GoogleFonts.outfit(
                              color: const Color(0xffFF00E5),
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Days Left",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "of your 30-day goal",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
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
                            widthFactor: controller.currentDay.value / 30.0,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffB100FF),
                                    Color(0xffFF7A00),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${controller.currentDay.value} Days Completed",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: CircularProgressIndicator(
                            value: controller.currentDay.value / 30.0,
                            strokeWidth: 8,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xffFF7A00),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  "${((controller.currentDay.value / 30) * 100).toInt()}",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "%",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Complete",
                              style: GoogleFonts.outfit(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
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
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Analytics Tab Switcher
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAnalyticsTabs() {
    const tabs = [
      'Today\'s Nutrition',
      'Weekly Calories',
      // 'Weight Tracker', // commented out per request
    ];
    const icons = [
      Icons.donut_large_rounded,
      Icons.bar_chart_rounded,
      // Icons.monitor_weight_outlined,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Tab pill row ──────────────────────────────────────────────────
        Obx(() {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(tabs.length, (i) {
                final isSelected = controller.selectedTab.value == i;
                return GestureDetector(
                  onTap: () => controller.selectedTab.value = i,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.only(
                      right: i < tabs.length - 1 ? 10 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xffB100FF)
                          : const Color(0xff1C1533),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xffB100FF)
                            : Colors.white.withOpacity(0.1),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xffB100FF).withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icons[i],
                          size: 14,
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tabs[i],
                          style: GoogleFonts.outfit(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.55),
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        }),
        const SizedBox(height: 20),
        // ── Tab content ───────────────────────────────────────────────────
        Obx(() {
          switch (controller.selectedTab.value) {
            case 0:
              return Column(
                children: [
                  _buildTodayNutritionCard(),
                  const SizedBox(height: 16),
                  _buildStreakAndTipCards(),
                ],
              );
            case 1:
              return _buildWeeklyCalorieChart();
            // case 2:
            //   return _buildWeightTracker();
            default:
              return const SizedBox.shrink();
          }
        }),
      ],
    );
  }

  Widget _buildDisciplineBanner() {
    return const _MotivationCarousel();
  }

  Widget _buildTodayNutritionCard() {
    final int carbs = controller.todayConsumedCarbs.value.toInt();
    final int protein = controller.todayConsumedProtein.value.toInt();
    final int fat = controller.todayConsumedFat.value.toInt();
    final int targetCarbs = controller.todayTargetCarbs.value.toInt();
    final int targetProtein = controller.todayTargetProtein.value.toInt();
    final int targetFat = controller.todayTargetFat.value.toInt();

    final double proteinProgress = targetProtein > 0
        ? (protein / targetProtein).clamp(0.0, 1.0)
        : 0.0;
    final double carbsProgress = targetCarbs > 0
        ? (carbs / targetCarbs).clamp(0.0, 1.0)
        : 0.0;
    final double fatProgress = targetFat > 0
        ? (fat / targetFat).clamp(0.0, 1.0)
        : 0.0;

    final int currentCalories = controller.todayConsumedCalories.value.toInt();
    final int targetCalories = controller.targetCalories.value.toInt();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: const Color(0xff120D23).withOpacity(0.8),
        border: Border.all(color: Colors.white, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: TodayNutritionBgPainter()),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xffB100FF,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.local_fire_department_rounded,
                                color: Color(0xffFF7A00),
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Today's Nutrition",
                              style: GoogleFonts.outfit(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Text(
                            "$currentCalories/$targetCalories kcal",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 116,
                          height: 116,
                          child: CustomPaint(
                            painter: _MacroRingPainter(
                              carbsProgress: carbsProgress,
                              proteinProgress: proteinProgress,
                              fatProgress: fatProgress,
                              carbsColor: const Color(0xffFF7A00),
                              proteinColor: const Color(0xff00A2FF),
                              fatColor: const Color(0xffFF00E5),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "$currentCalories",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "of $targetCalories kcal",
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            children: [
                              _buildMacroLegendItem(
                                "Carbs",
                                carbs,
                                targetCarbs,
                                carbsProgress,
                                const Color(0xffFF7A00),
                              ),
                              const SizedBox(height: 16),
                              _buildMacroLegendItem(
                                "Protein",
                                protein,
                                targetProtein,
                                proteinProgress,
                                const Color(0xff00A2FF),
                              ),
                              const SizedBox(height: 16),
                              _buildMacroLegendItem(
                                "Fat",
                                fat,
                                targetFat,
                                fatProgress,
                                const Color(0xffFF00E5),
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
  }

  Widget _buildMacroLegendItem(
    String label,
    int value,
    int target,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              target > 0 ? "${value}g / ${target}g" : "${value}g",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakAndTipCards() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 11, child: _buildStreakCard()),
          const SizedBox(width: 12),
          Expanded(flex: 10, child: _buildTipCard()),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFFF3E0), // Light orange
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            top: -1,
            child: const Text("🏆", style: TextStyle(fontSize: 60)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Keep the Streak!",
                  style: GoogleFonts.outfit(
                    color: const Color(0xffC06B1F),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Text(
                    "${controller.currentStreak.value} Days 🔥",
                    style: GoogleFonts.outfit(
                      color: const Color(0xff8D490B),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You're doing great!",
                  style: GoogleFonts.outfit(
                    color: const Color(0xff8D490B).withOpacity(0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() {
                  final history = controller.weeklyAdherenceData;
                  if (history.isEmpty) return const SizedBox();

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      bool isCompleted = history[index]['isAdherent'] == true;
                      String dayStr = (history[index]['day'] as String);
                      String dayInitial = dayStr.isNotEmpty
                          ? dayStr.substring(0, 1)
                          : "D";

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isCompleted
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xffF27121),
                                  size: 16,
                                )
                              : Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                          const SizedBox(height: 4),
                          Text(
                            dayInitial,
                            style: GoogleFonts.outfit(
                              color: const Color(0xff8D490B),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffEEECFF), // Light purple
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0,
            bottom: -5,
            child: const Text("💧", style: TextStyle(fontSize: 60)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xffB100FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Today's Tip",
                      style: GoogleFonts.outfit(
                        color: const Color(0xff702F9A),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Drink more water and stay consistent with your meals.",
                  style: GoogleFonts.outfit(
                    color: const Color(0xff4A2066),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Weekly calorie trend — dynamic bar chart
  Widget _buildWeeklyCalorieChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff120D23).withOpacity(0.8),
        border: Border.all(color: Colors.white, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffFF7A00).withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Obx(() {
        final list = controller.weeklyAdherenceData.toList();
        if (list.isEmpty) {
          return const SizedBox(
            height: 220,
            child: Center(
              child: CircularProgressIndicator(color: Color(0xffB100FF)),
            ),
          );
        }

        double totalCal = 0;
        int activeDays = 0;
        for (var day in list) {
          double cal = double.tryParse(day['calories']?.toString() ?? '0') ?? 0;
          if (cal > 0) {
            totalCal += cal;
            activeDays++;
          }
        }
        int avgCal = activeDays > 0 ? (totalCal / activeDays).round() : 0;
        int target = controller.targetCalories.value;

        String formatNum(int n) {
          return n.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Average",
                      style: GoogleFonts.inter(
                        color: const Color(0xffB100FF).withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          formatNum(avgCal),
                          style: GoogleFonts.outfit(
                            color: const Color(0xffB100FF),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "kcal",
                          style: GoogleFonts.inter(
                            color: const Color(0xffB100FF).withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Goal",
                      style: GoogleFonts.inter(
                        color: const Color(0xffFF7A00).withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          formatNum(target),
                          style: GoogleFonts.outfit(
                            color: const Color(0xffFF7A00),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "kcal",
                          style: GoogleFonts.inter(
                            color: const Color(0xffFF7A00).withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const AllTimeProgressView()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Text(
                      "View All",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 160,
              width: double.infinity,
              child: CustomPaint(
                painter: CalorieBarChartPainter(
                  history: list,
                  target: target.toDouble(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xffB100FF),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Calories Consumed",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  width: 24,
                  height: 2,
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: DashedLinePainter(color: const Color(0xffFF7A00)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Target",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildWeightTracker() {
    return Obx(() {
      final current = controller.currentWeight.value;
      final diff = controller.weightDifferenceKg.value;
      final ibw = controller.ibw.value;
      final hasLost = diff >= 0;
      final diffColor = diff == 0
          ? Colors.white54
          : (hasLost ? const Color(0xff00FF87) : const Color(0xffFF7A00));

      final history = controller.weightHistory.toList();
      final List<double> weights = history
          .map((e) => (e['weight'] as num?)?.toDouble() ?? 0.0)
          .where((w) => w > 0)
          .toList();

      final double highest = weights.isNotEmpty ? weights.reduce(max) : 0;
      final double lowest = weights.isNotEmpty ? weights.reduce(min) : 0;

      final List<Map<String, dynamic>> insights = [];
      if (diff > 0) {
        insights.add({
          'icon': Icons.trending_down_rounded,
          'color': const Color(0xff00FF87),
          'title': 'You are on the right track!',
          'sub':
              'You\'ve lost ${diff.toStringAsFixed(1)} kg since you started.',
        });
      } else if (diff < 0) {
        insights.add({
          'icon': Icons.trending_up_rounded,
          'color': const Color(0xffFF7A00),
          'title': 'Keep an eye on your intake!',
          'sub':
              'You\'ve gained ${diff.abs().toStringAsFixed(1)} kg. Adjust your meals.',
        });
      }
      if (ibw > 0 && current > 0) {
        final double away = (current - ibw).abs();
        insights.add({
          'icon': Icons.flag_rounded,
          'color': const Color(0xff00A2FF),
          'title': 'Keep going!',
          'sub':
              '${away.toStringAsFixed(1)} kg away from your ideal weight (${ibw.toStringAsFixed(1)} kg).',
        });
      }
      insights.add({
        'icon': Icons.stars_rounded,
        'color': const Color(0xffFFD166),
        'title': 'Consistency is key',
        'sub':
            'Maintain your progress with balanced nutrition and regular activity.',
      });

      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff1C1533), Color(0xff0D0818)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffB100FF).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.monitor_weight_outlined,
                      color: Color(0xffB100FF),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'WEIGHT TRACKER',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffFF7A00).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffFF7A00).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'Estimated',
                      style: GoogleFonts.outfit(
                        color: const Color(0xffFF7A00),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Current weight headline ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Weight',
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          current > 0
                              ? '${current.toStringAsFixed(1)} kg'
                              : '--',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (diff != 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              hasLost
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              color: diffColor,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${diff.abs().toStringAsFixed(1)} kg',
                              style: GoogleFonts.outfit(
                                color: diffColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'vs start weight',
                          style: GoogleFonts.inter(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Trend chart ─────────────────────────────────────────────────
            if (weights.length >= 2) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: WeightTrendPainter(history: history),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: history.map((e) {
                    final dateStr = e['date']?.toString() ?? '';
                    String label = '';
                    try {
                      final d = DateTime.parse(dateStr);
                      label = '${d.day} ${_monthAbbr(d.month)}';
                    } catch (_) {
                      label = dateStr.length > 5
                          ? dateStr.substring(5)
                          : dateStr;
                    }
                    return Text(
                      label,
                      style: GoogleFonts.inter(
                        color: Colors.white38,
                        fontSize: 9,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Text(
                  'Complete at least 2 days of meals to see your weight trend.',
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 20),

            // ── Stats row: Highest / Lowest / Goal ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildWeightStat(
                      'Highest',
                      highest > 0 ? '${highest.toStringAsFixed(1)} kg' : '--',
                      const Color(0xffFF7A00),
                    ),
                  ),
                  Container(width: 1, height: 36, color: Colors.white12),
                  Expanded(
                    child: _buildWeightStat(
                      'Lowest',
                      lowest > 0 ? '${lowest.toStringAsFixed(1)} kg' : '--',
                      const Color(0xff00FF87),
                    ),
                  ),
                  Container(width: 1, height: 36, color: Colors.white12),
                  Expanded(
                    child: _buildWeightStat(
                      'Goal',
                      ibw > 0 ? '${ibw.toStringAsFixed(1)} kg' : '--',
                      const Color(0xff00A2FF),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Weight Insights ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.06)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xffB100FF),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'WEIGHT INSIGHTS',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...insights.map(
                    (ins) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (ins['color'] as Color).withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              ins['icon'] as IconData,
                              color: ins['color'] as Color,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ins['title'] as String,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ins['sub'] as String,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    height: 1.4,
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
            ),
          ],
        ),
      );
    });
  }

  Widget _buildWeightStat(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _monthAbbr(int month) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return m[(month - 1).clamp(0, 11)];
  }

  Widget _buildStartingSnapshot() {
    return Obx(() {
      double pctIbw = 100.0;
      if (controller.ibw.value > 0) {
        pctIbw =
            (controller.startingWeight.value / controller.ibw.value) * 100.0;
      }
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
                child: _buildMetricReportCard(
                  title: "BMR",
                  value: "${controller.bmr.value.toInt()}",
                  unit: "kcal",
                  desc: "Basal Metabolic Rate",
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xffFF5F6D),
                  bgImage: "assets/new_images1/bmr.png",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricReportCard(
                  imageLeft: 25,
                  imageTop: -35,
                  imageBottom: -35,
                  title: "IDEAL WEIGHT",
                  value: controller.ibw.value.toStringAsFixed(1),
                  unit: "kg",
                  desc: "Devine Formula (IBW)",
                  icon: Icons.monitor_weight_outlined,
                  color: const Color(0xff7B61FF),
                  bgImage: "assets/new_images1/ideal_weight.png",
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricReportCard(
                  imageRight: -20,
                  imageTop: -30,
                  imageBottom: -30,
                  title: "DAILY TDEE",
                  value: "${controller.tdee.value.toInt()}",
                  unit: "kcal",
                  desc: "Total Daily Energy\nExpenditure",
                  icon: Icons.bolt_rounded,
                  color: const Color(0xff00E5FF),
                  bgImage: "assets/new_images1/daily_tdeee.png",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricReportCard(
                  imageRight: -5,
                  title: "WEIGHT RATIO",
                  value: "${pctIbw.toInt()}",
                  unit: "%",
                  desc: "Current / Ideal Weight",
                  icon: Icons.show_chart_rounded,
                  color: const Color(0xffFF7A00),
                  bgImage: "assets/new_images1/weight ratio.png",
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildMetricReportCard({
    required String title,
    required String value,
    required String unit,
    required String desc,
    required IconData icon,
    required Color color,
    required String bgImage,
    double? imageTop,
    double? imageBottom,
    double? imageRight,
    double? imageLeft,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xff151520),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.0),
        ),
        child: Stack(
          children: [
            // Background Image shifted
            Positioned(
              top: imageTop ?? -10,
              bottom: imageBottom ?? -10,
              right: imageLeft != null ? null : (imageRight ?? -30),
              left: imageLeft,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  const Color(0xff151520).withOpacity(0.3),
                  BlendMode.darken,
                ),
                child: Image.asset(bgImage, fit: BoxFit.fitHeight),
              ),
            ),
            // Gradient Overlay and Content
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xff151520).withOpacity(0.8),
                      const Color(0xff151520).withOpacity(0.2),
                      const Color(0xff151520).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              value,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              unit,
                              style: GoogleFonts.outfit(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(height: 2, width: 24, color: color),
                        const SizedBox(height: 12),
                        Text(
                          desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

class _MotivationCarousel extends StatefulWidget {
  const _MotivationCarousel({Key? key}) : super(key: key);

  @override
  State<_MotivationCarousel> createState() => _MotivationCarouselState();
}

class _MotivationCarouselState extends State<_MotivationCarousel> {
  final List<String> _quotes = [
    "Discipline today, results tomorrow.",
    "Consistency is the key to success.",
    "Small steps every day.",
    "Push yourself, because no one else will.",
    "Sweat now, shine later."
  ];
  int _currentIndex = 0;
  late final PageController _pageController;
  late final Stream<int> _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Stream.periodic(const Duration(seconds: 4), (i) => i);
    _timer.listen((_) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _quotes.length;
        });
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff1C1533),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffFF7A00).withOpacity(0.2),
            ),
            child: const Icon(
              Icons.track_changes_rounded,
              color: Color(0xffFF7A00),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 20,
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _quotes.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Text(
                    _quotes[index],
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white54,
            size: 14,
          ),
        ],
      ),
    );
  }
}

class AllTimeProgressView extends StatelessWidget {
  const AllTimeProgressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: SafeArea(
        child: GetX<ProgressController>(
          builder: (controller) {
            final list = controller.allTimeAdherenceData.toList();
            if (list.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xffB100FF)),
              );
            }

            double totalCal = 0;
            int activeDays = 0;
            for (var day in list) {
              double cal = double.tryParse(day['calories']?.toString() ?? '0') ?? 0;
              if (cal > 0) {
                totalCal += cal;
                activeDays++;
              }
            }
            int avgCal = activeDays > 0 ? (totalCal / activeDays).round() : 0;
            int target = controller.targetCalories.value;

            String formatNum(int n) {
              return n.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              );
            }

            final chartWidth = max(Get.width - 40, list.length * 40.0 + 40.0);

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
                      ),
                      Text(
                        "All-Time Progress",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 24), // to balance the back button
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: const Color(0xff120D23).withOpacity(0.8),
                      border: Border.all(color: Colors.white, width: 1.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Average",
                                  style: GoogleFonts.inter(
                                    color: const Color(0xffB100FF).withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      formatNum(avgCal),
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xffB100FF),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "kcal",
                                      style: GoogleFonts.inter(
                                        color: const Color(0xffB100FF).withOpacity(0.7),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Goal",
                                  style: GoogleFonts.inter(
                                    color: const Color(0xffFF7A00).withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      formatNum(target),
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xffFF7A00),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "kcal",
                                      style: GoogleFonts.inter(
                                        color: const Color(0xffFF7A00).withOpacity(0.7),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 300, // making chart taller for full screen
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true, // starts scrolled to the right (most recent)
                            child: SizedBox(
                              width: chartWidth,
                              child: CustomPaint(
                                painter: CalorieBarChartPainter(
                                  history: list,
                                  target: target.toDouble(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xffB100FF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Calories Consumed",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Container(
                              width: 24,
                              height: 2,
                              color: Colors.transparent,
                              child: CustomPaint(
                                painter: DashedLinePainter(color: const Color(0xffFF7A00)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Target",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

